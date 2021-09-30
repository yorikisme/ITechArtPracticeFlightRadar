//
//  BirthdayViewViewModel.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/30/21.
//

import Foundation
import RxSwift
import RxCocoa

protocol BirthdayViewViewModelProtocol {
    var birthdayDate: BehaviorRelay<Date> { get }
    var saveUserBirthdayAction: PublishRelay<Void> { get }
    var newBirthdayDate: PublishRelay<Date> { get }
}

class BirthdayViewViewModel: BirthdayViewViewModelProtocol {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    // MARK: - Protocol conformation
    let birthdayDate = BehaviorRelay<Date>(value: Date())
    let saveUserBirthdayAction = PublishRelay<Void>()
    let newBirthdayDate = PublishRelay<Date>()
    
    // MARK: - Initializer
    init() {
        saveUserBirthdayAction
            .withLatestFrom(birthdayDate)
            .bind(to: newBirthdayDate)
            .disposed(by: disposeBag)
            
    }
    
}
