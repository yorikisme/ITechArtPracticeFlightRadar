//
//  ReactiveExtensions.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 8/25/21.
//

import RxSwift
import Firebase

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
    
    func forgotPassword(email: String) -> Single<Void> {
        return Single<Void>.create { observer in
            self.base.sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    observer(.failure(error))
                    print(error.localizedDescription)
                } else {
                    observer(.success(Void()))
                    print("Success")
                }
            }
            return Disposables.create {
            }
        }
    }
}
