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
    
}
