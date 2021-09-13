//
//  SettingsCoordinator.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/10/21.
//

import UIKit

protocol SettingsCoordinatorProtocol: Coordinator {
}

class SettingsCoordinator: SettingsCoordinatorProtocol {
    
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let settingsViewController = SettingsViewController()
        let settingsViewModel = SettingsViewModel(coordinator: self)
        settingsViewController.viewModel = settingsViewModel
        navigationController.pushViewController(settingsViewController, animated: true)
    }
    
}
