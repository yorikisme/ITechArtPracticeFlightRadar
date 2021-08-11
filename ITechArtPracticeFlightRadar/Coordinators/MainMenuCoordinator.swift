//
//  MainMenuCoordinator.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 8/11/21.
//

import UIKit

class MainMenuCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let mainMenuViewController = MainMenuViewController()
        let mainMenuViewModel = MainMenuViewModel()
        mainMenuViewModel.coordinator = self
        mainMenuViewController.viewModel = mainMenuViewModel
        navigationController.pushViewController(mainMenuViewController, animated: false)
    }
    func startSignInProcedure() {
        let signInCoordinator = SignInCoordinator(navigationController: navigationController)
        childCoordinators.append(signInCoordinator)
        signInCoordinator.start()
    }
}
