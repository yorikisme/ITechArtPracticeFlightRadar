//
//  ForgotPasswordViewModel.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/1/21.
//

import Foundation
import Firebase
import RxSwift
import RxRelay

protocol ForgotPasswordViewModelProtocol {
    var errorMessage: PublishRelay<String?> { get }
    var email: BehaviorRelay<String> { get }
    var isEmailFormatValid: BehaviorRelay<Bool> { get }
    var isSendResetRequestEnabled: BehaviorRelay<Bool> { get }
    var sendResetRequest: PublishRelay<Void> { get }
    var isLoading: Observable<Bool> { get }
    var goBackAction: PublishRelay<Void> { get }
}

class ForgotPasswordViewModel: ForgotPasswordViewModelProtocol {
    
    // MARK: Properties
    var coordinator: ForgotPasswordCoordinatorProtocol!
    let disposeBag = DisposeBag()
    let activityIndicator = ActivityIndicator()
    
    // Protocol conformation
    let errorMessage = PublishRelay<String?>()
    let email = BehaviorRelay<String>(value: "")
    let isEmailFormatValid = BehaviorRelay<Bool>(value: false)
    let isSendResetRequestEnabled = BehaviorRelay<Bool>(value: false)
    let sendResetRequest = PublishRelay<Void>()
    var isLoading: Observable<Bool> {
        return activityIndicator.asObservable()
    }
    let goBackAction = PublishRelay<Void>()
    
    // MARK: Initializers
    init(coordinator: ForgotPasswordCoordinatorProtocol) {
        self.coordinator = coordinator
        
        // Go back action
        goBackAction
            .subscribe(onNext: { coordinator.goBack() })
            .disposed(by: disposeBag)
        
        // Shared instance of validated email
        let validatedEmail = email
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .map { ($0, $0.emailValid) }
            .share(replay: 1, scope: .whileConnected)
        
        sendResetRequest
            .withLatestFrom(validatedEmail)
            .observe(on: SerialDispatchQueueScheduler(qos: .userInitiated))
            .filter { _, isValid in isValid }
            .map { email, isValid in }
            .flatMapLatest { [activityIndicator, email] in Auth.auth().rx.forgotPassword(email: email.value).trackActivity(activityIndicator) }
            .retry()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                coordinator.finishForgotPasswordProcedure()
            })
            .disposed(by: disposeBag)
        
        validatedEmail
            .map { $0.isEmpty || $1 }
            .bind(to: isEmailFormatValid)
            .disposed(by: disposeBag)
        
        validatedEmail
            .map { email, isValid in isValid }
            .subscribe(onNext: { [isSendResetRequestEnabled] in isSendResetRequestEnabled.accept($0) })
            .disposed(by: disposeBag)
    }
    
}
