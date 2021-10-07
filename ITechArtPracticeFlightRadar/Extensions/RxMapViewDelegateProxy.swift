//
//  RxMapViewDelegateProxy.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/8/21.
//

import RxSwift
import RxCocoa
import MapKit

extension MKMapView: HasDelegate {
    public typealias Delegate = MKMapViewDelegate
}

open class RxMapViewDelegateProxy: DelegateProxy<MKMapView, MKMapViewDelegate>,
                                        DelegateProxyType,
                                        MKMapViewDelegate {
    
    internal let resultsSubject = PublishSubject<MKCoordinateRegion>()
    internal let pins = PublishSubject<MKAnnotationView>()
    
    /// Typed parent object.
    public weak private(set) var mapView: MKMapView?
    
    /// - parameter photoPickerViewController: Parent object for delegate proxy.
    public init(mapView: ParentObject) {
        self.mapView = mapView
        super.init(parentObject: mapView, delegateProxy: RxMapViewDelegateProxy.self)
    }
    
    // Register known implementations
    public static func registerKnownImplementations() {
        self.register { RxMapViewDelegateProxy(mapView: $0) }
    }
    
    public func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        resultsSubject.on(.next(mapView.region))
    }
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let id = "aircraft"
        var pin = mapView.dequeueReusableAnnotationView(withIdentifier: id)
        if pin == nil {
            pin = MKAnnotationView(annotation: annotation, reuseIdentifier: id)
            pin?.canShowCallout = true
        } else {
            pin?.annotation = annotation
        }
        pins.on(.next(pin!))
        return pin
    }
    
}
