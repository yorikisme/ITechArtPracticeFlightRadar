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
    var coordinator: AuthenticationCoordinator!
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
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: coordinator.navigationController.topViewController!) { user, error in

          if let error = error {
            print(error.localizedDescription)
            return
          }

          guard
            let authentication = user?.authentication,
            let idToken = authentication.idToken
          else {
            return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: authentication.accessToken)

          // ...
        }
    }
}
