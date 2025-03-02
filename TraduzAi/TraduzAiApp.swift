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
                TabBarView()
                
                if showSplash {
                    LauchScreenView()
                        .transition(.opacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
