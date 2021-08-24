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
    var invalidEmailMessage: BehaviorRelay<String?> { get }
    var invalidPasswordMessage: BehaviorRelay<String?> { get }
    var isSignInEnabled: BehaviorRelay<Bool> { get }
    var signIn: PublishRelay<Void> { get }
    var isEmailFormatValid: BehaviorRelay<Bool> { get }
    var isPasswordSecure: BehaviorRelay<Bool> { get }
    
}

class AuthenticationViewModel: AuthenticationViewModelProtocol {
    
    // MARK: - Properties
    var coordinator: AuthenticationCoordinatorProtocol!
    let disposeBag = DisposeBag()
    
    // Protocol conformation
    let email = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    let invalidEmailMessage = BehaviorRelay<String?>(value: nil)
    let invalidPasswordMessage = BehaviorRelay<String?>(value: nil)
    let isSignInEnabled = BehaviorRelay<Bool>(value: false)
    let signIn = PublishRelay<Void>()
    let isEmailFormatValid = BehaviorRelay<Bool>(value: false)
    let isPasswordSecure = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Initializers
    init(coordinator: AuthenticationCoordinator) {
        
        // Shared instance of validated email
        let validatedEmail = email
            .map { ($0, $0.emailValid) }
            .share(replay: 1, scope: .whileConnected)
        
        // Shared instance of validated password
        let validatedPassword = password
            .map { ($0, $0.passwordValid) }
            .share(replay: 1, scope: .whileConnected)
        
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
            .flatMapLatest { Observable.of(($0.0, $1.0)) }
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

extension String {
    var emailValid: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    var passwordValid: Bool { self.count > 5 }
}

extension Reactive where Base: Auth {
    func signInWith(email: String, password: String) -> Single<AuthDataResult>  {
        return Single<AuthDataResult>.create { observer in
            self.base.signIn(withEmail: email, password: password) { result, error in
                if let result = result {
                    observer(.success(result))
                } else {
                    observer(.failure(error ?? NSError()))
                }
            }
            return Disposables.create {
                //Auth.auth().cancelRequest()
            }
        }
    }
}
