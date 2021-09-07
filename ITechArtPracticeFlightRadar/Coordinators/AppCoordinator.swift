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
        //let authenticationCoordinator = AuthenticationCoordinator(navigationController: navigationController)
        //childCoordinators.append(authenticationCoordinator)
        //authenticationCoordinator.start()
        
        let radarDashboardCoordinator = RadarDashboardCoordinator(navigationController: navigationController)
        radarDashboardCoordinator.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
