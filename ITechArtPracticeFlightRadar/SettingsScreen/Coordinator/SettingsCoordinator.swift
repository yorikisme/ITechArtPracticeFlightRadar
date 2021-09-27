//
//  SettingsCoordinator.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/27/21.
//

import UIKit

protocol SettingsCoordinatorProtocol: Coordinator {
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
    
}
