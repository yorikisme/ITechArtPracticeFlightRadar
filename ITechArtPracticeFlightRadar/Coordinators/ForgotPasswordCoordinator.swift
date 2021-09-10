//
//  ForgotPasswordCoordinator.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/1/21.
//

import UIKit
import Firebase
import GoogleSignIn

protocol ForgotPasswordCoordinatorProtocol: Coordinator {
    
}

class ForgotPasswordCoordinator: ForgotPasswordCoordinatorProtocol {
    
    var childCoordinators: [Coordinator] = []
    
    let navigationController: UINavigationController
    init(navigationController: UINavigationController, service: ServiceProtocol) {
        self.navigationController = navigationController
    }
    
    func start() {
        let forgotPasswordViewController = ForgotPasswordViewController()
        let forgotPasswordViewModel = ForgotPasswordViewModel(coordinator: self)
        forgotPasswordViewController.viewModel = forgotPasswordViewModel
        navigationController.pushViewController(forgotPasswordViewController, animated: true)
    }
    
}
