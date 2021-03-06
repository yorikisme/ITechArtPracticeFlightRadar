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
    func finishForgotPasswordProcedure()
    func goBack()
}

class ForgotPasswordCoordinator: ForgotPasswordCoordinatorProtocol {
    
    //var childCoordinators: [Coordinator] = []
    
    let navigationController: UINavigationController
    init(navigationController: UINavigationController, service: NetworkManagerProtocol) {
        self.navigationController = navigationController
    }
    
    func start() {
        let forgotPasswordViewController = ForgotPasswordViewController()
        let forgotPasswordViewModel = ForgotPasswordViewModel(coordinator: self)
        forgotPasswordViewController.viewModel = forgotPasswordViewModel
        navigationController.pushViewController(forgotPasswordViewController, animated: true)
    }
    
    func goBack() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func finishForgotPasswordProcedure() {
        navigationController.popToRootViewController(animated: true)
    }
    
}
