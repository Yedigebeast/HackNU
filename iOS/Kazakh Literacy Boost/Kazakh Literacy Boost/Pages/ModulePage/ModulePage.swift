//
//  WordsPage.swift
//  Kazakh Literacy Boost
//
//  Created by Yedige Ashirbek on 13.04.2024.
//

import SwiftUI

fileprivate struct Constants {
    struct Images {
        static let backButton = UIImage(named: "backButton")!
    }
}

struct ModulePage: View {
    
    @StateObject var dataModel: ModulePageModel
    @State var shouldHideCheckButton = true
    @State var checkButtonPressed = false
    
    var body: some View {
        ZStack {
            Color(red: 0.965, green: 0.957, blue: 0.922)
                .ignoresSafeArea()
            VStack {
                Spacer()
                    .frame(height: 16)
                ZStack {
                    HStack {
                        Spacer()
                            .frame(width: 16)
                        Button {
                            dataModel.router.dismiss()
                        } label: {
                            Image(uiImage: Constants.Images.backButton)
                        }
                        Spacer()
                        
                        if !shouldHideCheckButton {
                            Button {
                                checkButtonPressed = true
                            } label: {
                                Text("Тексеру")
                                    .foregroundStyle(Color(red: 0.1, green: 0.42, blue: 0.58))
                                    .bold()
                            }
                        }
                        Spacer()
                            .frame(width: 16)
                    }
                    HStack {
                        Spacer()
                        Text(dataModel.module.text)
                            .fontWeight(.bold)
                            .foregroundStyle(Color(red: 0.1, green: 0.42, blue: 0.58))
                        Spacer()
                    }
                }
                mainView
            }
        }
    }
    
    private var mainView: some View {
        ZStack {
            switch dataModel.module {
            case .words:
                Text(dataModel.module.text)
            case .reading:
                ReadingTextPage(
                    dataModel: dataModel,
                    shouldHideCheckButton: $shouldHideCheckButton,
                    checkButtonPressed: $checkButtonPressed)
            case .listening:
                ListeningAudioPage(dataModel: dataModel,
                                   shouldHideCheckButton: $shouldHideCheckButton,
                                   checkButtonPressed: $checkButtonPressed)
            case .speaking:
                Text(dataModel.module.text)
            }
        }
    }
}
