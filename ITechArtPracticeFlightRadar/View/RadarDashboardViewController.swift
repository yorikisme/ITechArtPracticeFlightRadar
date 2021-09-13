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

class RadarDashboardViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Properties
    var viewModel: RadarDashboardViewModelProtocol!
    let disposeBag = DisposeBag()
    
    // MARK: - Outlets
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        // Sign out
        signOutButton.rx
            .tap
            .bind(to: viewModel.signOut)
            .disposed(by: disposeBag)
        
        // Settings
        settingsButton.rx
            .tap
            .bind(to: viewModel.setUp)
            .disposed(by: disposeBag)
        
        // Getting the coordinates of the visible box region on the map
        mapView.rx
            .didViewDidChangeVisibleRegion
            .map { CoordinateRectangle(region: $0) }
            .bind(to: viewModel.coordinates)
            .disposed(by: disposeBag)
        
        // Adding pins on the map
        viewModel.aircrafts
            .map { [weak self] in
                $0.forEach({self?.addAircraftPinWith(transponder: $0.transponderIdentifier, flightNumber: $0.callsign ?? "No callsign", lat: CLLocationDegrees($0.latitude ?? 0), lon: CLLocationDegrees($0.longitude ?? 0), course: $0.course ?? 0)})
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        // Change standard pins to aircraft symbols and set their course
        mapView.rx.viewForAnnotation
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
    
    func addAircraftPinWith(transponder: String, flightNumber: String, lat: CLLocationDegrees, lon: CLLocationDegrees, course: Float) {
        let pin = MKPointAnnotation()
        let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        pin.coordinate = coordinates
        pin.title = transponder
        pin.subtitle = flightNumber
        mapView.addAnnotation(pin)
    }

}
