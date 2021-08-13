//
//  AuthenticationViewModel.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 8/11/21.
//

import Foundation
import Firebase
import GoogleSignIn

protocol AuthenticationViewModelProtocol {
    func signInWith(email: String, password: String)
    func signInWithGoogle()
    func validateEmail(candidate: String) -> Bool
}

class AuthenticationViewModel: AuthenticationViewModelProtocol {
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
    
    func validateEmail(candidate: String) -> Bool {
     let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
}
