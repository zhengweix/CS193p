//
//  ShapeSetGameView.swift
//  sol_4
//
//  Created by Wei Zheng on 2023/8/13.
//

import SwiftUI

public class GlobalState: ObservableObject {
    @Published var isBiPlayer: Bool = false
    @Published var isColorBlind: Bool = false
}

public let globalState = GlobalState()

struct SymbolSetGameView: View {
    @ObservedObject var game: SymbolSetGame
    @ObservedObject var globalState1 = globalState
//    @State var isBiPlayer: Bool = false
//    @State var isColorBlind: Bool = false
    var body: some View {
        Spacer()
        HStack(spacing: DrawingConstants.itemSpacing) {
            VStack {
                Button(action: {
                    withAnimation(.easeIn(duration: 0.2)) {
    //                    twoPlayer = false
                        game.restart()
                    }
                }) {
                    Text("New Game")
                        .bold()
                        .font(.system(size: 18))
                }
            }
            .frame(maxWidth: .infinity)
            VStack {
                if game.isEnd {
                    Text("Cheat")
                        .bold()
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                } else {
                    Button(action: {
                        withAnimation(.easeIn(duration: 0.2)) {
                            game.cheat()
                        }
                    }) {
                        Text("Cheat")
                            .bold()
                            .font(.system(size: 18))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            VStack {
                HStack {
                    if game.isEnd {
                        Image(systemName: "plus.square")
                            .font(.system(size: 30))
                            .foregroundColor(.gray)
                    } else {
                        Button(action: {
                            withAnimation(.easeIn(duration: 0.2)) {
                                game.addCards()
                            }
                        }) {
                            Image(systemName: "plus.square")
                                .font(.system(size: 30))
                                .foregroundColor(.blue)
                        }
                    }
                
                    if game.isEnd {
                        Image(systemName: "eye.square")
                            .font(.system(size: 30))
                            .foregroundColor(.gray)
                    } else {
                        Button(action: {
                            withAnimation(.easeIn(duration: 0.2)) {
                                self.globalState1.isColorBlind.toggle()
                                
                            }
                        }) {
                            Image(systemName: globalState.isColorBlind ? "eye.square.fill" : "eye.square")
                                .font(.system(size: 30))
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .foregroundColor(.blue)
        .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            CardView(card: card)
                .padding(5)
                .onTapGesture {
                    game.choose(card)
                }
        }
        
        HStack(spacing: 0) {
            VStack {
                Text("Score: \(game.scoreP1)")
                    .bold()
                    .foregroundColor(.green)
                    .font(.system(size: 18))
            }
            .frame(maxWidth: .infinity)
            VStack {
                if game.isEnd {
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
//                if !twoPlayer {
//                    Button(action: {
//                        withAnimation(.easeIn(duration: 0.2)) {
//                            twoPlayer = true
//                        }
//                    }) {
//                        Text("Join")
//                            .bold()
//                            .foregroundColor(.orange)
//                            .font(.system(size: 18))
//                    }
//                } else {
//                    Text("Score: 0")//\(game.score)
//                        .bold()
//                        .foregroundColor(.orange)
//                        .font(.system(size: 18))
//                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    struct CardView: View {
        @ObservedObject var globalState1 = globalState
        let card: SymbolSetGame.Card
        @State var isStrokeVisible: Bool = false
        var body: some View {
            ZStack {
                let cardBorad = Rectangle()
                cardBorad
                    .fill(.white)
                    .shadow(color: Color.gray.opacity(0.5), radius: 3, x: 1, y: 2)
                cardBorad
                    .strokeBorder(lineWidth: DrawingConstants.effectLineWidth).foregroundColor(.white)
                    .overlay(
                        overlayContent()
                    )
                    
                if card.isMatched {
                    cardBorad
                        .foregroundColor(.green).opacity(DrawingConstants.effectOpacity)
                    cardBorad
                        .strokeBorder(lineWidth: DrawingConstants.effectLineWidth).foregroundColor(.green)
                } else if card.isMismatch {
                    cardBorad
                        .foregroundColor(.red).opacity(DrawingConstants.effectOpacity)
                    cardBorad
                        .strokeBorder(lineWidth: DrawingConstants.effectLineWidth).foregroundColor(.red)
                } else if card.isChosen {
                    cardBorad
                        .strokeBorder(lineWidth: DrawingConstants.effectLineWidth).foregroundColor(.blue)
                } else if card.isHinted {
                    cardBorad
                        .strokeBorder(lineWidth: DrawingConstants.effectLineWidth).foregroundColor(.green)
                        .opacity(isStrokeVisible ? 1 : 0.25)
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                isStrokeVisible.toggle()
                            }
                        }
                }
            }
        }
        
        @ViewBuilder
        func createSymbol(for card: SymbolSetGame.Card)  -> some View {
            switch card.content.shape {
            case .diamond:
                PatternBuilder(shape: Diamond(), color: card.content.color.get(), pattern: card.content.pattern, width: 2, interval: 2)
            case .oval:
                PatternBuilder(shape: Oval(), color: card.content.color.get(), pattern: card.content.pattern, width: 2, interval: 2)
            case .squiggle:
                PatternBuilder(shape: Squiggle(), color: card.content.color.get(), pattern: card.content.pattern, width: 2, interval: 2)
            }
        }
        
        @ViewBuilder
        private func overlayContent() -> some View {
            VStack {
                if globalState1.isColorBlind {
                    Text(card.content.color.desc)
                        .bold()
                        .font(.system(size: 24))
                    let symbol: some View = createSymbol(for: card)
                    ForEach(0..<card.content.symbolCount, id: \.self) { _ in
                        symbol
                    }
                } else {
                    let symbol: some View = createSymbol(for: card)
                    ForEach(0..<card.content.symbolCount, id: \.self) { _ in
                        symbol
                    }
                }
            }
            .padding(globalState1.isColorBlind ? EdgeInsets(top: 10, leading: 25, bottom: 10, trailing: 25) : EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
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

#Preview {
    SymbolSetGameView(game: SymbolSetGame())
}
