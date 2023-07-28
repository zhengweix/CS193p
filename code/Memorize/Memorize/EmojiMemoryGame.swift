//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Wei Zheng on 2023/7/27.
//

import SwiftUI

class EmojiMemoryGame {
    static var emojis = ["🚗", "🛴", "✈️", "🛵", "⛵️", "🚎", "🚐", "🚛", "🛻", "🏎", "🚂", "🚊", "🚀", "🚁", "🚢", "🛶", "🛥", "🚞", "🚟", "🚃", "🚝", "🚠", "🚋", "🚌", "🚍", "🚎", "🚐", "🚑", "🚒"]
    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 4, createCardContent:  {pairIndex in
            emojis[pairIndex]
        })
    }
    private var model = createMemoryGame()
    var cards:[MemoryGame<String>.Card] {
        return model.cards
    }
}
