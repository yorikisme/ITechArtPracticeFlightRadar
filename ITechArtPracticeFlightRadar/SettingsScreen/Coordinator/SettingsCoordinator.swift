//
//  SettingsCoordinator.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/27/21.
//

import UIKit

protocol SettingsCoordinatorProtocol: Coordinator {
    func goToChangePasswordScreen()
    func goBackToPreviousScreen()
}

class SettingsCoordinator: SettingsCoordinatorProtocol {
    
    // MARK: - Properties
    let navigationController: UINavigationController
    
    // MARK:  - Initializers
    init(navigationController: UINavigationController, service: NetworkManagerProtocol) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    func start() {
        let viewController = SettingsViewController()
        let viewModel = SettingsViewModel(coordinator: self)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToChangePasswordScreen() {
        let coordinator = ChangeEmailCoordinator(navigationController: navigationController)
        coordinator.start()
    }
    
    func goBackToPreviousScreen() {
        navigationController.popViewController(animated: true)
    }
    
}
