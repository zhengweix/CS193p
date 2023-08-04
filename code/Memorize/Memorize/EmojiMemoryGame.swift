//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Wei Zheng on 2023/7/27.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    private static let emojis = ["🚗", "🛴", "✈️", "🛵", "⛵️", "🚎", "🚐", "🚛", "🛻", "🏎", "🚂", "🚊", "🚀", "🚁", "🚢", "🛶", "🛥", "🚞", "🚟", "🚃", "🚝", "🚠", "🚋", "🚌", "🚍", "🚎", "🚐", "🚑", "🚒"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame(numberOfPairsOfCards: 6) { pairIndex in emojis[pairIndex] }
    }
    
    // each ModelView creates its own Model
    @Published private var model = createMemoryGame()
    
    // and declare its own var for parts that need to be available
    var cards: [Card] {
        return model.cards
    }
    
    // put functions that show user intent in the viewModel
    func choose(_ card: Card) {
        model.choose(card)
    }
}
