//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Wei Zheng on 2023/8/27.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    @StateObject var defaultDocument = EmojiArtDocument()
    @StateObject var paletteStore = PaletteStore(named: "Main")
    @StateObject var store2 = PaletteStore(named: "Alternate")
    @StateObject var store3 = PaletteStore(named: "Special")
    
    var body: some Scene {
        WindowGroup {
//            PaletteManager(
//                stores: [paletteStore, store2, store3],
//                selectedStore: paletteStore
//            )
            EmojiArtDocumentView(document: defaultDocument)
                .environmentObject(paletteStore)
        }
    }
}
