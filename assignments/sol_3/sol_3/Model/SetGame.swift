//
//  SetGame.swift
//  sol_4
//
//  Created by Wei Zheng on 2023/8/13.
//

import Foundation

struct SetGame<SymbolShape, SymbolColor, SymbolPattern, SymbolCount> where SymbolShape: Hashable, SymbolColor: Hashable, SymbolPattern: Hashable {
    private var cardContent: (Int) -> Card.CardContent
    
    private(set) var limit: Int // number of displaying cards
    private(set) var total: Int
    private(set) var dealt: Int = 0 // number of dealed cards
    
    private var chosenCards = [Card]()
    private(set) var dealtCards = [Card]()
    private(set) var hintCards = [Int]() // hinted card indexes
    
    private(set) var hasSets: Bool = false
    private(set) var isEnd: Bool = false
    
    private(set) var scoreP1 = 0
    private(set) var scoreP2 = 0
    private(set) var index = 0
    
    private var lastSetTime = Date()
    
    var resetTimer: ResetSetTimer?
    var bonusTimeLimit: Int = 20
    
    init(limit: Int, total: Int, content: @escaping (Int) -> Card.CardContent) {
        self.limit = limit
        self.total = total
        self.cardContent = content
        for _ in 0..<limit {
            dealtCards.append(Card(id: dealt, content: content(dealt)))
            dealt += 1
        }
    }
    
    mutating func isSet(_ cards: [Card]) -> Bool {
        var shapes = Set<SymbolShape>()
        var colors = Set<SymbolColor>()
        var patterns = Set<SymbolPattern>()
        var counts = Set<Int>()
        
        if cards.count < 3 {
            return false
        }
        
        cards.forEach { card in
            shapes.insert(card.content.shape)
            colors.insert(card.content.color)
            patterns.insert(card.content.pattern)
            counts.insert(card.content.symbolCount)
        }
        
        return shapes.count != 2 && colors.count != 2 && patterns.count != 2 && counts.count != 2
    }
    
    mutating func hasSets(_ cards: [Card]) -> Bool {
        if cards.isEmpty {
            return false
        }
        for i in 0..<cards.count - 2 {
            for j in (i+1)..<cards.count - 1 {
                for k in (j+1)..<cards.count {
                    if isSet([cards[i], cards[j], cards[k]]) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    mutating func findSets(_ cards: [Card]) -> [Card]? {
        if cards.isEmpty {
            return nil
        }
        for i in 0..<cards.count - 2 {
            for j in (i+1)..<cards.count - 1 {
                for k in (j+1)..<cards.count {
                    if isSet([cards[i], cards[j], cards[k]]) {
                        return [cards[i], cards[j], cards[k]]
                    }
                }
            }
        }
        return nil
    }
    
    mutating func isEnd(in dealtCards: [Card]) -> Bool {
        if dealt < total {
            return false
        }
        return !hasSets(dealtCards)
    }
    
    mutating func choose(_ card: Card) {
        resetHintCards()
        if chosenCards.count == 3 {
            resetDealtCards()
        }
        isEnd = isEnd(in: dealtCards)
        if let chosenIndex = dealtCards.firstIndex(where: { $0.id == card.id }) {
            if dealtCards[chosenIndex].isChosen {
                dealtCards[chosenIndex].isChosen = false
                chosenCards.remove(at: chosenCards.firstIndex(of: dealtCards[chosenIndex])!)
            } else {
                dealtCards[chosenIndex].isChosen = true
                chosenCards.append(dealtCards[chosenIndex])
                if chosenCards.count == 3 {
                    if isSet(chosenCards) {
                        let newSetTime = Date()
                        scoreP1 += 3 * max(bonusTimeLimit - Int(newSetTime.timeIntervalSince(lastSetTime)), 1)
                        chosenCards.forEach { card in
                            dealtCards[dealtCards.firstIndex(of: card)!].isMatched = true
                        }
                        lastSetTime = newSetTime
                        resetTimer?.resetSetTimer()
                    } else {
                        scoreP1 -= 3 * bonusTimeLimit/2
                        chosenCards.forEach { card in
                            dealtCards[dealtCards.firstIndex(of: card)!].isMismatch = true
                        }
                    }
                }
            }
        }
    }
    
    mutating func resetDealtCards() {
        // chosen cards forms a set
        if dealtCards.first(where: {$0 == chosenCards.first})!.isMatched {
            chosenCards.forEach { card in
                if let cardIndex = dealtCards.firstIndex(of: card) {
                    dealtCards.remove(at: cardIndex)
                    dealCard(at: cardIndex)
                }
            }
        } else {
            chosenCards.forEach { card in
                if let cardIndex = dealtCards.firstIndex(of: card) {
                    dealtCards[cardIndex].isChosen = false
                    dealtCards[cardIndex].isMismatch = false
                }
            }
        }
        chosenCards = []
    }
    
    mutating func resetHintCards() {
        if hintCards.count > 0 {
            hintCards.forEach { index in
                dealtCards[index].isHinted = false
            }
        }
        hintCards = []
    }
    
    mutating func dealCard(at index: Int) {
        if dealt < total {
            dealtCards.insert(Card(id: dealt, content: cardContent(dealt)), at: index)
            dealt += 1
        }
    }
    
    mutating func addCards() {
        if hasSets(dealtCards) {
            scoreP1 -= 3 * bonusTimeLimit/2
        }
        let count = min(3, total-dealt)
        for _ in 0..<count {
            dealCard(at: dealtCards.endIndex)
        }
        isEnd = isEnd(in: dealtCards)
    }
    
    mutating func cheat() {
        scoreP1 -= 3 * bonusTimeLimit
        if chosenCards.count == 3 {
            resetDealtCards()
        }
        if let foundSet = findSets(dealtCards) {
            for index in 0..<foundSet.count{
                dealtCards[dealtCards.firstIndex(of: foundSet[index])!].isHinted = true
                hintCards.append(dealtCards.firstIndex(of: foundSet[index])!)
            }
        }
    }
    
    struct Card: Identifiable, Equatable {
        let id: Int
        let content: CardContent
        var isMismatch: Bool = false
        var isMatched: Bool = false
        var isChosen: Bool = false
        var isHinted: Bool = false
        
        struct CardContent {
            let shape: SymbolShape
            let color: SymbolColor
            let pattern: SymbolPattern
            let symbolCount: Int
        }
        
        static func == (lhs: SetGame<SymbolShape, SymbolColor, SymbolPattern, SymbolCount>.Card, rhs: SetGame<SymbolShape, SymbolColor, SymbolPattern, SymbolCount>.Card) -> Bool {
            lhs.id == rhs.id
        }
    }
}


