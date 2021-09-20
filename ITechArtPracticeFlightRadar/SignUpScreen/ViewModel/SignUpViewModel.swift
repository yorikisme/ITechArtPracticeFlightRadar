//
//  SignUpViewModel.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/2/21.
//

import Foundation
import Firebase
import RxSwift
import RxRelay

protocol SignUpViewModelProtocol {
    var state: BehaviorRelay<State> { get }
    var email: BehaviorRelay<String> { get }
    var password: BehaviorRelay<String> { get }
    var passwordConfirmation: BehaviorRelay<String> { get }
    var isEmailValid: BehaviorRelay<Bool> { get }
    var isPasswordValid: BehaviorRelay<Bool> { get }
    var passwordMatch: BehaviorRelay<Bool> { get }
    var isSignUpEnabled: BehaviorRelay<Bool> { get }
    var signUp: PublishRelay<Void> { get }
}

class SignUpViewModel: SignUpViewModelProtocol {
    
    // MARK: - Properties
    var coordinator: SignUpCoordinatorProtocol!
    let disposeBag = DisposeBag()
    
    // Protocol conformation
    let state = BehaviorRelay<State>(value: .standby)
    let email = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    let passwordConfirmation = BehaviorRelay<String>(value: "")
    let isEmailValid = BehaviorRelay<Bool>(value: false)
    let isPasswordValid = BehaviorRelay<Bool>(value: false)
    let passwordMatch = BehaviorRelay<Bool>(value: false)
    var isSignUpEnabled = BehaviorRelay<Bool>(value: false)
    let signUp = PublishRelay<Void>()
    
    init(coordinator: SignUpCoordinatorProtocol) {
        self.coordinator = coordinator
        
        // Shared instance of validated email
        let validatedEmail = email
            .map { ($0, $0.emailValid) }
            .share(replay: 1, scope: .whileConnected)
        
        // Shared instance of validated password
        let validatedPassword = password.map { ($0, $0.passwordValid) }.share(replay: 1, scope: .whileConnected)
        
        // Shared instance of passwordConfirmation
        let validatedPasswordConfirmation = passwordConfirmation.share(replay: 1, scope: .whileConnected)
        
        // Setting up isEmailValid
        validatedEmail
            .map { $0.isEmpty || $1 }
            .subscribe(onNext: { [isEmailValid] in isEmailValid.accept($0) })
            .disposed(by: disposeBag)
        
        // Setting up isPasswordValid
        validatedPassword
            .map { $0.isEmpty || $1 }
            .subscribe(onNext: { [isPasswordValid] in isPasswordValid.accept($0) })
            .disposed(by: disposeBag)
        
        // Setting up passwordConfirmation
        Observable
            .combineLatest(validatedPassword, validatedPasswordConfirmation)
            .map { $0.0 == $1 || $1.isEmpty }
            .subscribe(onNext: { [passwordMatch] in passwordMatch.accept($0) })
            .disposed(by: disposeBag)
        
        // Setting up isSignUpEnabled
        Observable.combineLatest(validatedEmail, validatedPassword, validatedPasswordConfirmation)
            .map {
                let isEmailValid = $0.1
                let isPasswordValid = $1.1
                let validPassword = $1.0
                let confirmedPassword = $2
                return isEmailValid && isPasswordValid && validPassword == confirmedPassword
            }
            .subscribe(onNext: { [isSignUpEnabled] in isSignUpEnabled.accept($0) })
            .disposed(by: disposeBag)
        
        // Sign up
        signUp
            .withLatestFrom(Observable.combineLatest(validatedEmail, validatedPassword))
            .filter { $0.1 && $1.1 }
            .map { ($0.0, $1.0) }
            .observe(on: SerialDispatchQueueScheduler(qos: .userInitiated))
            .startProcessing(state: state)
            .flatMapLatest { Auth.auth().rx.signUpWith(email: $0.0, password: $0.1) }
            .stopProcessing(state: state)
            .retry()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [coordinator] _ in
                coordinator.signUp()
                coordinator.sendVerificationLetter { error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("Verification letter sent")
                    }
                }
            })
            .disposed(by: disposeBag)
        
    }
    
}
