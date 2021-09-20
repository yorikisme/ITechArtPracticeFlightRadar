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
    func signUp()
    func forgotPassword()
    func signInWithGoogle(handler: @escaping (GIDGoogleUser?, Error?) -> Void)
}

class AuthenticationCoordinator: AuthenticationCoordinatorProtocol {
    //var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    let service: NetworkManagerProtocol
    
    init(navigationController: UINavigationController, service: NetworkManagerProtocol) {
        self.navigationController = navigationController
        self.service = service
    }
    
    func start() {
        let authenticationViewController = AuthenticationViewController()
        let authenticationViewModel = AuthenticationViewModel(coordinator: self)
        authenticationViewController.viewModel = authenticationViewModel
        navigationController.pushViewController(authenticationViewController, animated: true)
    }
    
    func signIn() {
        let radarDashboardCoordinator = ContainerCoordinator(navigationController: navigationController, service: service)
        radarDashboardCoordinator.start()
    }
    
    func signUp() {
        let signUpCoordinator = SignUpCoordinator(navigationController: navigationController, service: service)
        signUpCoordinator.start()
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
    
    func forgotPassword() {
        let forgotPasswordCoordinator = ForgotPasswordCoordinator(navigationController: navigationController, service: service)
        forgotPasswordCoordinator.start()
    }
}
