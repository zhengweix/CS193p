//
//  ContentView.swift
//  sol_1
//
//  Created by Wei Zheng on 2023/7/27.
//

import SwiftUI

struct ContentView: View {
    var sportEmojis = ["⚽", "🏀", "🏈", "⚾", "🎾", "🏐", "🏉", "🎱", "🏓", "🏸", "🏒", "🏑", "🥍", "🏏", "🥅", "⛳", "🪀", "🏹", "🎣", "🥊", "🥋", "🎽", "🛹", "🪂"]
    var foodEmojis = ["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🍈", "🍒", "🍑", "🍍", "🥥", "🥝", "🍅", "🍆", "🥑", "🍠", "🥐", "🍞", "🥖", "🥨", "🧀"]
    var travelEmojis = ["🚗", "🛴", "✈️", "🛵", "⛵️", "🚎", "🚐", "🚛", "🛻", "🏎", "🚂", "🚊", "🚀", "🚁", "🚢", "🛶", "🛥", "🚞", "🚟", "🚃", "🚝", "🚠", "🚋", "🚌", "🚍", "🚎", "🚐", "🚑", "🚒"]
    @State var selectedEmojis = ["🚗", "🛴", "✈️", "🛵", "⛵️", "🚎", "🚐", "🚛", "🛻", "🏎", "🚂", "🚊", "🚀", "🚁", "🚢", "🛶", "🛥", "🚞", "🚟", "🚃", "🚝", "🚠", "🚋", "🚌", "🚍", "🚎", "🚐", "🚑", "🚒"]
    
    @State var emojiCount = 20
    var body: some View {
        VStack {
            header
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: getBestFitWidth(cardCount: emojiCount)))]) {
                    ForEach(selectedEmojis[0..<emojiCount].shuffled(), id: \.self) { emoji in
                        CardView(content: emoji)
                            .aspectRatio(2/3, contentMode: .fit)
                    }
                }
            }
            .foregroundColor(.red)
            Spacer()
            HStack {
                themeTravel
                Spacer()
                themeSport
                Spacer()
                themeFood
            }
            .font(.largeTitle)
            .padding(.horizontal)
        }
        .padding(.horizontal)
    }
    var header: some View {
        Text("Memorize!")
            .font(.title)
    }
    var themeSport: some View {
        Button {
            selectedEmojis = sportEmojis
            emojiCount = Int.random(in: 4...selectedEmojis.count)
        } label: {
            VStack {
                Image(systemName: "soccerball.circle")
                Text("Sports")
                    .font(.footnote)
            }
        }
    }
    
    
    var themeTravel: some View {
        Button {
            selectedEmojis = travelEmojis
            emojiCount = Int.random(in: 4...selectedEmojis.count)
        } label: {
            VStack{
                Image(systemName: "car.circle")
                Text("Travel")
                    .font(.footnote)
                
            }
        }
    }
    
    
    var themeFood: some View {
        Button {
            selectedEmojis = foodEmojis
            emojiCount = Int.random(in: 4...selectedEmojis.count)
        } label: {
            VStack {
                Image(systemName: "fork.knife.circle")
                Text("Foodies")
                    .font(.footnote)
            }
        }
    }
    
    
}

struct CardView: View {
    var content: String
    @State var isFaceUp: Bool = false
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(content).font(.largeTitle)
            } else {
                Text(content).font(.largeTitle).opacity(0)
                shape.fill()
            }
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
    }
}

func getBestFitWidth (cardCount: Int) -> CGFloat {
    switch cardCount {
    case 4:
        return 150
    case 5...12:
        return 110
    case 13...20:
        return 80
    default:
        return 65
    }
}

#Preview {
    ContentView()
}
