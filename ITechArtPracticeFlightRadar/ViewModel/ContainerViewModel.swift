//
//  ContainerViewModel.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/16/21.
//

import Foundation
import RxSwift
import RxCocoa



class ContainerViewModel: ContainerViewModelProtocol {
    
    let isMenuOpened = BehaviorRelay<Bool> (value: false)
    
    let disposeBag = DisposeBag()
    private let coordinator: ContainerCoordinatorProtocol
    
    // MARK: - Initializer
    init(coordinator: ContainerCoordinatorProtocol, menuAction: Observable<Void>) {
        self.coordinator = coordinator
        
        menuAction
            .withLatestFrom(isMenuOpened)
            .map{ !$0 }
            .bind(to: isMenuOpened)
            .disposed(by: disposeBag)
    }
    
}
