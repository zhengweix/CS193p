//
//  ContentView.swift
//  sol_2
//
//  Created by Wei Zheng on 2023/8/6.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var emojiMemoryGame: EmojiMemoryGame
    var body: some View {
        @State var cardCount: Int = emojiMemoryGame.cardCount
        VStack {
            Text("\(emojiMemoryGame.name.capitalized) Memorize!")
                .font(.title)
            Spacer()
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: getBestFitWidth(cardCount: cardCount)))]) {
                    ForEach(emojiMemoryGame.cards) { card in
                        CardView(card: card, choseColor: emojiMemoryGame.chosenColor, gradient: emojiMemoryGame.gradient, colorGradient: emojiMemoryGame.colorGradient)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                emojiMemoryGame.choose(card)
                            }
                    }
                }
            }
            //.foregroundColor(emojiMemoryGame.chosenColor)
            Spacer()
            HStack {
                Text("Score: \(emojiMemoryGame.score)")
                    .font(.system(size: 24))
                Spacer()
                Button {
                    emojiMemoryGame.startNewGame()
                } label: {
                    Text("New Game")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                }
            }
            
        }
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    var choseColor: Color
    var gradient: Gradient
    var colorGradient: Bool
    var body: some View {
        ZStack{
            let shape = RoundedRectangle(cornerRadius: 20)
            if colorGradient {
                if card.isFaceUp {
                    shape
                        .fill(.white)
                        .strokeBorder(choseColor, lineWidth: 3)
                    Text(card.content).font(.largeTitle)
                } else if card.isMatched {
                    shape.fill(choseColor).opacity(0.15)
                    Text(card.content).font(.largeTitle).opacity(0)
                } else {
                    shape.fill(choseColor)
                    Text(card.content).font(.largeTitle).opacity(0)
                }
            } else {
                if card.isFaceUp {
                    shape
                        .fill(.white)
                        .strokeBorder(gradient, lineWidth: 3)
                    Text(card.content).font(.largeTitle)
                } else if card.isMatched {
                    shape.fill(gradient).opacity(0.15)
                    Text(card.content).font(.largeTitle).opacity(0)
                } else {
                    shape.fill(gradient)
                    Text(card.content).font(.largeTitle).opacity(0)
                }
            }
            
        }
    }
}

func getBestFitWidth (cardCount: Int) -> CGFloat {
    switch cardCount {
    case 2:
        return 150
    case 5...12:
        return 110
    case 13...20:
        return 80
    default:
        return 65
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        ContentView(emojiMemoryGame: game)
            .preferredColorScheme(.dark)
    }
}
