//
//  sol_5App.swift
//  sol_5
//
//  Created by Wei Zheng on 2023/9/16.
//

import SwiftUI

@main
struct sol_5App: App {
    @StateObject var defaultDocument = EmojiArtDocument()
    @StateObject var paletteStore = PaletteStore(named: "Main")

    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: defaultDocument)
                .environmentObject(paletteStore)
        }
    }
}
