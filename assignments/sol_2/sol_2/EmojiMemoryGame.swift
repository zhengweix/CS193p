//
//  EmojiMemoryGame.swift
//  sol_2
//
//  Created by Wei Zheng on 2023/8/6.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    let names: [String] = ["animals", "food", "fruits", "chinese", "sports", "universe", "vehicles"]
    private(set) var theme: Theme
    @Published private var model: MemoryGame<String>
    
    var cards: [MemoryGame<String>.Card] {
        model.cards
    }
    
    var name: String {
        theme.name
    }
    
    var score: Int {
        model.score
    }
    
    var cardCount: Int {
        theme.num
    }
    
    var chosenColor: Color {
        theme.color
    }
    
    var colorGradient: Bool {
        theme.colorGradient
    }
    
    var gradient: Gradient = Gradient(colors: [.cyan, .teal, .pink, .mint])
    
    static func createMemoryGame(of theme: Theme) -> MemoryGame<String> {
        return MemoryGame(numberOfPairsOfCards: theme.num) { theme.emojis[$0] }
    }
    
    static func getTheme(_ name: String) -> Theme {
        let emojis = EmojiMemoryGame.getEmojis(name)
        let color = EmojiMemoryGame.getColor()
        var num = emojis.count
        if name == "vehicles" {
            num = Int.random(in: 2..<emojis.count)
        }
        return Theme(name: name, color: color, emojis: emojis.shuffled(), num: num, colorGradient: Bool.random())
    }
    
    static func getEmojis(_ name: String) -> [String] {
        switch name {
            case "vehicles":
                return ["🚗", "🛴", "✈️", "🛵", "⛵️", "🚎", "🚐", "🚛", "🛻", "🏎", "🚂", "🚊", "🚀", "🚁", "🛥", "🚞", "🚐", "🚑", "🚒"]
            case "animals":
                return ["🐭", "🐂", "🐅", "🐇", "🐉", "🐍", "🐎", "🐐", "🐒", "🐓", "🐕", "🐖"]
            case "food":
                return ["🍔", "🍕", "🍟", "🍤", "🍗", "🍖", "🍦", "🍩", "🍪", "🍰", "🧁", "🍺", "🍷", "🥤", "🍸", "🍹"]
            case "fruits":
                return ["🍎", "🍌", "🍉", "🍇", "🍓", "🍈", "🍋", "🍊", "🍍", "🍑", "🍒", "🍏", "🍐", "🍋", "🍎", "🍍"]
            case "chinese":
                return ["🧧", "🏮", "🍵", "🀄", "🪭", "🍵", "🥢", "🧨", "🍜", "🥮", "🍚", "🥟", "🍲", "🥡", "🍱"]
            case "sports":
                return ["⚽", "🏀", "🏈", "⚾", "🎾", "🏐", "🏉", "🎱", "🏓", "🏸",  "🥅", "⛳", "🪀", "🏹", "🎽", "🛹", "🪂"]
            case "universe":
                return ["🌏", "🪐", "🌕", "🌙", "🌚", "🌛", "🌞", "🌟", "✨", "☄️", "💫", "🛸", "🌌"]
            default:
                return ["🚗", "🛴", "✈️", "🛵", "⛵️", "🚎", "🚐", "🚛", "🛻", "🏎", "🚂", "🚊", "🚀", "🚁", "🛥", "🚞", "🚐", "🚑", "🚒"]
        }
    }
    
    static func getColor() -> Color {
        return [.red, .orange, .yellow, .green, .blue, .indigo, .purple].randomElement()!
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func startNewGame() {
        theme = EmojiMemoryGame.getTheme(names.randomElement()!)
        model = EmojiMemoryGame.createMemoryGame(of: theme)
    }
    
    init() {
        theme = EmojiMemoryGame.getTheme(names.randomElement()!)
        model = EmojiMemoryGame.createMemoryGame(of: theme)
    }
    
    struct Theme {
        let name: String
        let color: Color
        let emojis: [String]
        let num: Int
        let colorGradient: Bool
    }
}
