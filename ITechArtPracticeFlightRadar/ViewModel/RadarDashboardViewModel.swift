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

protocol RadarDashboardCoordinatorProtocol {
    
}

class RadarDashboardViewModel: RadarDashboardViewModelProtocol {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    // Protocol conformation
    let openCloseSideMenu = PublishRelay<Void>()
    let sideMenuState = BehaviorRelay<SideMenuState>(value: .closed)
    let coordinates = PublishRelay<CoordinateRectangle>()
    let aircrafts = PublishRelay<[Aircraft]>()
    //let isActive = BehaviorRelay<Bool>()
    let openMenuAction: PublishRelay<Void>
    
    private let coordinator: RadarDashboardCoordinatorProtocol
    private let service: NetworkManagerProtocol
    
    
    // MARK: - Initializer
    init(coordinator: RadarDashboardCoordinatorProtocol, service: NetworkManagerProtocol, menuAction: PublishRelay<Void>) {
        self.service = service
        self.coordinator = coordinator
        self.openMenuAction = menuAction
        // Getting aircrafts in the coordinate box
//        coordinates
//            .flatMapLatest { coordinator.service.networkService.requestFlights(within: $0) }
//            .subscribe(onNext: { [aircrafts] in aircrafts.accept($0) })
//            .disposed(by: disposeBag)

        Observable.combineLatest(
        Observable<Int>.interval(.seconds(5), scheduler: ConcurrentMainScheduler.instance), coordinates)
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .flatMap { service.requestFlights(within: $0.1) }
            .subscribe(onNext: { [aircrafts] in aircrafts.accept($0) })
            .disposed(by: disposeBag)
    }
    
}
