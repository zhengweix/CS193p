//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Wei Zheng on 2023/8/27.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: { EmojiArtDocument() }) { config in
            EmojiArtDocumentView(document: config.document)
        }
    }
}
