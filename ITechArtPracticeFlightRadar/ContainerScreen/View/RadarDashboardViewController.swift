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
    var openCloseSideMenu: PublishRelay<Void> { get }
    var sideMenuState: BehaviorRelay<SideMenuState> { get }
    var coordinates: PublishRelay<CoordinateRectangle> { get }
    var aircrafts: PublishRelay<[Aircraft]> { get }
    var openMenuAction: PublishRelay<Void> { get }
}

class RadarDashboardViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Properties
    var viewModel: RadarDashboardViewModelProtocol!
    let disposeBag = DisposeBag()
    
    // MARK: - Outlets
    @IBOutlet weak var sideMenuButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        // Side menu button
        sideMenuButton.rx
            .tap
            .bind(to: viewModel.openMenuAction)
            .disposed(by: disposeBag)
        
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
                    pin.image = UIImage(systemName: "airplane")?.rotatedBy(degree: CGFloat(aircraft.course ?? 0))
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
        } else {
            let pin = MKPointAnnotation()
            let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(aircraft.latitude ?? 0), longitude: CLLocationDegrees(aircraft.longitude ?? 0))
            pin.coordinate = coordinates
            pin.title = aircraft.transponderIdentifier
            pin.subtitle = aircraft.callsign
            mapView.addAnnotation(pin)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pin = annotation as! MKPointAnnotation
        pin.coordinate = CLLocationCoordinate2D(latitude: 54, longitude: 27)
        return MKAnnotationView(annotation: annotation, reuseIdentifier: "5")
    }
}
