//
//  SetGame.swift
//  sol_4
//
//  Created by Wei Zheng on 2023/8/13.
//

import Foundation

struct SetGame<SymbolShape, SymbolColor, SymbolPattern, SymbolCount> where SymbolShape: Hashable, SymbolColor: Hashable, SymbolPattern: Hashable {
    private var cardContent: (Int) -> Card.CardContent
    
    private(set) var total: Int
    private(set) var dealt: Int = 0 // index number of cards
    
    var cards = [Card]()
    var dealtCards = Set<Card.ID>() // cards on the stage
    var discdCards = Set<Card.ID>() // discarded cards
    var matchedCards = Set<Card.ID>() // cards for flying to discd
    private var chosenCards = Set<Card.ID>()
    
    private(set) var hasSets: Bool = false
    
    private(set) var scoreP1 = 0
    
    private var lastSetTime = Date()
    
    var bonusTimeLimit: Int = 20
    var resetTimer: ResetTimer?
    
    init(total: Int, content: @escaping (Int) -> Card.CardContent) {
        self.total = total
        self.cardContent = content
        for i in 0..<total {
            cards.append(Card(id: i, content: content(i)))
        }
    }
    
    func isGameEnd() -> Bool {
        if dealtCards.count + discdCards.count < 81 {
            return false
        }
        if dealtCards.count == 3 && hasSets(dealtCards){
            return true
        }
        return !hasSets(dealtCards)
    }
    
    func isSet(_ cardIDs: Set<Card.ID>) -> Bool {
        var shapes = Set<SymbolShape>()
        var colors = Set<SymbolColor>()
        var patterns = Set<SymbolPattern>()
        var counts = Set<Int>()
        cardIDs.forEach { cardID in
            if let chosenIndex = cards.firstIndex(where: { $0.id == cardID }) {
                let card = cards[chosenIndex]
                shapes.insert(card.content.shape)
                colors.insert(card.content.color)
                patterns.insert(card.content.pattern)
                counts.insert(card.content.symbolCount)
            }
        }
        return shapes.count != 2 && colors.count != 2 && patterns.count != 2 && counts.count != 2
    }
    
    func hasSets(_ dealtCards: Set<Card.ID>) -> Bool {
        if dealtCards.count > 2 {
            for i in 0..<dealtCards.count - 2 {
                for j in (i+1)..<dealtCards.count - 1 {
                    for k in (j+1)..<dealtCards.count {
                        if isSet([i, j, k]) {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    
    mutating func choose(_ card: Card) {
        // chosen cards not forms a set
        if chosenCards.count == 3 {
            resetChosenCards()
        }
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            if cards[chosenIndex].isChosen {
                cards[chosenIndex].isChosen = false
                chosenCards.remove(card.id)
            } else {
                cards[chosenIndex].isChosen = true
                chosenCards.insert(card.id)
                if chosenCards.count == 3 {
                    if isGameEnd() {
                        matchedCards = chosenCards
                    } else {
                        if isSet(chosenCards) {
                            let newSetTime = Date()
                            scoreP1 += 3 * max(bonusTimeLimit - Int(newSetTime.timeIntervalSince(lastSetTime)), 1)
                            chosenCards.forEach { cardID in
                                cards[cards.firstIndex(where: { $0.id == cardID })!].isMatched = true
                            }
                            lastSetTime = newSetTime
                            resetTimer?.resetTimer()
                        } else {
                            scoreP1 -= 3 * bonusTimeLimit/2
                            chosenCards.forEach { cardID in
                                cards[cards.firstIndex(where: { $0.id == cardID })!].isMismatch = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    mutating func revoke(_ card: Card.ID) {
        discdCards.insert(card)
        if let cardIndex = cards.firstIndex(where: { $0.id == card }) {
            cards[cardIndex].isChosen = false
            cards[cardIndex].isMatched = false
        }
        dealtCards.remove(card)
        matchedCards.remove(card)
    }
    
    mutating func resetChosenCards() {
        // chosen cards forms a set
        if cards.first(where: {$0.id == chosenCards.first})!.isMatched {
            matchedCards = chosenCards
        } else {
            chosenCards.forEach { cardID in
                if let cardIndex = cards.firstIndex(where: { $0.id == cardID }) {
                    cards[cardIndex].isChosen = false
                    cards[cardIndex].isMismatch = false
                }
            }
        }
        chosenCards.removeAll()
    }
    
    mutating func deal(_ card: Card) {
        if let cardIndex = cards.firstIndex(where: { $0.id == card.id }) {
            cards[cardIndex].isFaceUp = true
        }
        dealtCards.insert(card.id)
    }
 
    mutating func dealMore() {
        if hasSets(dealtCards) {
            scoreP1 -= 3 * bonusTimeLimit/2
        }
    }
    
    struct Card: Identifiable, Equatable {
        let id: Int
        let content: CardContent
        var isFaceUp: Bool = false
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


