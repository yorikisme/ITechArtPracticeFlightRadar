//
//  RadarDashboardViewModel.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/7/21.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase
import Alamofire

protocol RadarDashboardViewModelProtocol {
    var signOut: PublishRelay<Void> { get }
    var setUp: PublishRelay<Void> { get }
    var coordinates: PublishRelay<CoordinateRectangle> { get }
    var aircrafts: PublishRelay<[Aircraft]> { get }
}

class RadarDashboardViewModel: RadarDashboardViewModelProtocol {
    
    // MARK: - Properties
    var coordinator: RadarDashboardCoordinatorProtocol!
    let disposeBag = DisposeBag()
    
    // Protocol conformation
    let signOut = PublishRelay<Void>()
    let setUp = PublishRelay<Void>()
    let coordinates = PublishRelay<CoordinateRectangle>()
    let aircrafts = PublishRelay<[Aircraft]>()
    
    // MARK: - Initializer
    init(coordinator: RadarDashboardCoordinatorProtocol, service: ServiceProtocol) {
        
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
                coordinator.showAlertWith(title: "😅", message: "To be continued...", navigationController: (coordinator as! RadarDashboardCoordinator).navigationController)
            }
            .disposed(by: disposeBag)

        // Getting aircrafts in the coordinate box
        coordinates
            .flatMapLatest { service.networkService.requestFlights(within: $0) }
            .subscribe(onNext: { [aircrafts] in aircrafts.accept($0) })
            .disposed(by: disposeBag)

        
        Observable<Int>.interval(.seconds(5), scheduler: ConcurrentMainScheduler.instance).withLatestFrom(coordinates)
            .flatMap { service.networkService.requestFlights(within: $0) }
            .subscribe(onNext: { [aircrafts] in aircrafts.accept($0) })
            .disposed(by: disposeBag)
            
    }
    
}
