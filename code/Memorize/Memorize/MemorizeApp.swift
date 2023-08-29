//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Wei Zheng on 2023/7/26.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
