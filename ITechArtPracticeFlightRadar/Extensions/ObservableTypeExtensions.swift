//
//  ObservableTypeExtensions.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/1/21.
//

import RxSwift
import RxRelay

extension ObservableType {
    func stopProcessing(state: BehaviorRelay<State>) -> Observable<Self.Element> {
        return self.do(onNext: { _ in state.accept(.standby) }, onError: { state.accept(.failure($0)) })
    }
    
    func startProcessing(state: BehaviorRelay<State>) -> Observable<Self.Element> {
        return self.do(onNext: { _ in state.accept(.processing) })
    }
}
