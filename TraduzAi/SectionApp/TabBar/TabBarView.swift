//
//  Tab.swift
//  TraduzAi
//
//  Created by Rodrigo Soares on 28/02/25.
//

import SwiftUI

struct TabBarView: View {
    @State var selection: Int = 1
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        // Mantém a borda padrão da Tab Bar
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        
        // Adiciona um shadow para fora, conferindo profundidade
        UITabBar.appearance().layer.shadowColor = UIColor.black.cgColor
        UITabBar.appearance().layer.shadowOpacity = 0.3
        UITabBar.appearance().layer.shadowOffset = CGSize(width: 0, height: 3)
        UITabBar.appearance().layer.shadowRadius = 3
        UITabBar.appearance().clipsToBounds = false
    }
    
    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    Image(selection == 1 ? "HOME_OUTLINE" : "HOME")
                    Text("Inicio")
                }
                .tag(1)
            
            TranslatorText()
                .tabItem {
                    Image(selection == 2 ? "TRANSLATOR_OUTLINE" : "TRANSLATOR")
                    Text("Texto")
                }
                .tag(2)
            
            TranslatorAudio()
                .tabItem {
                    Image(selection == 3 ? "MICROPHONE_OUTLINE" : "MICROPHONE")
                    Text("Audio")
                }
                .tag(3)
            
            History()
                .tabItem {
                    Image(selection == 4 ? "HISTORY_OUTLINE" : "HISTORY")
                    Text("Histórico")
                }
                .tag(4)
        }
    }
}
