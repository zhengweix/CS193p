//
//  ShapeSetGame.swift
//  sol_4
//
//  Created by Wei Zheng on 2023/8/13.
//

import SwiftUI

class SymbolSetGame: ObservableObject, ResetTimer {
    typealias Card = SetGame<SymbolShape, SymbolColor, SymbolPattern, SymbolCount>.Card
    @Published private var model = createSetGame()
    @Published private(set) var timeRemaining: Int
    var bonusTimeLimit: Int = 20
    init() {
        self.timeRemaining = bonusTimeLimit
        model.resetTimer = self
    }
    
    static var cardContents: [Card.CardContent] = {
        var contents = [Card.CardContent]()
        for shape in SymbolShape.allCases {
            for color in SymbolColor.allCases {
                for pattern in SymbolPattern.allCases {
                    for count in SymbolCount.allCases {
                        contents.append(Card.CardContent(shape: shape, color: color, pattern: pattern, symbolCount: count.rawValue))
                    }
                }
            }
        }
        return contents.shuffled()
    }()
    
    static private func createSetGame() -> SetGame<SymbolShape, SymbolColor, SymbolPattern, SymbolCount> {
        SetGame(total: cardContents.count) { cardContents[$0] }
    }
    
    var cards: [Card] {
        model.cards
    }

    var dealtCards: Set<Card.ID> {
        model.dealtCards
    }
    
    var discdCards: Set<Card.ID> {
        model.discdCards
    }
    
    var matchedCards: Set<Card.ID> {
        model.matchedCards
    }
    
    var scoreP1: Int {
        model.scoreP1
    }
    
    var isGameEnd: Bool {
        model.isGameEnd()
    }
   
    enum SymbolShape: CaseIterable {
        case diamond, squiggle, oval
    }
    
    enum SymbolColor: CaseIterable {
        case red, green, purple
        func get() -> Color {
            switch self {
            case .red:
                return Color.red
            case .green:
                return Color.green
            case .purple:
                return Color.purple
            }
        }
    }
    
    enum SymbolPattern: CaseIterable {
        case outlined, solid, striped
    }
    
    enum SymbolCount: Int, CaseIterable {
        case one = 1, two, three
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func revoke(_ card: Card.ID) {
        model.revoke(card)
    }
    
    func deal(_ card: Card) {
        model.deal(card)
    }

    func dealMore() {
        model.dealMore()
    }
    
    func restart() {
        SymbolSetGame.cardContents.shuffle()
        model = SymbolSetGame.createSetGame()
        model.dealtCards.removeAll()
        model.discdCards.removeAll()
    }
    
    private var setTimer: Timer?
    func startTimer() {
        setTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            if let timeRemaining = self?.timeRemaining, timeRemaining > 0 {
                self?.timeRemaining -= 1
            } else {
                self?.setTimer?.invalidate()
                self?.setTimer = nil
            }
        }
    }
    
    func stopTimer() {
        self.setTimer?.invalidate()
        self.setTimer = nil
    }
    
    func resetTimer() {
        self.timeRemaining = bonusTimeLimit
    }
}

protocol ResetTimer: AnyObject {
    func resetTimer()
}
