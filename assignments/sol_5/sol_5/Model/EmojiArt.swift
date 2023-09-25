//
//  EmojiArt.swift
//  sol_5
//
//  Created by Wei Zheng on 2023/9/16.
//
import Foundation
import CoreTransferable

struct EmojiArt {
    var background: URL?
    private(set) var emojis = [Emoji]()
    
    private var uniqueEmojiId = 0
    
    mutating func addEmoji(_ emoji: String, at position: Emoji.Position, size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(
            string: emoji,
            position: position,
            size: size,
            id: uniqueEmojiId
        ))
    }
    
    subscript(_ emojiId: Emoji.ID) -> Emoji? {
        if let index = index(of: emojiId) {
            return emojis[index]
        } else {
            return nil
        }
    }

    subscript(_ emoji: Emoji) -> Emoji {
        get {
            if let index = index(of: emoji.id) {
                return emojis[index]
            } else {
                return emoji // should probably throw error
            }
        }
        set {
            if let index = index(of: emoji.id) {
                emojis[index] = newValue
            }
        }
    }
    
    private func index(of emojiId: Emoji.ID) -> Int? {
        emojis.firstIndex(where: { $0.id == emojiId })
    }
    
    struct Emoji: Identifiable {
        let string: String
        var position: Position
        var size: Int
        var id: Int
        var isChosen: Bool = false
        
        struct Position {
            var x: Int
            var y: Int
            
            static let zero = Self(x: 0, y: 0)
        }
    }
    
    // MARK: - Sol 5
    private var chosenEmojis = Set<Emoji.ID>()
    
    mutating func choose(_ emoji: Emoji) {
        if let emojiIndex = emojis.firstIndex(where: { $0.id == emoji.id }) {
            if emoji.isChosen {
                emojis[emojiIndex].isChosen = false
                chosenEmojis.remove(emoji.id)
            } else {
                emojis[emojiIndex].isChosen = true
                chosenEmojis.insert(emoji.id)
            }
        }
    }
    
    mutating func resetChosenEmojis() {
        chosenEmojis.forEach { emojiID in
            if let emojiIndex = emojis.firstIndex(where: { $0.id == emojiID }) {
                emojis[emojiIndex].isChosen = false
            }
        }
        chosenEmojis.removeAll()
    }
}
