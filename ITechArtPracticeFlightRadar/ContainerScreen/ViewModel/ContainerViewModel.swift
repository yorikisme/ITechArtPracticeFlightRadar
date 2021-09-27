//
//  ContainerViewModel.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/16/21.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt
import Firebase

class ContainerViewModel: ContainerViewModelProtocol {
    
    // MARK: - Properties
    private let coordinator: ContainerCoordinatorProtocol
    let disposeBag = DisposeBag()
    let activityIndicator = ActivityIndicator()
    
    // MARK: Protocol conformation
    let isMenuOpen = BehaviorRelay<Bool>(value: false)
    let menuAction = PublishRelay<Void>()
    let isEmailVerified = BehaviorRelay<Bool>(value: false)
    let signOutAction = PublishRelay<Void>()
    var isLoading: Observable<Bool> {
        return activityIndicator.asObservable()
    }
    
    // MARK: - Initializer
    init(coordinator: ContainerCoordinatorProtocol) {
        self.coordinator = coordinator
        
        if Auth.auth().currentUser!.isEmailVerified {
            isEmailVerified.accept(true)
            print("Email has already been verified")
        }
        
        menuAction
            .withLatestFrom(isMenuOpen)
            .map{ !$0 }
            .bind(to: isMenuOpen)
            .disposed(by: disposeBag)
        
        Observable<Int>.interval(.seconds(1), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .take(while: { [isEmailVerified] _ in isEmailVerified.value == false })
            .flatMap { _ in Auth.auth().rx.reloadUser() }
            .retry(.exponentialDelayed(maxCount: 1000, initial: 10, multiplier: 1), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { [isEmailVerified] in isEmailVerified.accept($0) })
            .disposed(by: disposeBag)
        
        // Signing out
        signOutAction
            .flatMap { [activityIndicator] in Auth.auth().rx.signOut().trackActivity(activityIndicator) }
            .subscribe(onNext: { coordinator.signOut() })
            .disposed(by: disposeBag)
            
    }
    
}
