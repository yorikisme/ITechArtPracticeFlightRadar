//
//  AppCoordinator.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 8/11/21.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get }
    func start()
}

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let window: UIWindow
    init(window: UIWindow) {
        self.window = window
    }
    func start() {
        let navigationController = UINavigationController()
        let signInCoordinator = SignInCoordinator(navigationController: navigationController)
        childCoordinators.append(signInCoordinator)
        signInCoordinator.start()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
