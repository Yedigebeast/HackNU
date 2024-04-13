//
//  ContentView.swift
//  Kazakh Literacy Boost
//
//  Created by Yedige Ashirbek on 13.04.2024.
//

import SwiftUI

struct MainPage: View {
    let router: Router
    
    private let adaptiveRows = [
        GridItem(.fixed(150), spacing: 30),
        GridItem(.fixed(150), spacing: 30)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.965, green: 0.957, blue: 0.922)
                VStack {
                    Text("Қазақша үйренейік")
                        .fontWeight(.bold)
                        .foregroundStyle(Color(red: 0.1, green: 0.42, blue: 0.58))
                    Spacer()
                        .frame(height: 50)
                    LazyHGrid(rows: adaptiveRows, spacing: 30) {
                        ForEach(Modules.allCases, id: \.self) { module in
                            Button {
                                router.pushModulePage(module: module)
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 75)
                                        .fill(module.backgroundColor)
                                    Text(module.text)
                                        .font(.title)
                                        .foregroundStyle(.white)
                                }
                            }
                            .frame(width: 150, height: 150)
                        }
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    MainPage(router: Router(navigationController: UINavigationController()))
}
