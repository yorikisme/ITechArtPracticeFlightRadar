//
//  RadarDashboardViewController.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/6/21.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit

protocol RadarDashboardViewModelProtocol {
    var coordinates: PublishRelay<CoordinateRectangle> { get }
    var aircrafts: PublishRelay<[Aircraft]> { get }
}

class RadarDashboardViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Properties
    var viewModel: RadarDashboardViewModelProtocol!
    let disposeBag = DisposeBag()
    
    // MARK: - Outlets
    //@IBOutlet weak var sideMenuButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        // Getting the coordinates of the visible box region on the map
        mapView.rx
            .didViewDidChangeVisibleRegion
            .map { CoordinateRectangle(region: $0) }
            .bind(to: viewModel.coordinates)
            .disposed(by: disposeBag)
        
        // Adding pins on the map
        viewModel
            .aircrafts
            .subscribe(onNext: {
                [weak self] in
                $0.forEach({ self?.addAircraftPinWith(aircraft: $0) })
            })
            .disposed(by: disposeBag)
        
        // Change standard pins to aircraft symbols and set their course
        mapView.rx
            .viewForAnnotation
            .withLatestFrom(viewModel.aircrafts, resultSelector: { return ($0, $1) })
            .subscribe { pin, aircrafts in
                if let aircraft = aircrafts.first(where: { aircraft in
                    aircraft.transponderIdentifier == pin.annotation?.title
                }) {
                    let image = UIImage(systemName: "airplane")?.imageRotatedByDegrees(degrees: -90, flip: false)
                    pin.image = image?.imageRotatedByDegrees(degrees: CGFloat(aircraft.course ?? 0), flip: false)
                }
            }
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Setting up the initial visible region
        let coordinates = CLLocationCoordinate2DMake(53.9036, 27.5593)
        let span = MKCoordinateSpan(latitudeDelta: 8, longitudeDelta: 8)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func addAircraftPinWith(aircraft: Aircraft) {
        if let pin = mapView.annotations.first(where: { $0.title == aircraft.transponderIdentifier }) {
            (pin as! MKPointAnnotation).coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(aircraft.latitude ?? 0), longitude: CLLocationDegrees(aircraft.longitude ?? 0))
            let annotationView = mapView.view(for: pin)
            let image = UIImage(systemName: "airplane")?.imageRotatedByDegrees(degrees: -90, flip: false)
            annotationView?.image = image?.imageRotatedByDegrees(degrees: CGFloat(aircraft.course ?? 0), flip: false)
        } else {
            let pin = MKPointAnnotation()
            let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(aircraft.latitude ?? 0), longitude: CLLocationDegrees(aircraft.longitude ?? 0))
            pin.coordinate = coordinates
            pin.title = aircraft.transponderIdentifier
            pin.subtitle = aircraft.callsign
            mapView.addAnnotation(pin)
        }
    }
    
}
