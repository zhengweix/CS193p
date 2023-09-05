//
//  sol_4App.swift
//  sol_4
//
//  Created by Wei Zheng on 2023/8/28.
//

import SwiftUI

@main
struct sol_3App: App {
    let game = SymbolSetGame()
    var body: some Scene {
        WindowGroup {
            SymbolSetGameView(game: game)
        }
    }
}
