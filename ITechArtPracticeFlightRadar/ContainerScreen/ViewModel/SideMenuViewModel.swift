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
    //func signOut()
}

class SideMenuViewModel: SideMenuViewModelProtocol {
    
    // MARK: Properties
    let coordinator: SideMenuCoordinatorProtocol
    let disposeBag = DisposeBag()
    let activityIndicator = ActivityIndicator()
    
    // MARK: Protocol conformation
    let settings = PublishRelay<Void>()
    //let signOut = PublishRelay<Void>()
    let signOutAction = PublishRelay<Void>()
    
    
    init(coordinator: SideMenuCoordinatorProtocol, service: NetworkManagerProtocol) {
        self.coordinator = coordinator
        
        // Segue to the settings
        settings
            .subscribe(onNext: { coordinator.goToSettings() })
            .disposed(by: disposeBag)
        
        // Signing out
//        signOut
//            .debounce(.milliseconds(300), scheduler: ConcurrentMainScheduler.instance)
//            .flatMapLatest { [activityIndicator] in Auth.auth().rx.signOut().trackActivity(activityIndicator) }
//            .subscribe(onNext: { coordinator.signOut() })
//            .disposed(by: disposeBag)
        
    }
    
}
