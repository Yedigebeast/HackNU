//
//  Modules.swift
//  Kazakh Literacy Boost
//
//  Created by Yedige Ashirbek on 13.04.2024.
//

import Foundation
import SwiftUI

enum Modules: CaseIterable {
    case words // quizlet, bonus function
    case reading // putting the words into the spaces, first task
    case listening // listen to the speaker and write what he said, second task
    case speaking // zoom call, third task
    
    var text: String {
        switch self {
        case .words:
            "Сөздік"
        case .reading:
            "Оқу"
        case .listening:
            "Тыңдау"
        case .speaking:
            "Сөйлеу"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .words:
            Color(red: 0.984, green: 0.752, blue: 0.357)
        case .reading:
            Color(red: 0.498, green: 0.745, blue: 0.961)
        case .listening:
            Color(red: 0.1, green: 0.42, blue: 0.58)
        case .speaking:
            Color(red: 0.682, green: 0.612, blue: 0.908)
        }
    }
}
