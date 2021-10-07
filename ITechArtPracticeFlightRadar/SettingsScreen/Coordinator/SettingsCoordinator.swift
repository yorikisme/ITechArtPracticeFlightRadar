//
//  SettingsCoordinator.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/27/21.
//

import UIKit

protocol SettingsCoordinatorProtocol: Coordinator {
    func goToChangePasswordScreen()
    func goBackToPreviousScreen()
}

class SettingsCoordinator: SettingsCoordinatorProtocol {
    
    // MARK: - Properties
    let navigationController: UINavigationController
    
    // MARK:  - Initializers
    init(navigationController: UINavigationController, service: NetworkManagerProtocol) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    func start() {
        let viewController = SettingsViewController()
        
        /// Birthday
        let birthdayView = BirthdayView.createView()
        let birthdayViewModel = BirthdayViewViewModel()
        
        birthdayView.viewModel = birthdayViewModel
        viewController.birthdayView = birthdayView
        
        let settingsViewModel = SettingsViewModel(coordinator: self)
        viewController.viewModel = settingsViewModel
        
        birthdayViewModel
            .newBirthdayDate
            .subscribe(
                onNext: {
                    settingsViewModel.newBirthdayDate.accept($0)
                    settingsViewModel.isChangeBirthdayInProgress.accept(false) })
            .disposed(by: settingsViewModel.disposeBag)
        
        /// Password
        let changePasswordView = ChangePasswordView.createView()
        let changePasswordViewModel = ChangePasswordViewModel()
        
        changePasswordView.viewModel = changePasswordViewModel
        viewController.changePasswordView = changePasswordView
        
        changePasswordViewModel.saveAction.subscribe(onNext: { _ in
            settingsViewModel.isChangePasswordInProgress.accept(false)
        })
        .disposed(by: changePasswordViewModel.disposeBag)
        
        changePasswordViewModel
            .isLoading
            .bind(to: settingsViewModel.isLoading)
            .disposed(by: changePasswordViewModel.disposeBag)
        
        changePasswordViewModel
            .infoMessage
            .bind(to: settingsViewModel.infoMessage)
            .disposed(by: changePasswordViewModel.disposeBag)
        
        changePasswordView
            .cancelButton.rx
            .tap.subscribe(onNext: { settingsViewModel.isChangePasswordInProgress.accept(false) })
            .disposed(by: settingsViewModel.disposeBag)
        
        /// Push viewController
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToChangePasswordScreen() {
        let coordinator = ChangeEmailCoordinator(navigationController: navigationController)
        coordinator.start()
    }
    
    func goBackToPreviousScreen() {
        navigationController.popViewController(animated: true)
    }
    
}
