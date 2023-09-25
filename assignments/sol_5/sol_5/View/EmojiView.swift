//
//  SwiftUIView.swift
//  sol_5
//
//  Created by Wei Zheng on 2023/9/16.
//

import SwiftUI

struct EmojiView: View {
    let emoji: EmojiArt.Emoji
    var body: some View {
        let emojiText = Text(emoji.string)
        if emoji.isChosen {
            emojiText
                .font(emoji.font)
                .shadow(color: .blue, radius: 2, x: 0, y: 0)
                .shadow(color: .blue, radius: 2, x: 0, y: 0)
                .shadow(color: .blue, radius: 2, x: 0, y: 0)
                .shadow(color: .blue, radius: 2, x: 0, y: 0)
                .draggable(emoji)
        } else {
            emojiText
                .font(emoji.font)
        }
    }
}
