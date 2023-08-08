//
//  MemoryGame.swift
//  sol_2
//
//  Created by Wei Zheng on 2023/8/6.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var score: Int = 0
    private(set) var cards: [Card]
    private var IndexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly }
        set { cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) } }
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched
        {
            var startTime: Date  = Date()
            if let potentialMatchIndex = IndexOfTheOneAndOnlyFaceUpCard {
                
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2 * max(10 - Int(Date().timeIntervalSince(startTime)), 1)
                } else {
                    if cards[potentialMatchIndex].isSeen {
                        score -= 1
                    }
                    if cards[chosenIndex].isSeen {
                        score -= 1
                    }
                }
                cards[potentialMatchIndex].isSeen = true
                cards[chosenIndex].isSeen = true
            } else {
                IndexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp = true
        }
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        // add numberOfPairsOfCards * 2 cards to cards array
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp = false
        var isMatched = false
        var isSeen = false
        let content: CardContent
        let id: Int
    }
}

extension Array {
    var oneAndOnly: Element? {
        if count == 1 {
            return first
        } else {
            return nil
        }
    }
}
