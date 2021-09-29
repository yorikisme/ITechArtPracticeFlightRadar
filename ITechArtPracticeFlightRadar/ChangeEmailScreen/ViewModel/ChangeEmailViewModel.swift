//
//  ChangeEmailViewModel.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/27/21.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth

protocol ChangeEmailViewModelProtocol {
    var email: BehaviorRelay<String> { get }
    var password: BehaviorRelay<String> { get }
    var saveAction: PublishRelay<Void> { get }
    var isSaveActionAvailable: BehaviorRelay<Bool> { get }
    var goBackAction: PublishRelay<Void> { get }
    var isLoading: Observable<Bool> { get }
    var errorMessage: PublishRelay<String> { get }
}

class ChangeEmailViewModel: ChangeEmailViewModelProtocol {
    
    // MARK: - Properties
    let coordinator: ChangeEmailCoordinatorProtocol
    let disposeBag = DisposeBag()
    let activityIndicator = ActivityIndicator()
    
    // Protocol conformation
    let email = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    let saveAction = PublishRelay<Void>()
    let isSaveActionAvailable = BehaviorRelay<Bool>(value: false)
    let goBackAction = PublishRelay<Void>()
    var isLoading: Observable<Bool> {
        return activityIndicator.asObservable()
    }
    let errorMessage = PublishRelay<String>()
    
    // MARK: - Initializer
    init(coordinator: ChangeEmailCoordinatorProtocol) {
        self.coordinator = coordinator
        
        // Shared instance of validated email
        let validatedEmail = email
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .map { ($0, $0.emailValid) }
            .share(replay: 1, scope: .whileConnected)
        
        // Shared instance of password
        // Shared instance of validated password
        let validatedPassword = password
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .map { ($0, $0.passwordValid) }
            .share(replay: 1, scope: .whileConnected)
        
        // isSaveActionAvailable check
        Observable
            .combineLatest (validatedEmail, validatedPassword) { $0.1 && $1.1 }
        .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
        .subscribe(onNext: { [isSaveActionAvailable] in isSaveActionAvailable.accept($0) })
        .disposed(by: disposeBag)
        
        // Save new email
        saveAction
            .withLatestFrom(Observable.combineLatest(validatedEmail, validatedPassword))
            .filter { validatedEmail, validatedPassword in validatedEmail.1 && validatedPassword.1 }
            .flatMapLatest { [activityIndicator, errorMessage] validatedEmail, validatedPassword in
                Auth.auth().rx.reauthenticateUserBy(password: validatedPassword.0, newEmail: validatedEmail.0)
                    .flatMap { newEmail in
                        Auth.auth().rx.changeUserCurrentEmailTo(newEmail: newEmail)
                    }
                    .trackActivity(activityIndicator)
                    .catch { error in
                        ErrorMessage.failure(dueTo: error, observer: errorMessage)
                        return .empty()
                    }
            }
            .retry()
            .subscribe(onNext: { print("Change email procedure end") })
            .disposed(by: disposeBag)
        
        // Return to settings
        goBackAction
            .subscribe(onNext: { [coordinator] in coordinator.goBackToPreviousScreen() })
            .disposed(by: disposeBag)
        
    }
    
}
