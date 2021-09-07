//
//  RadarDashboardCoordinator.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/7/21.
//

import UIKit

protocol RadarDashboardCoordinatorProtocol: Coordinator {
    func signOut()
}

class RadarDashboardCoordinator: RadarDashboardCoordinatorProtocol {
    
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
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
    
}
