//
//  AuthenticationCoordinator.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 8/11/21.
//

import UIKit
import Firebase
import GoogleSignIn

protocol AuthenticationCoordinatorProtocol: Coordinator {
    func signIn()
    func signInWithGoogle(handler: @escaping (GIDGoogleUser?, Error?) -> Void)
}

class AuthenticationCoordinator: AuthenticationCoordinatorProtocol {
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
    
    func signInWithGoogle(handler: @escaping (GIDGoogleUser?, Error?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            handler(nil, GIDSignInError.init(.noCurrentUser))
            return
        }
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: navigationController, callback: handler)
    }
}
