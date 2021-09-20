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
    
    let isMenuOpen = BehaviorRelay<Bool> (value: false)
    let menuAction = PublishRelay<Void>()
    
    let disposeBag = DisposeBag()
    private let coordinator: ContainerCoordinatorProtocol
    
    // MARK: - Initializer
    init(coordinator: ContainerCoordinatorProtocol) {
        self.coordinator = coordinator
        
        menuAction
            .withLatestFrom(isMenuOpen)
            .map{ !$0 }
            .bind(to: isMenuOpen)
            .disposed(by: disposeBag)
    }
    
}
