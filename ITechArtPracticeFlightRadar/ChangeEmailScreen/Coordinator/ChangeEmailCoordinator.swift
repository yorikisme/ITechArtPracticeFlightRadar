//
//  ChangeEmailCoordinator.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/27/21.
//

import UIKit

protocol ChangeEmailCoordinatorProtocol: Coordinator {
    func goBackToPreviousScreen()
}

class ChangeEmailCoordinator: ChangeEmailCoordinatorProtocol {
    
    // MARK: - Properties
    let navigationController: UINavigationController
    
    // MARK: - Initializer
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    func start() {
        let viewController = ChangeEmailViewController()
        let viewModel = ChangeEmailViewModel(coordinator: self)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goBackToPreviousScreen() {
        navigationController.popViewController(animated: true)
    }
}
