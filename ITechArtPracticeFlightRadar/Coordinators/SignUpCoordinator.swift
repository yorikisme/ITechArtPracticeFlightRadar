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
    func sendVerificationLetter(completion: @escaping (Error?) -> Void)
}

class SignUpCoordinator: SignUpCoordinatorProtocol {
    
    var childCoordinators: [Coordinator] = []
    
    let navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let signUpViewController = SignUpViewController()
        let signUpViewModel = SignUpViewModel(coordinator: self)
        signUpViewController.viewModel = signUpViewModel
        navigationController.pushViewController(signUpViewController, animated: true)
    }
    
    func signUp() {
        let radarDashboardCoordinator = RadarDashboardCoordinator(navigationController: navigationController)
        radarDashboardCoordinator.start()
    }
    
    func sendVerificationLetter(completion: @escaping (Error?) -> Void) {
        Auth.auth().currentUser?.sendEmailVerification(completion: completion)
    }
}
