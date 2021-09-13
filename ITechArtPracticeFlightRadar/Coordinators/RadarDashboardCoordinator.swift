//
//  RadarDashboardCoordinator.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/7/21.
//

import UIKit

protocol RadarDashboardCoordinatorProtocol: Coordinator {
    func signOut()
    func goToSettings()
    var service: ServiceProtocol { get }
}

class RadarDashboardCoordinator: RadarDashboardCoordinatorProtocol {
    
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    let service: ServiceProtocol
    
    init(navigationController: UINavigationController, service: ServiceProtocol) {
        self.navigationController = navigationController
        self.service = service
    }
    
    func start() {
        let radarDashboardViewController = RadarDashboardViewController()
        let radarDashboardViewModel = RadarDashboardViewModel(coordinator: self)
        radarDashboardViewController.viewModel = radarDashboardViewModel
        navigationController.pushViewController(radarDashboardViewController, animated: true)
    }
    
    func signOut() {
        navigationController.popViewController(animated: true)
    }
    
    func goToSettings() {
        let settingsCoordinator = SettingsCoordinator(navigationController: navigationController)
        settingsCoordinator.start()
    }
    
}
