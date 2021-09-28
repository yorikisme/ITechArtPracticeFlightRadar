//
//  SettingsViewModel.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/27/21.
//

import Foundation
import RxSwift
import RxCocoa

protocol SettingsViewModelProtocol {
    var changeEmail: PublishRelay<Void> { get }
    var goBackAction: PublishRelay<Void> { get }
}

class SettingsViewModel: SettingsViewModelProtocol {
    
    // MARK: - Properties
    let coordinator: SettingsCoordinatorProtocol!
    let disposeBag = DisposeBag()
    
    // Protocol conformance
    let changeEmail = PublishRelay<Void>()
    let goBackAction = PublishRelay<Void>()
    
    init(coordinator: SettingsCoordinatorProtocol) {
        self.coordinator = coordinator
        
        // Change password
        changeEmail
            .subscribe(onNext: {[coordinator] in coordinator.goToChangePasswordScreen() })
            .disposed(by: disposeBag)
        
        // Return to container screen
        goBackAction
            .subscribe(onNext: { [coordinator] in coordinator.goBackToPreviousScreen() })
            .disposed(by: disposeBag)
    }
    
}
