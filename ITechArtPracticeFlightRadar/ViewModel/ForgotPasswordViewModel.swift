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
    var state: BehaviorRelay<State> { get }
    var email: BehaviorRelay<String> { get }
    var isEmailFormatValid: BehaviorRelay<Bool> { get }
    var isSendResetRequestEnabled: BehaviorRelay<Bool> { get }
    var sendResetRequest: PublishRelay<Void> { get }
}

class ForgotPasswordViewModel: ForgotPasswordViewModelProtocol {
    
    // MARK: Properties
    var coordinator: ForgotPasswordCoordinatorProtocol!
    let disposeBag = DisposeBag()
    
    // Protocol conformation
    let state = BehaviorRelay<State>(value: .standby)
    let email = BehaviorRelay<String>(value: "")
    let isEmailFormatValid = BehaviorRelay<Bool>(value: false)
    let isSendResetRequestEnabled = BehaviorRelay<Bool>(value: false)
    let sendResetRequest = PublishRelay<Void>()
    
    // MARK: Initializers
    init(coordinator: ForgotPasswordCoordinatorProtocol) {
        self.coordinator = coordinator
        
        let validatedEmail = email
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .map { ($0, $0.emailValid) }
            .share(replay: 1, scope: .whileConnected)
        
        sendResetRequest
            .withLatestFrom(validatedEmail)
            .observe(on: SerialDispatchQueueScheduler(qos: .userInitiated))
            .filter { _, isValid in isValid }
            .map { email, isValid in }
            .startProcessing(state: state)
            .flatMapLatest { [email] in Auth.auth().rx.forgotPassword(email: email.value) }
            .stopProcessing(state: state)
            .retry()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {  })
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
