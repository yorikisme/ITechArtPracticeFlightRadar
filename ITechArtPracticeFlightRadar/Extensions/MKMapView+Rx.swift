//
//  MKMapView+Rx.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/8/21.
//

import RxSwift
import RxCocoa
import MapKit

extension Reactive where Base: MKMapView {
    
    /// Reactive wrapper for `delegate`.
    /// For more information take a look at `DelegateProxyType` protocol documentation.
    public var delegate: DelegateProxy<MKMapView, MKMapViewDelegate> {
        return RxMapViewDelegateProxy.proxy(for: base)
    }
    
    /// Installs delegate as forwarding delegate on `delegate`.
    /// Delegate won't be retained.
    ///
    /// It enables using normal delegate mechanism with reactive delegate mechanism.
    ///
    /// - parameter delegate: Delegate object.
    /// - returns: Disposable object that can be used to unbind the delegate.
    public func setDelegate(_ delegate: MKMapViewDelegate) -> Disposable {
        return RxMapViewDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: self.base)
    }
    
    public var didViewDidChangeVisibleRegion: Observable<MKCoordinateRegion> {
        let proxy = RxMapViewDelegateProxy.proxy(for: base)
        return proxy.resultsSubject.asObservable()
    }
    
    public var viewForAnnotation: Observable<MKAnnotationView> {
        let proxy = RxMapViewDelegateProxy.proxy(for: base)
        return proxy.pins.asObservable()
    }
}
