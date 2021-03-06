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
            base.signIn(withEmail: email, password: password) { result, error in
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
    
    func signUpWith(email: String, password: String) -> Single<AuthDataResult> {
        return Single<AuthDataResult>.create { observer in
            base.createUser(withEmail: email, password: password) { result, error in
                if let result = result {
                    observer(.success(result))
                } else {
                    observer(.failure(error ?? NSError()))
                }
            }
            return Disposables.create {
            }
        }
    }
    
    func forgotPassword(email: String) -> Single<Void> {
        return Single<Void>.create { observer in
            base.sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    observer(.failure(error))
                    print(error.localizedDescription)
                } else {
                    observer(.success(Void()))
                    print("Reset password letter sent")
                }
            }
            return Disposables.create {}
        }
    }
    
    func signOut() -> Single<Void> {
        return Single<Void>.create { observer in
            do {
                try base.signOut()
                observer(.success(Void()))
                print("Sign out success")
            } catch {
                observer(.failure(error))
                print("Sign out error: \(error.localizedDescription)")
            }
            return Disposables.create {}
        }
    }
    
    func reloadUser() -> Single<Bool> {
        return Single<Bool>.create { observer in
            base.currentUser?.reload(completion: { error in
                if let error = error {
                    observer(.failure(error))
                    print("Reload error")
                } else {
                    if let status = base.currentUser?.isEmailVerified {
                        if status {
                            observer(.success(status))
                            print("EVS1: \(status)")
                        } else {
                            observer(.failure(NSError()))
                            print("EVS2: \(status)")
                        }
                    }
                }
            })
            return Disposables.create {
            }
        }
    }
    
    func changeUserEmail(to newEmail: String) -> Single<Void> {
        return Single<Void>.create { observer in
            base.currentUser?.updateEmail(to: newEmail, completion: { error in
                if let error = error {
                    observer(.failure(error))
                    print("Change email error \(error.localizedDescription)")
                } else {
                    observer(.success(Void()))
                    print("Change email success")
                }
            })
            return Disposables.create {}
        }
    }
    
    func changeUserEmailTo(newEmail: String, passwordCheck: String) -> Single<Void> {
        return Single<Void>.create { observer in
            let userEmail = base.currentUser?.email
            let credential = EmailAuthProvider.credential(withEmail: userEmail ?? "", password: passwordCheck)
            base.currentUser?.reauthenticate(with: credential, completion: { result, error in
                if let error = error {
                    print("Reauthentication error")
                    observer(.failure(error))
                } else {
                    base.currentUser?.updateEmail(to: newEmail, completion: { error in
                        if let error = error {
                            print("Update email error")
                            observer(.failure(error))
                        } else {
                            print("Update email success")
                            observer(.success(Void()))
                        }
                    })
                }
            })
            return Disposables.create {}
        }
    }
    
    func reauthenticateUserBy(password: String, newEmail: String) -> Single<String> {
        return Single<String>.create { observer in
            let userEmail = base.currentUser?.email
            let credential = EmailAuthProvider.credential(withEmail: userEmail ?? "", password: password)
            base.currentUser?.reauthenticate(with: credential, completion: { result, error in
                if let error = error {
                    observer(.failure(error))
                } else {
                    observer(.success(newEmail))
                }
            })
            return Disposables.create {}
        }
    }
    
    func changeUserCurrentEmailTo(newEmail: String) -> Single<Void> {
        return Single<Void>.create { observer in
            base.currentUser?.updateEmail(to: newEmail, completion: { error in
                if let error = error {
                    observer(.failure(error))
                } else {
                    observer(.success(Void()))
                }
            })
            return Disposables.create {}
        }
    }
    
    func reauthenticateUserBy(password: String, newPassword: String) -> Single<String> {
        return Single<String>.create { observer in
            let userEmail = base.currentUser?.email
            let credential = EmailAuthProvider.credential(withEmail: userEmail ?? "", password: password)
            base.currentUser?.reauthenticate(with: credential, completion: { result, error in
                if let error = error {
                    observer(.failure(error))
                } else {
                    observer(.success(newPassword))
                }
            })
            return Disposables.create {}
        }
    }
    
    func changeUserCurrentPasswordTo(newPassword: String) -> Single<Void> {
        return Single<Void>.create { observer in
            base.currentUser?.updatePassword(to: newPassword, completion: { error in
                if let error = error {
                    observer(.failure(error))
                } else {
                    observer(.success(Void()))
                }
            })
            return Disposables.create {}
        }
    }
    
}
