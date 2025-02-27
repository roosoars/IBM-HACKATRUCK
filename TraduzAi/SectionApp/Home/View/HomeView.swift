//
//  HomeView.swift
//  TraduzAi
//
//  Created by Rodrigo Soares on 24/02/25.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

// Componente customizado que encapsula UITextView e permite descartar o teclado ao pressionar o Return
struct CustomTextEditor: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.returnKeyType = .done
        textView.backgroundColor = .clear
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
        
        init(text: Binding<String>) {
            self.text = text
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.text.wrappedValue = textView.text
        }
        
        // Detecta o retorno e encerra o teclado
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText newText: String) -> Bool {
            if newText == "\n" {
                textView.resignFirstResponder()
                return false
            }
            return true
        }
    }
}

struct HomeView: View {
    @State private var sourceLanguage: String = "English"
    @State private var targetLanguage: String = "Spanish"
    @State private var sourceText: String = ""
    @State private var translatedText: String = ""
    
    let languages = ["English", "Spanish", "Portuguese"]
    
    init() {
        // Configura os atributos do UISegmentedControl para definir a fonte e a cor do texto
        if let customFont = UIFont(name: "YourCustomFont", size: 16) {
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black, .font: customFont], for: .normal)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black, .font: customFont], for: .selected)
        }
    }
    
    var body: some View {
        ZStack {
            Color("BG")
                .ignoresSafeArea()
                // Encerra o teclado ao tocar fora da área de edição
                .onTapGesture {
                    self.hideKeyboard()
                }
            
            VStack(spacing: 20) {
                
                Text("TraduzAi")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Vamos descobrir novas linguagens ?")
                    .foregroundStyle(Color("GRAY_COLOR"))
                
                VStack(spacing: 0) {
                    HStack {
                        // Picker de idioma de origem com estilo segmentado
                        Picker("Idioma de origem", selection: $sourceLanguage) {
                            ForEach(languages, id: \.self) { language in
                                Text(language)
                            }
                        }
                        .accentColor(.black)
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        // Botão para limpar o conteúdo do campo de texto de origem
                        Button(action: {
                            sourceText = ""
                        }) {
                            Image("X")
                                .padding()
                        }
                    }
                    
                    // Campo de texto de origem utilizando o CustomTextEditor com altura definida
                    CustomTextEditor(text: $sourceText)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.horizontal)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color("BAR"))
                        .padding()
                    
                    HStack {
                        // Picker de idioma de destino com estilo segmentado
                        Picker("Idioma de destino", selection: $targetLanguage) {
                            ForEach(languages, id: \.self) { language in
                                Text(language)
                            }
                        }
                        .accentColor(.black)
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        // Botão para copiar o conteúdo do campo traduzido para a área de transferência
                        Button(action: {
                            UIPasteboard.general.string = translatedText
                        }) {
                            Image("COPY")
                                .padding()
                        }
                    }
                    
                    // Campo de texto traduzido utilizando o CustomTextEditor com altura definida
                    CustomTextEditor(text: $translatedText)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 10)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color("Stroke"), lineWidth: 1)
                )
            }
            .padding()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
