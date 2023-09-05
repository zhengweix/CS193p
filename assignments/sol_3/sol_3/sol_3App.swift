//
//  sol_3App.swift
//  sol_3
//
//  Created by Wei Zheng on 2023/8/12.
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
