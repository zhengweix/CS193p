//
//  Oval.swift
//  sol_4
//
//  Created by Wei Zheng on 2023/8/12.
//

import SwiftUI

struct Oval: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = width / 2
        let radius = height
        let yOffset = (rect.height - height) / 2 
        let roundedRect = CGRect(x: rect.minX, y: rect.minY + yOffset, width: width, height: height)
        
        return RoundedRectangle(cornerRadius: radius).path(in: roundedRect)
    }
}
