//
//  Stripe.swift
//  sol_4
//
//  Created by Wei Zheng on 2023/8/12.
//

import SwiftUI

struct PatternBuilder<SymbolShape: Shape>: View {
    let shape: SymbolShape
    let color: Color
    let pattern: SymbolSetGame.SymbolPattern
    let width: Int
    let interval: Int
    @ObservedObject var globalState2 = globalState

    var body: some View {
        switch pattern {
        case .outlined:
            shape
                .stroke(globalState2.isColorBlind ? .black : color, lineWidth: CGFloat(width))
                .padding(CGFloat(width))
        case .solid:
            shape
                .fill(globalState2.isColorBlind ? .black : color)
        case .striped:
            StripedPattern(color: globalState2.isColorBlind ? .black : color, width: width, interval: interval)
                .fill(globalState2.isColorBlind ? .black : color)
                .mask(shape)
                .overlay(shape.stroke(globalState2.isColorBlind ? .black : color, lineWidth: CGFloat(width)))
                .padding(CGFloat(width))
        }
    }
}

struct StripedPattern: Shape{
    let color: Color
    let width: Int
    let interval: Int
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: rect.origin)
        for index in 0...Int(rect.width)/(width) {
            if index % interval == 0 {
                path.addRect(CGRect(
                    x: CGFloat(index * width),
                    y: 0,
                    width: CGFloat(width),
                    height: rect.height)
                )
            }
        }
        return path
    }
}
