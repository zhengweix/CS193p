//
//  sol_2App.swift
//  sol_2
//
//  Created by Wei Zheng on 2023/8/6.
//

import SwiftUI

@main
struct sol_2App: App {
    let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            ContentView(emojiMemoryGame: game)
        }
    }
}
