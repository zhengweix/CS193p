//
//  ShapeSetGame.swift
//  sol_3
//
//  Created by Wei Zheng on 2023/8/13.
//

import SwiftUI

class SymbolSetGame: ObservableObject, ResetSetTimer {
    @Published private var model = createSetGame()
    @Published private(set) var timeRemaining: Int
    typealias Card = SetGame<SymbolShape, SymbolColor, SymbolPattern, SymbolCount>.Card
    var bonusTimeLimit: Int = 20
    init() {
        self.timeRemaining = bonusTimeLimit
        model.resetTimer = self
        startTimer()
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
        SetGame(limit: 12, total: cardContents.count) { cardContents[$0] }
    }
    
    var cards: [Card] {
        model.dealtCards
    }
    
    var scoreP1: Int {
        model.scoreP1
    }
    
    var dealt: Int {
        model.dealt
    }
    
    var total: Int {
        model.total
    }
    
    var isEnd: Bool {
        model.isEnd
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
    
    func addCards() {
        model.addCards()
    }
    
    func cheat() {
        model.cheat()
    }
    
    func restart() {
        self.timeRemaining = bonusTimeLimit
        SymbolSetGame.cardContents.shuffle()
        model = SymbolSetGame.createSetGame()
        model.resetTimer = self
    }
    
    private var timer: Timer?
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            if let timeRemaining = self?.timeRemaining, timeRemaining > 0 {
                self?.timeRemaining -= 1
            } else {
                self?.timer?.invalidate()
                self?.timer = nil
            }
        }
    }
    
    func resetSetTimer() {
        self.timeRemaining = bonusTimeLimit
    }
}

protocol ResetSetTimer: AnyObject {
    func resetSetTimer()
}

extension SymbolSetGame.SymbolColor {
    var desc: String {
        switch self {
        case .red:
            return "R"
        case .green:
            return "G"
        case .purple:
            return "P"
        }
    }
}
