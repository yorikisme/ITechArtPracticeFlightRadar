//
//  RadarDashboardViewModel.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/7/21.
//

import Foundation
import RxSwift
import RxRelay
import FirebaseAuth

protocol RadarDashboardViewModelProtocol {
    var signOut: PublishRelay<Void> { get }
    var setUp: PublishRelay<Void> { get }
}

class RadarDashboardViewModel: RadarDashboardViewModelProtocol {
    
    // MARK: - Properties
    var coordinator: RadarDashboardCoordinatorProtocol!
    let disposeBag = DisposeBag()
    
    // Protocol conformation
    let signOut = PublishRelay<Void>()
    let setUp = PublishRelay<Void>()
    
    // MARK: - Initializer
    init(coordinator: RadarDashboardCoordinatorProtocol) {
        self.coordinator = coordinator
        
        // Sign out
        signOut
            .flatMapLatest { Auth.auth().rx.signOut() }
            .subscribe(onNext: { coordinator.signOut() },
                       onError: { print($0.localizedDescription) })
            .disposed(by: disposeBag)
        
        // Settings
        setUp
            .subscribe { _ in
                coordinator.showAlertWith(title: "Oops😅", message: "To be implemented yet", navigationController: (coordinator as! RadarDashboardCoordinator).navigationController)
            }
            .disposed(by: disposeBag)

    }
    
}
