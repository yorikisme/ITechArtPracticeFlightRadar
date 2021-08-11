//
//  SignInViewModel.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 8/11/21.
//

import Foundation
import Firebase

protocol SignInProtocol {
    func signInWith(email: String, password: String)
}

class SignInViewModel: SignInProtocol {
    var coordinator: SignInCoordinator!
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
}
