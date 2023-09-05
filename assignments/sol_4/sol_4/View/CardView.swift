//
//  CardView.swift
//  sol_4
//
//  Created by Wei Zheng on 2023/8/28.
//

import SwiftUI

struct CardView: View {
    let card: SymbolSetGame.Card
    var isDealt: Bool = true
    @State var isStrokeVisible: Bool = false
    var body: some View {
        if card.isFaceUp {
            ZStack {
                let cardBorad = RoundedRectangle(cornerRadius: 5.0)
                if isDealt {
                    cardBorad
                        .fill(.white)
                        .shadow(color: Color.gray.opacity(0.5), radius: 3, x: 1, y: 2)
                    cardBorad
                        .strokeBorder(lineWidth: DrawingConstants.effectLineWidth).foregroundColor(.white)
                        .overlay(
                            overlayContent()
                        )
                } else {
                    cardBorad
                        .fill(.white)
                    cardBorad
                        .strokeBorder(lineWidth: 1).foregroundColor(.lightGray)
                        .overlay(
                            overlayContent()
                        )
                }
                
                    
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
                }
            }
        } else {
            CardBack()
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
            let symbol: some View = createSymbol(for: card)
            ForEach(0..<card.content.symbolCount, id: \.self) { _ in
                symbol
            }
        }
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
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

extension Color {
    static let lightGray = Color(red: 225 / 255, green: 225 / 255, blue: 225 / 255)
}
