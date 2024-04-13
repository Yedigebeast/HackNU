//
//  Router.swift
//  Kazakh Literacy Boost
//
//  Created by Yedige Ashirbek on 13.04.2024.
//

import Foundation
import UIKit
import SwiftUI

class Router {
    private let navigationController: UINavigationController
    private let networkingService = NetworkingService()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    func pushMainPage() {
        let vc = UIHostingController(rootView: MainPage(router: self))
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pushModulePage(module: Modules) {
        let vc = UIHostingController(
            rootView: ModulePage(
                dataModel: ModulePageModel(
                    module: module,
                    router: self,
                    networkingService: self.networkingService
                )
            )
        )
        navigationController.pushViewController(vc, animated: true)
    }
    
    func dismiss() {
        navigationController.popViewController(animated: true)
    }
}
