//
//  LauchScreenView.swift
//  TraduzAi
//
//  Created by Rodrigo Soares on 24/02/25.
//

import SwiftUI

struct LauchScreenView: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            Lottie(animationFileName: "TraduzAi", loopMode: .loop)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
