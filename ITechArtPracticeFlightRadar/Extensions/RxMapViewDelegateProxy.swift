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

extension UIImage {
    func rotatedBy(degree: CGFloat) -> UIImage? {
        guard let cgImage = cgImage else { return nil }
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        defer { UIGraphicsEndImageContext() }
        UIColor.white.setFill()
        context.fill(.init(origin: .zero, size: size))
        context.translateBy(x: size.width/2, y: size.height/2)
        context.scaleBy(x: 1, y: -1)
        context.rotate(by: -degree * .pi / 180)
        context.draw(cgImage, in: CGRect(origin: .init(x: -size.width/2, y: -size.height/2), size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
