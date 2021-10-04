//
//  ChangePasswordViewModel.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 10/4/21.
//

import Foundation
import RxSwift
import RxRelay
import Firebase

protocol ChangePasswordViewModelProtocol {
    var currentPassword: BehaviorRelay<String> { get }
    var newPassword: BehaviorRelay<String> { get }
    var newPasswordConfirmation: BehaviorRelay<String> { get }
    
    var isPasswordSecure: BehaviorRelay<Bool> { get }
    var passwordsMatch: BehaviorRelay<Bool> { get }
    
    var isSaveActionAvailable: BehaviorRelay<Bool> { get }
    var saveAction: PublishRelay<Void> { get }
    
    var isLoading: Observable<Bool> { get }
    var errorMessage: PublishRelay<String> { get }
    
    var cancelAction: PublishRelay<Void> { get }
}

class ChangePasswordViewModel: ChangePasswordViewModelProtocol {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    let activityIndicator = ActivityIndicator()
    
    /// Protocol conformation
    let currentPassword = BehaviorRelay<String>(value: "")
    let newPassword = BehaviorRelay<String>(value: "")
    let newPasswordConfirmation = BehaviorRelay<String>(value: "")
    
    let isPasswordSecure = BehaviorRelay<Bool>(value: false)
    let passwordsMatch = BehaviorRelay<Bool>(value: false)
    
    let isSaveActionAvailable = BehaviorRelay<Bool>(value: false)
    let saveAction = PublishRelay<Void>()
    
    var isLoading: Observable<Bool> {
        return activityIndicator.asObservable()
    }
    let errorMessage = PublishRelay<String>()
    
    var cancelAction = PublishRelay<Void>()
    
    init() {
        /// Shared instances
        let sharedCurrentPassword = currentPassword.share(replay: 1, scope: .whileConnected)
        let sharedNewPassword = newPassword.share(replay: 1, scope: .whileConnected)
        let sharedPasswordConfirmation = newPasswordConfirmation.share(replay: 1, scope: .whileConnected)
        
        /// Determine whether isPasswordSecure true or false
        newPassword
            .debounce(.milliseconds(300), scheduler: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .map { $0.isEmpty || $0.passwordValid }
            .bind(to: isPasswordSecure)
            .disposed(by: disposeBag)
        
        /// Determine whether passwordsMatch true or false
        Observable
            .combineLatest(newPassword, newPasswordConfirmation)
            .debounce(.milliseconds(300), scheduler: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .map { value -> Bool in
                let newPassword = value.0
                let newPasswordConfirmation = value.1
                return newPasswordConfirmation.isEmpty || newPassword == newPasswordConfirmation
            }
            .bind(to: passwordsMatch)
            .disposed(by: disposeBag)
        
        /// Determine whether isSaveActionAvailable true or false
        Observable
            .combineLatest(sharedCurrentPassword, sharedNewPassword, sharedPasswordConfirmation)
            .map { value in
                let currentPassword = value.0
                let newPassword = value.1
                let newPasswordConfirmation = value.2
                return !currentPassword.isEmpty && newPassword.passwordValid && newPassword == newPasswordConfirmation }
            .bind(to: isSaveActionAvailable)
            .disposed(by: disposeBag)
        
        /// occurrence of saveAction
        saveAction
            .withLatestFrom(Observable.combineLatest(sharedCurrentPassword, sharedNewPassword))
            .flatMapLatest { [activityIndicator, errorMessage] in
                Auth.auth().rx.reauthenticateUserBy(password: $0, newPassword: $1)
                    .flatMap { newPassword in
                        Auth.auth().rx.changeUserCurrentPasswordTo(newPassword: newPassword)
                    }
                    .trackActivity(activityIndicator)
                    .catch { error in
                        ErrorMessage.failure(dueTo: error, observer: errorMessage)
                        return .empty()
                    }
            }
            .retry()
            .subscribe(onNext: { [weak self] in
                        self?.currentPassword.accept("")
                        self?.newPassword.accept("")
                        self?.newPasswordConfirmation.accept("")
                        print("Password successfully changed") })
            .disposed(by: disposeBag)
        
        /// occurrence of cancelAction
        cancelAction
            .subscribe(onNext: { [weak self] in
                self?.currentPassword.accept("")
                self?.newPassword.accept("")
                self?.newPasswordConfirmation.accept("")
            })
            .disposed(by: disposeBag)
        
    }
    
}
