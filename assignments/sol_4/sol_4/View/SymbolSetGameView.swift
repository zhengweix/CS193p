//
//  ShapeSetGameView.swift
//  sol_4
//
//  Created by Wei Zheng on 2023/8/13.
//

import SwiftUI

struct SymbolSetGameView: View {
    
    @ObservedObject var game: SymbolSetGame
//    @State var deckCards = SymbolSetGame().deckCards
//    @State var dealtCards = SymbolSetGame().dealtCards// cards on the stage
//    @State var discdCards = SymbolSetGame().discdCards // discarded cards
    @Namespace private var dealingNamespace
    private let dealAnimation: Animation = .easeInOut(duration: 1)
    private let dealInterval: TimeInterval = 0.15
    
    var body: some View {
        Spacer()
        HStack(spacing: DrawingConstants.itemSpacing) {
            VStack {
                if !isGameStarted() {
                    Text("New Game")
                        .bold()
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                } else {
                    Button(action: {
                        withAnimation() {
                            game.stopTimer()
                            game.resetTimer()
                            game.restart()
                        }
                    }) {
                        Text("New Game")
                            .bold()
                            .font(.system(size: 18))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            VStack {
                Text("Score: \(game.scoreP1)")
                    .bold()
                    .foregroundColor(.green)
                    .font(.system(size: 18))
            }
            .frame(maxWidth: .infinity)
            VStack {
            }
            .frame(maxWidth: .infinity)
        }
        .foregroundColor(.blue)
        .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
        
        AspectVGrid(items: game.cards.filter(isDealt), aspectRatio: 2/3) { card in
            CardView(card: card)
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .transition(.asymmetric(insertion: .identity, removal: .identity))
                .padding(5)
                .onTapGesture {
                    chooseCard(card)
                }
        }
        
        Spacer()
        
        HStack(spacing: 0) {
            VStack {
                deckBody
            }
            .frame(maxWidth: .infinity)
            
            VStack {
                if game.isGameEnd {
                    Text("Game Over")
                        .bold()
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                } else {
                    Text("Time: \(game.timeRemaining)")
                        .bold()
                        .foregroundColor(.blue)
                        .font(.system(size: 18))
                }
            }
            .frame(maxWidth: .infinity)
            
            VStack {
                discdBody
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private func isGameStarted() -> Bool {
        return !(game.dealtCards.isEmpty && game.discdCards.isEmpty)
    }
    
    private func isUnDealt(_ card: SymbolSetGame.Card) -> Bool {
        return !game.dealtCards.contains(card.id) && !game.discdCards.contains(card.id)
    }

    private func isDealt(_ card: SymbolSetGame.Card) -> Bool {
        return game.dealtCards.contains(card.id)
    }

    private func isDiscarded(_ card: SymbolSetGame.Card) -> Bool {
        return game.discdCards.contains(card.id)
    }
    
    // MARK: - Dealing from a Deck
    private func deckCardView(for card: SymbolSetGame.Card) -> some View {
        CardView(card: card)
            .matchedGeometryEffect(id: card.id, in: dealingNamespace)
            .transition(.asymmetric(insertion: .identity, removal: .identity))
            .frame(width: 80, height: 120)
    }
    
    private func discdCardView(for card: SymbolSetGame.Card) -> some View {
        CardView(card: card, isDealt: false)
            .matchedGeometryEffect(id: card.id, in: dealingNamespace)
            .transition(.asymmetric(insertion: .identity, removal: .identity))
            .frame(width: 80, height: 120)
    }
    
    private var deckBody: some View {
        ZStack {
            ForEach(Array(game.cards.filter(isUnDealt).enumerated()), id: \.element.id) { i, card in
                deckCardView(for: card)
                    .zIndex(Double(game.cards.filter(isUnDealt).count - i))
                    .if(i < 4) {
                        $0.offset(x: 0, y: -CGFloat(4-i) * 2)
                    }
                    .if(i == game.cards.filter(isUnDealt).count-1) {
                        $0.shadow(color: Color.gray.opacity(0.5), radius: 3, x: 1, y: 2)
                    }
            }
        }
        .onTapGesture {
            dealCards()
        }
    }
    
    private var discdBody: some View {
        ZStack {
            ForEach(Array(game.cards.filter(isDiscarded).enumerated()), id: \.element.id) { i, card in
                discdCardView(for: card)
                    .if(i > game.cards.filter(isDiscarded).count-4) {
                        $0.offset(x: 0, y: CGFloat(game.cards.filter(isDiscarded).count-4-i) * 2)
                    }
                    .if(i == 0) {
                        $0.shadow(color: Color.gray.opacity(0.5), radius: 3, x: 1, y: 2)
                    }
            }
        }
    }
    
    private func chooseCard(_ card: SymbolSetGame.Card) {
        game.choose(card)
        if game.matchedCards.count == 3 {
            var delay: TimeInterval = 0.15
            for cardID in game.matchedCards {
                withAnimation(dealAnimation.delay(delay)) {
                    game.revoke(cardID)
                }
                delay += dealInterval
            }
            for card in game.cards.filter(isUnDealt)[0..<min(3, game.cards.filter(isUnDealt).count)] {
                withAnimation(dealAnimation.delay(delay)) {
                    game.deal(card)
                }
                delay += dealInterval
            }
        }
    }
    
    private func dealCards() {
        var delay: TimeInterval = 0.15
        var limit: Int
        // game is not started
        if !isGameStarted() {
            limit = 12
            game.startTimer()
        // deal more 3 cards
        } else {
            limit = 3
            game.dealMore()
        }
        for card in game.cards.filter(isUnDealt)[0..<limit] {
            withAnimation(dealAnimation.delay(delay)) {
                game.deal(card)
            }
            delay += dealInterval
        }
    }
    
    // MARK: - Drawing Constraints
    struct DrawingConstants {
        static let symbolAspectRatio: CGFloat = 2/1
        static let symbolOpacity: CGFloat = 0.7
        static let symbolCornerRadius: CGFloat = 50
        
        static let effectLineWidth: CGFloat = 3
        static let effectOpacity: CGFloat = 0.1
        static let itemSpacing: CGFloat = 20
    }
}
extension View {
    func `if`<Content: View>(_ condition: Bool, apply: (Self) -> Content) -> some View {
        if condition {
            return AnyView(apply(self))
        } else {
            return AnyView(self)
        }
    }
}

#Preview {
    SymbolSetGameView(game: SymbolSetGame())
}
