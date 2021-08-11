//
//  SignInCoordinator.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 8/11/21.
//

import UIKit

class SignInCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let signInViewController = SignInViewController()
        let signInViewModel = SignInViewModel()
        signInViewModel.coordinator = self
        signInViewController.viewModel = signInViewModel
        navigationController.pushViewController(signInViewController, animated: true)
    }
    func signIn() {
        let listOfFlightsViewCoordinator = ListOfFlightsCoordinator(navigationController: navigationController)
        childCoordinators.append(listOfFlightsViewCoordinator)
        listOfFlightsViewCoordinator.start()
    }
}
