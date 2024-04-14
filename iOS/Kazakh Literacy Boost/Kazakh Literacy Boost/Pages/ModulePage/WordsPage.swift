//
//  WordsPage.swift
//  Kazakh Literacy Boost
//
//  Created by Yedige Ashirbek on 14.04.2024.
//

import SwiftUI

class NVFlipCardPresenter: ObservableObject {
    @Published var isFlipped: Bool = false

    func flipButtonTapped() {
        isFlipped.toggle()
    }
}

struct WordsPage: View {
    @StateObject var dataModel: ModulePageModel
    
    @State var wordsData: WordsData?
    @StateObject var presenter = NVFlipCardPresenter()
    
    var body: some View {
        let flipDegrees = presenter.isFlipped ? 180.0 : 0
        return ZStack {
            if let wordsData {
                VStack {
                    Spacer()
                    ZStack() {
                        Text(wordsData.word)
                            .font(.system(size: 25))
                            .bold()
                            .foregroundStyle(Color(red: 0.1, green: 0.42, blue: 0.58))
                            .placedOnCard(Color(red: 0.55, green: 0.925, blue: 0.7))
                            .flipRotate(flipDegrees)
                            .opacity(presenter.isFlipped ? 0.0 : 1.0)
                        
                        VStack {
                            Text(wordsData.rus)
                            Spacer()
                                .frame(height: 16)
                            Text(wordsData.eng)
                            Spacer()
                                .frame(height: 32)
                            Text(wordsData.description)
                        }
                        .font(.system(size: 20))
                        .foregroundStyle(Color(red: 0.1, green: 0.42, blue: 0.58))
                        .placedOnCard(Color(red: 0.59, green: 0.9, blue: 0.88))
                        .flipRotate(-180 + flipDegrees)
                        .opacity(presenter.isFlipped ? 1.0 : 0.0)
                    }
                    .animation(.easeInOut(duration: 1.0), value: presenter.isFlipped)
                    .onTapGesture { presenter.isFlipped.toggle() }
                    Spacer()
                }
            } else {
                Spacer()
            }
        }
        .onAppear {
            dataModel.networkingService.wordsDelegate = self
            start()
        }
    }
    
    private func start() {
        dataModel.requestRunCount = 0
        performWordsRequest()
    }
    
    private func performWordsRequest() {
        dataModel.requestRunCount += 1
        if (dataModel.requestRunCount >= 5 && wordsData == nil) {
            print("yedige, please turn on the internet")
        } else {
            dataModel.networkingService.getWords()
        }
    }
}

extension WordsPage: WordsRequestDelegate {
    func didReceive(wordsData: WordsData) {
        DispatchQueue.main.async {
            print("words data is: \(wordsData)")
            self.wordsData = wordsData
        }
    }
    
    func failWithError(error: any Error) {
        print("ты далбан едіге, ошибка в WordsPage: \(error)")
        performWordsRequest()
    }
}

extension View {
    func flipRotate(_ degrees : Double) -> some View {
        return rotation3DEffect(Angle(degrees: degrees), axis: (x: 0.0, y: 1.0, z: 0.0))
    }
    
    func placedOnCard(_ color: Color) -> some View {
        return padding(8).frame(width: 300, height: 500, alignment: .center).background(color).cornerRadius(8)
    }
}
