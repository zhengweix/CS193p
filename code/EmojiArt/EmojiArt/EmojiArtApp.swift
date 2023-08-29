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
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: defaultDocument)
        }
    }
}
