//
//  ModulePage+ReadinText.swift
//  Kazakh Literacy Boost
//
//  Created by Yedige Ashirbek on 13.04.2024.
//

import Foundation
import SwiftUI

fileprivate struct Constants {
    struct Images {
        static let buttonBackground = UIImage(named: "buttonBackground")!
    }
}

struct ReadingTextPage: View {
    @StateObject var dataModel: ModulePageModel
    @Binding var shouldHideCheckButton: Bool
    @Binding var checkButtonPressed: Bool
    
    @State var textAtCells = [String]()
    @State var pressedReadingText: String = ""
    @State var readingText = [String]()
    @State var shuffledReadingText = [String]()
    
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView(.vertical) {
                    VStack {
                        ForEach(0..<readingText.count, id: \.self) { index in
                            textCell(
                                index: index,
                                pressedText: $pressedReadingText,
                                textAtCells: $textAtCells,
                                shouldHideCheckButton: $shouldHideCheckButton
                            )
                        }
                    }
                }
                ScrollView(.horizontal) {
                    HStack(spacing: 16) {
                        ForEach(shuffledReadingText, id: \.self) { word in
                            PressableCell(word: word, pressedReadingText: $pressedReadingText)
                        }
                    }
                }
                .frame(height: 96)
            }
            if checkButtonPressed {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.white)
                    ZStack {
                        VStack {
                            Spacer()
                                .frame(height: 8)
                            HStack {
                                Spacer()
                                    .frame(width: 8)
                                Button {
                                    checkButtonPressed = false
                                    start()
                                } label: {
                                    ZStack {
                                        Image(uiImage: Constants.Images.buttonBackground)
                                        Image(systemName: "goforward")
                                            .foregroundStyle(.black)
                                    }
                                }
                                
                                Spacer()
                                
                                Button {
                                    checkButtonPressed = false
                                } label: {
                                    ZStack {
                                        Image(uiImage: Constants.Images.buttonBackground)
                                        Image(systemName: "xmark")
                                            .foregroundStyle(.black)
                                    }
                                }
                                Spacer()
                                    .frame(width: 8)
                            }
                            Spacer()
                        
                            Button {
                                checkButtonPressed = false
                                putCorrectAnswer()
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(red: 0.46, green: 0.46, blue: 0.5))
                                        .opacity(0.12)
                                    VStack {
                                        Text("Жауабын көрсету")
                                            .font(.system(size: 16))
                                    }
                                }
                                .frame(width: 200, height: 32)
                            }

                            Spacer()
                                .frame(height: 16)
                        }
                        Text(checkAnswer() ? "✅" : "❌")
                    }
                }.frame(width: 250, height: 250)
            }
        }
        .padding(.horizontal)
        .onAppear {
            dataModel.networkingService.readingTextDelegate = self
            start()
        }
    }
    
    private func start() {
        shouldHideCheckButton = true
        readingText = [String]()
        shuffledReadingText = [String]()
        textAtCells = [String]()
        dataModel.requestRunCount = 0
        pressedReadingText = ""
        performReadingTextRequest()
    }
    
    private func putCorrectAnswer() {
        for i in 0..<textAtCells.count {
            textAtCells[i] = readingText[i]
        }
    }
    
    private func performReadingTextRequest() {
        dataModel.requestRunCount += 1
        if (dataModel.requestRunCount >= 5 && readingText.isEmpty) {
            print("yedige, please turn on the internet")
        } else {
            dataModel.networkingService.getReadingText()
        }
    }
    
    private func checkAnswer() -> Bool {
        for i in 0..<readingText.count {
            if readingText[i] != textAtCells[i] {
                return false
            }
        }
        return true
    }
}

fileprivate struct textCell: View {
    var index: Int
    
    @Binding var pressedText: String
    @Binding var textAtCells: [String]
    @Binding var shouldHideCheckButton: Bool
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 0.984, green: 0.752, blue: 0.357))
                Text("\(index + 1)")
                    .foregroundStyle(.white)
            }.frame(width: 48, height: 48)
            Button {
                textAtCells[index] = pressedText
                if !textAtCells.contains("") {
                    shouldHideCheckButton = false
                    print(textAtCells)
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(red: 0.984, green: 0.752, blue: 0.357))
                    Text((index < textAtCells.count) ? textAtCells[index] : "")
                        .foregroundStyle(Color(red: 0.1, green: 0.42, blue: 0.58))
                        .bold()
                }
            }
            .frame(height: 48)
        }
        .frame(height: 64)
    }
}

fileprivate struct PressableCell: View {
    var word: String
    
    @Binding var pressedReadingText: String
    
    var body: some View {
        ZStack {
            Button {
                pressedReadingText = word
            } label: {
                ZStack {
                    if pressedReadingText == word {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(red: 0.682, green: 0.612, blue: 0.908))
                    }
                    HStack {
                        Spacer()
                            .frame(width: 8)
                        Text(word)
                            .foregroundStyle((pressedReadingText == word) ? .white : Color(red: 0.1, green: 0.42, blue: 0.58))
                        Spacer()
                            .frame(width: 8)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(red: 0.682, green: 0.612, blue: 0.908), lineWidth: 2)
                            .frame(height: 48)
                    )
                }
                .frame(height: 48)
            }
        }
        .frame(height: 64)
    }
}

extension ReadingTextPage: ReadingTextRequestDelegate {
    func didReceive(readingText: [String]) {
        DispatchQueue.main.async {
            print(readingText)
            textAtCells = Array(repeating: "", count: readingText.count)
            self.readingText = readingText
            shuffledReadingText = readingText.shuffled()
        }
    }
    
    func failWithError(error: any Error) {
        print("ты далбан едіге, ошибка в ReadingTextPage:, \(error)")
        performReadingTextRequest()
    }
}
