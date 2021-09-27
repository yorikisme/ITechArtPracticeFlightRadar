//
//  AuthenticationViewModel.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 8/11/21.
//

import Foundation
import RxSwift
import RxRelay
import RxSwiftExt
import Firebase

protocol AuthenticationViewModelProtocol {
    var errorMessage: PublishRelay<String> { get }
    var email: BehaviorRelay<String> { get }
    var password: BehaviorRelay<String> { get }
    var isSignInEnabled: BehaviorRelay<Bool> { get }
    var signIn: PublishRelay<Void> { get }
    var signUp: PublishRelay<Void> { get }
    var forgotPassword: PublishRelay<Void> { get }
    var isEmailFormatValid: BehaviorRelay<Bool> { get }
    var isPasswordSecure: BehaviorRelay<Bool> { get }
    var googleAuthentication: PublishRelay<Void> { get }
    var isLoading: Observable<Bool> { get }
}

class AuthenticationViewModel: AuthenticationViewModelProtocol {
    // MARK: - Properties
    var coordinator: AuthenticationCoordinatorProtocol!
    let disposeBag = DisposeBag()
    let indicator = ActivityIndicator()
    
    // Protocol conformation
    let errorMessage = PublishRelay<String>()
    let email = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    let isSignInEnabled = BehaviorRelay<Bool>(value: false)
    let signIn = PublishRelay<Void>()
    let signUp = PublishRelay<Void>()
    let forgotPassword = PublishRelay<Void>()
    let isEmailFormatValid = BehaviorRelay<Bool>(value: false)
    let isPasswordSecure = BehaviorRelay<Bool>(value: false)
    let googleAuthentication = PublishRelay<Void>()
    var isLoading: Observable<Bool> {
        return indicator.asObservable()
    }
    
    // MARK: - Initializers
    init(coordinator: AuthenticationCoordinator) {
        
        self.coordinator = coordinator
        
        // Shared instance of validated email
        let validatedEmail = email
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .map { ($0, $0.emailValid)
            }
            .share(replay: 1, scope: .whileConnected)
        
        // Shared instance of validated password
        let validatedPassword = password
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .map { ($0, $0.passwordValid) }
            .share(replay: 1, scope: .whileConnected)
        
        // isSignInEnabled check
        Observable.combineLatest (validatedEmail, validatedPassword) {
            $0.1 && $1.1
        }
        .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
        .subscribe(onNext: { [isSignInEnabled] in
            isSignInEnabled.accept($0)
        })
        .disposed(by: disposeBag)
        
        // Authentication
        signIn
            .withLatestFrom(Observable.combineLatest(validatedEmail, validatedPassword))
            .filter { $0.1 && $1.1 }
            .map { ($0.0, $1.0) }
            .observe(on: SerialDispatchQueueScheduler(qos: .userInitiated))
            .flatMapLatest { [errorMessage, indicator] in
                Auth.auth().rx
                    .signInWith(email: $0.0, password: $0.1)
                    .trackActivity(indicator)
                    .catch { error in
                        ErrorMessage.failure(dueTo: error, observer: errorMessage)
                        return .empty()
                    }
            }
            .retry()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [coordinator] _ in coordinator.signIn() })
            .disposed(by: disposeBag)
        
        // Invalid email format check
        validatedEmail
            .map { $0.isEmpty || $1 }
            .bind(to: isEmailFormatValid)
            .disposed(by: disposeBag)
        
        // Password security check
        validatedPassword
            .map { $0.isEmpty || $1 }
            .bind(to: isPasswordSecure)
            .disposed(by: disposeBag)
        
        // Authentication with Google
        googleAuthentication
            .subscribe(onNext: { [weak self] in self?.signInWithGoogle() },
                       onError: { print($0.localizedDescription) })
            .disposed(by: disposeBag)
        
        // Forgot password
        forgotPassword
            .subscribe(onNext: { [coordinator] in coordinator.forgotPassword() })
            .disposed(by: disposeBag)
        
        // Sign up with a personal email
        signUp
            .subscribe(onNext: { [coordinator] in coordinator.signUp() })
            .disposed(by: disposeBag)
        
        #if DEBUG
        email.accept("itechpractice@gmail.com")
        password.accept("1234567")
        #endif
    }
    
    // MARK: - Methods
    func signInWithGoogle() {
        coordinator.signInWithGoogle { [weak self] user, error in
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
            self?.coordinator?.signIn()
            print(credential)
        }
    }
}
