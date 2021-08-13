//
//  AuthenticationCoordinator.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 8/11/21.
//

import UIKit

class AuthenticationCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let authenticationViewController = AuthenticationViewController()
        let authenticationViewModel = AuthenticationViewModel()
        authenticationViewModel.coordinator = self
        authenticationViewController.viewModel = authenticationViewModel
        navigationController.pushViewController(authenticationViewController, animated: true)
    }
    func signIn() {
        let listOfFlightsViewCoordinator = ListOfFlightsCoordinator(navigationController: navigationController)
        childCoordinators.append(listOfFlightsViewCoordinator)
        listOfFlightsViewCoordinator.start()
    }
}
