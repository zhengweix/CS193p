//
//  MemoryGame.swift
//  Memorize
//
//  Created by Wei Zheng on 2023/7/27.
//

import Foundation
struct MemoryGame<CardContent> {
    private(set) var cards: Array<Card>
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        // add numberOfPairsOfCards * 2 cards to cards array
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content))
            cards.append(Card(content: content))
        }
    }
    
    struct Card {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
    }
    
    func choose(_ card: Card) {
        
    }
}
