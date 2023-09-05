//
//  CardBack.swift
//  sol_4
//
//  Created by Wei Zheng on 2023/8/28.
//

import SwiftUI

struct CardBack: View {
    var body: some View {
        Image("cardBG")
            .resizable()
            .aspectRatio(2/3, contentMode: .fill)
    }
}
