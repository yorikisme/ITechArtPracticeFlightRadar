//
//  AuthenticationViewModel.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 8/11/21.
//

import Foundation
import RxSwift
import RxRelay
import Firebase
import GoogleSignIn

protocol AuthenticationViewModelProtocol {
    var email: BehaviorRelay<String> { get }
    var password: BehaviorRelay<String> { get }
    var isSignInEnabled: BehaviorRelay<Bool> { get }
    var signIn: PublishRelay<Void> { get }
    var isEmailFormatValid: BehaviorRelay<Bool> { get }
    var isPasswordSecure: BehaviorRelay<Bool> { get }
    var googleAuthentication: PublishRelay<Void> { get }
}

class AuthenticationViewModel: AuthenticationViewModelProtocol {
    // MARK: - Properties
    var coordinator: AuthenticationCoordinatorProtocol!
    let disposeBag = DisposeBag()
    
    // Protocol conformation
    let email = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    let isSignInEnabled = BehaviorRelay<Bool>(value: false)
    let signIn = PublishRelay<Void>()
    let isEmailFormatValid = BehaviorRelay<Bool>(value: false)
    let isPasswordSecure = BehaviorRelay<Bool>(value: false)
    let googleAuthentication = PublishRelay<Void>()
    
    // MARK: - Initializers
    init(coordinator: AuthenticationCoordinator) {
        self.coordinator = coordinator
        // Shared instance of validated email
        let validatedEmail = email
            .map { ($0, $0.emailValid) }
        //            .share(replay: 1, scope: .whileConnected)
        
        // Shared instance of validated password
        let validatedPassword = password
            .map { ($0, $0.passwordValid) }
        //            .share(replay: 1, scope: .whileConnected)
        
        // isSignInEnabled check
        Observable.combineLatest (validatedEmail, validatedPassword) {
            $0.1 && $1.1
        }
        .subscribe(onNext: { [isSignInEnabled] in
            isSignInEnabled.accept($0)
        })
        .disposed(by: disposeBag)
        
        // Authentication
        signIn
            .withLatestFrom(Observable.combineLatest(validatedEmail, validatedPassword))
            .filter { $0.1 && $1.1 }
            .map{ ($0.0, $1.0) }
            .flatMapLatest { Auth.auth().rx.signInWith(email: $0.0, password: $0.1) }
            .do(onError: { print($0.localizedDescription)})
            .retry()
            .subscribe(onNext: { [coordinator] _ in
                coordinator.signIn()
            })
            .disposed(by: disposeBag)
        
        // Invalid email format check
        validatedEmail
            .map { $0.0.isEmpty || $0.1 }
            .bind(to: isEmailFormatValid)
            .disposed(by: disposeBag)
        
        // Password security check
        validatedPassword
            .map { $0.0.isEmpty || $0.1 }
            .bind(to: isPasswordSecure)
            .disposed(by: disposeBag)
        
        // Authentication with Google
        googleAuthentication.subscribe(onNext: { [weak self] in
            self?.signInWithGoogle()
        }, onError: {
            print($0.localizedDescription)
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Methods
    func signInWithGoogle() {
        coordinator.signInWithGoogle { user, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let authentication = user?.authentication,
                  let idToken = authentication.idToken else {
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            self.coordinator?.signIn()
            print(credential)
        }
    }
}
