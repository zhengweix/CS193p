//
//  Diamond.swift
//  sol_3
//
//  Created by Wei Zheng on 2023/8/12.
//

import SwiftUI

import SwiftUI

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let height = rect.width/4
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY - height))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY + height))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        
//        let transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
//        path = path.applying(transform)
//        let pathRect = path.boundingRect
//        let moveX: CGFloat = -pathRect.width/12
//        let moveY: CGFloat = -pathRect.width/6
//        let transform2 = CGAffineTransform(translationX:moveX, y: moveY)
//        path = path.applying(transform2)
        return path
    }
}
