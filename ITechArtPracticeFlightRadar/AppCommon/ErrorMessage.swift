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
    static let authenticationError = "Please, check the authentication credentials you provide"
    static let networkError = "Network error, please, check your connection or try again later"
    static let internalSignUpError = "Internal error occurred, please, try to sign up later or contact the customer service"
    static let internalSignInError = "Internal error occurred, please, try to sign in later or contact the customer service"
    static let unknownError = "Unknown error occurred, please, try again later or contact the customer service"
    
    
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
