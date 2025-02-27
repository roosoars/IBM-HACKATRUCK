//
//  TraduzAiApp.swift
//  TraduzAi
//
//  Created by Rodrigo Soares on 24/02/25.
//

import SwiftUI

@main
struct MyApp: App {
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                HomeView()
                
                if showSplash {
                    LauchView()
                        .transition(.opacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showSplash = false
                                }
                            }
                        }
                }
            }
        }
    }
}

//ADICIONADO LOTTIE FILES
//ADICIONADO LAUCHVIEW
