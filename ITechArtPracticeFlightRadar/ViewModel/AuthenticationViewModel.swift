//
//  AuthenticationViewModel.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 8/11/21.
//

import Foundation
import RxSwift
import Firebase
import GoogleSignIn

protocol AuthenticationViewModelProtocol {
    func signInWith(email: String, password: String)
    func signInWithGoogle()
    var email: PublishSubject<String> { get }
    var password: PublishSubject<String> { get }
    func areEmailAndPasswordValid() -> Observable<Bool>
}

class AuthenticationViewModel: AuthenticationViewModelProtocol {
    
    let disposeBag = DisposeBag()
    var email = PublishSubject<String>()
    var password = PublishSubject<String>()
    
    var coordinator: AuthenticationCoordinatorProtocol!
    func signInWith(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [coordinator] result, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            coordinator?.signIn()
            print("Successfully signed in")
        }
    }
    
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
    
    func areEmailAndPasswordValid() -> Observable<Bool> {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return Observable.combineLatest(email.asObservable(), password.asObservable()).map { email, password in
            return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email) && password.count > 5
        }
    }
    
}
