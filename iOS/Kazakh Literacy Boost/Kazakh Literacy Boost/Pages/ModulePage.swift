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
    
    let module: Modules
    let router: Router
    
    var body: some View {
        ZStack {
            Color(red: 0.965, green: 0.957, blue: 0.922)
                .ignoresSafeArea()
            VStack {
                Spacer()
                    .frame(height: 16)
                HStack {
                    Spacer()
                        .frame(width: 16)
                    Button {
                        router.dismiss()
                    } label: {
                        Image(uiImage: Constants.Images.backButton)
                    }
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

#Preview {
    ModulePage(
        module: .words,
        router: Router(navigationController: UINavigationController())
    )
}
