//
//  ErrorMessages.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/27/21.
//

import Foundation
import RxSwift
import RxCocoa

enum ErrorMessage {
    
    // Error messages
    static let authenticationError = NSLocalizedString("authentication_error", comment: "")
    static let networkError = NSLocalizedString("network_error", comment: "")
    static let internalSignUpError = NSLocalizedString("internal_sign_up_error", comment: "")
    static let internalSignInError = NSLocalizedString("internal_sign_in_error", comment: "")
    static let unknownError = NSLocalizedString("unknown_error", comment: "")
    
    
    static func failure(dueTo error: Error, observer: PublishRelay<String>) {
        let errorCode = (error as NSError).code
        print(errorCode)
        switch errorCode {
        case 17007:
            observer.accept(ErrorMessage.internalSignUpError)
        case 17008, 17009:
            observer.accept(ErrorMessage.authenticationError)
        case 17011:
            observer.accept(ErrorMessage.internalSignInError)
        case 17020:
            observer.accept(ErrorMessage.networkError)
        default:
            observer.accept(ErrorMessage.unknownError)
        }
    }
}
