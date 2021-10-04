//
//  SettingsViewModel.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/27/21.
//

import Foundation
import RxSwift
import RxCocoa

protocol SettingsViewModelProtocol {
    var userName: BehaviorRelay<String> { get }
    var changeUserNameAction: PublishRelay<Void> { get }
    var isChangeUserNameInProgress: BehaviorRelay<Bool> { get }
    var newUserName: PublishRelay<String> { get }
    var saveNewUserNameAction: PublishRelay<Void> { get }
    var isSaveNewUserNameActionAvailable: BehaviorRelay<Bool> { get }
    var changeEmail: PublishRelay<Void> { get }
    
    var changeBirthdayAction: PublishRelay<Void> { get }
    var isChangeBirthdayInProgress: BehaviorRelay<Bool> { get }
    var newBirthdayDate: BehaviorRelay<Date> { get }
    
    var changePasswordAction: PublishRelay<Void> { get }
    var isChangePasswordInProgress: BehaviorRelay<Bool> { get }
    
    var isLoading: BehaviorRelay<Bool> { get }
    var errorMessage: PublishRelay<String> { get }
    
    var goBackAction: PublishRelay<Void> { get }
}

class SettingsViewModel: SettingsViewModelProtocol {
    
    // MARK: - Properties
    let coordinator: SettingsCoordinatorProtocol!
    let disposeBag = DisposeBag()
    
    // Protocol conformance
    let userName = BehaviorRelay<String>(value: "Jennifer Lawrence")
    let changeUserNameAction = PublishRelay<Void>()
    let isChangeUserNameInProgress = BehaviorRelay<Bool>(value: false)
    let newUserName = PublishRelay<String>()
    let saveNewUserNameAction = PublishRelay<Void>()
    let isSaveNewUserNameActionAvailable = BehaviorRelay<Bool>(value: true)
    let changeEmail = PublishRelay<Void>()
    
    let changeBirthdayAction = PublishRelay<Void>()
    let isChangeBirthdayInProgress = BehaviorRelay<Bool>(value: false)
    let newBirthdayDate = BehaviorRelay<Date>(value: Date(timeIntervalSince1970: 800000000))
    
    let changePasswordAction = PublishRelay<Void>()
    let isChangePasswordInProgress = BehaviorRelay<Bool>(value: false)
    
    let isLoading = BehaviorRelay<Bool>(value: false)
    let errorMessage = PublishRelay<String>()
    
    let goBackAction = PublishRelay<Void>()
    
    init(coordinator: SettingsCoordinatorProtocol) {
        self.coordinator = coordinator
        
        // MARK: - User name
        // Toggle isChangeUserNameInProgress
        changeUserNameAction
            .map { [isChangeUserNameInProgress] in !isChangeUserNameInProgress.value }
            .bind(to: isChangeUserNameInProgress)
            .disposed(by: disposeBag)
        
        // Determine isSaveNewUserNameActionAvailable
        newUserName
            .map { !$0.isEmpty }
            .bind(to: isSaveNewUserNameActionAvailable)
            .disposed(by: disposeBag)
        
        // Save new userName and set isChangeUserNameInProgress to false
        saveNewUserNameAction
            .withLatestFrom(newUserName)
            .subscribe(onNext: { [userName, isChangeUserNameInProgress] in
                userName.accept($0)
                isChangeUserNameInProgress.accept(false) })
            .disposed(by: disposeBag)
        
        // Change password
        changeEmail
            .subscribe(onNext: {[coordinator] in coordinator.goToChangePasswordScreen() })
            .disposed(by: disposeBag)
        
        // MARK: - Birthday
        changeBirthdayAction
            .map { [isChangeBirthdayInProgress] in !isChangeBirthdayInProgress.value }
            .bind(to: isChangeBirthdayInProgress)
            .disposed(by: disposeBag)
        
        // MARK: - Change password
        changePasswordAction
            .map { [isChangePasswordInProgress] in !isChangePasswordInProgress.value }
            .bind(to: isChangePasswordInProgress)
            .disposed(by: disposeBag)
        
        // MARK: - Back
        // Return to container screen
        goBackAction
            .subscribe(onNext: { [coordinator] in coordinator.goBackToPreviousScreen() })
            .disposed(by: disposeBag)
    }
    
}
