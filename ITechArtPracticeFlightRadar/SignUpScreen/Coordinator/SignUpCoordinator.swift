//
//  SignUpCoordinator.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/2/21.
//

import UIKit
import Firebase

protocol SignUpCoordinatorProtocol: Coordinator {
    func signUp()
    func goBack()
    func sendVerificationLetter(completion: @escaping (Error?) -> Void)
}

class SignUpCoordinator: SignUpCoordinatorProtocol {
    
    //var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    let service: NetworkManagerProtocol
    
    init(navigationController: UINavigationController, service: NetworkManagerProtocol) {
        self.navigationController = navigationController
        self.service = service
    }
    
    func start() {
        let signUpViewController = SignUpViewController()
        let signUpViewModel = SignUpViewModel(coordinator: self)
        signUpViewController.viewModel = signUpViewModel
        navigationController.pushViewController(signUpViewController, animated: true)
    }
    
    func signUp() {
        let radarDashboardCoordinator = ContainerCoordinator(navigationController: navigationController, service: service)
        radarDashboardCoordinator.start()
    }
    
    func goBack() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func sendVerificationLetter(completion: @escaping (Error?) -> Void) {
        Auth.auth().currentUser?.sendEmailVerification(completion: completion)
    }
}
