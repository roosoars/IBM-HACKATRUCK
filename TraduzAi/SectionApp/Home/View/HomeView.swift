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
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}
#endif

// Componente customizado que encapsula UITextView e permite descartar o teclado ao pressionar o Return.
// Agora com suporte a placeholder, fonte e cor do texto.
struct CustomTextEditor: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String = ""
    var textColor: UIColor = .label
    var font: UIFont = UIFont.preferredFont(forTextStyle: .body)
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.returnKeyType = .done
        textView.backgroundColor = .clear
        textView.textColor = textColor
        textView.font = font
        
        // Cria e configura o label de placeholder
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholder
        placeholderLabel.font = font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.numberOfLines = 0
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.tag = 100  // Tag para identificação
        
        textView.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 5),
            placeholderLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -5)
        ])
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.textColor = textColor
        uiView.font = font
        
        // Atualiza a visibilidade do placeholder
        if let placeholderLabel = uiView.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = !uiView.text.isEmpty
        }
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
            if let placeholderLabel = textView.viewWithTag(100) as? UILabel {
                placeholderLabel.isHidden = !textView.text.isEmpty
            }
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
    @State private var sourceLanguage: String = "Português"
    @State private var targetLanguage: String = "Inglês"
    @State private var sourceText: String = ""
    @State private var translatedText: String = ""
    
    let languages = ["Inglês", "Espanhol", "Português"]
    
    init() {
        // Configura os atributos do UISegmentedControl para definir a fonte e a cor do texto
        if let customFont = UIFont(name: "YourCustomFont", size: 16) {
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black,
                                                                    .font: customFont], for: .normal)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black,
                                                                    .font: customFont], for: .selected)
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
                
                HStack(spacing: 0){
                    Lottie(animationFileName: "TraduzAi", loopMode: .loop)
                        .frame(maxWidth: 100, maxHeight: 100)
                        .clipped()
                        .padding(.horizontal, -25)
                        .padding(.vertical, -25)

                    
                    Text("TraduzAi")
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding(.trailing, 15)
                .frame(alignment: .center)
                
                Text("Traduzir textos e áudio nunca foi tão fácil.")
                    .foregroundStyle(Color("GRAY_COLOR"))
                
                VStack(spacing: 0) {
                    HStack {
                        // Substitui o Picker por um Menu com seta para baixo
                        Menu {
                            // Lista de idiomas de origem
                            ForEach(languages, id: \.self) { language in
                                Button(language) {
                                    sourceLanguage = language
                                }
                            }
                        } label: {
                            HStack {
                                Text(sourceLanguage)
                                Image(systemName: "chevron.down")
                            }
                            .foregroundColor(.black)
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                        
                        // Botão para limpar o conteúdo do campo de texto de origem
                        Button(action: {
                            sourceText = ""
                        }) {
                            Image("X")
                                .padding()
                        }
                    }
                    
                    // Campo de texto de origem utilizando o CustomTextEditor com placeholder
                    CustomTextEditor(
                        text: $sourceText,
                        placeholder: "Digite o texto original",
                        textColor: UIColor(named: "GRAY_COLOR") ?? .gray,
                        font: UIFont.systemFont(ofSize: 14)
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color("BAR"))
                        .padding()
                    
                    HStack {
                        // Substitui o Picker de destino por outro Menu
                        Menu {
                            ForEach(languages, id: \.self) { language in
                                Button(language) {
                                    targetLanguage = language
                                }
                            }
                        } label: {
                            HStack {
                                Text(targetLanguage)
                                Image(systemName: "chevron.down")
                            }
                            .foregroundColor(.black)
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                        
                        // Botão para copiar o conteúdo do campo traduzido para a área de transferência
                        Button(action: {
                            UIPasteboard.general.string = translatedText
                        }) {
                            Image("COPY")
                                .padding()
                        }
                    }
                    
                    // Campo de texto traduzido utilizando o CustomTextEditor com placeholder
                    CustomTextEditor(
                        text: $translatedText,
                        placeholder: "A tradução aparecerá aqui",
                        textColor: UIColor(named: "GRAY_COLOR") ?? .gray,
                        font: UIFont.systemFont(ofSize: 14)
                    )
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
