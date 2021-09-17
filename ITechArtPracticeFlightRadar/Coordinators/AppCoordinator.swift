//
//  AppCoordinator.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 8/11/21.
//

import UIKit

protocol Coordinator {
    //var childCoordinators: [Coordinator] { get }
    func start()
}

class AppCoordinator: Coordinator {
    //var childCoordinators: [Coordinator] = []
    let window: UIWindow
    let service: NetworkManagerProtocol = NetworkManager()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let navigationController = UINavigationController()
//        let authenticationCoordinator = AuthenticationCoordinator(navigationController: navigationController, service: service)
//        childCoordinators.append(authenticationCoordinator)
//        authenticationCoordinator.start()
        
        // Temporary plug
//        let radarDashboardCoordinator = RadarDashboardCoordinator(navigationController: navigationController, service: service)
//        radarDashboardCoordinator.start()
        
        // Temporary plug 2
        let containerCoordinator = ContainerCoordinator(navigationController: navigationController, service: service)
        containerCoordinator.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
