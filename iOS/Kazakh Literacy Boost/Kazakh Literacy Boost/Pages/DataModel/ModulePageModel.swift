//
//  ModulePageModel.swift
//  Kazakh Literacy Boost
//
//  Created by Yedige Ashirbek on 13.04.2024.
//

import Foundation
import AVFoundation

class ModulePageModel: ObservableObject {
    let module: Modules
    let router: Router
    let networkingService: NetworkingService
    
    var requestRunCount = 0
    
    var audioPlayer: AVAudioPlayer?
    
    init(module: Modules, router: Router, networkingService: NetworkingService) {
        self.module = module
        self.router = router
        self.networkingService = networkingService
    }
}
