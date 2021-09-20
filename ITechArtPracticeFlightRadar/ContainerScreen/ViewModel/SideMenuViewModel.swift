//
//  SideMenuViewModel.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/10/21.
//

import Foundation
import Firebase
import RxSwift
import RxCocoa

protocol SideMenuCoordinatorProtocol {
    func goToSettings()
    func signOut()
}

class SideMenuViewModel: SideMenuViewModelProtocol {
    let disposeBag = DisposeBag()
    let settings = PublishRelay<Void>()
    let signOut = PublishRelay<Void>()
    let coordinator: SideMenuCoordinatorProtocol
    
    init(coordinator: SideMenuCoordinatorProtocol, service: NetworkManagerProtocol) {
        self.coordinator = coordinator
        
        // Segue to the settings
        settings
            .subscribe(onNext: { coordinator.goToSettings() })
            .disposed(by: disposeBag)
        
        // Signing out
        signOut
            .flatMapLatest { Auth.auth().rx.signOut() }
            .subscribe(onNext: { coordinator.signOut() },
                       onError: { print($0.localizedDescription) })
            .disposed(by: disposeBag)
    }
    
}
