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
    @IBOutlet weak var map: MKMapView!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        map.rx
            .didViewDidChangeVisibleRegion
            .map {
                CoordinateRectangle(region: $0)
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Setting up the initial visible region
        let coordinates = CLLocationCoordinate2DMake(53.9036, 27.5593)
        let span = MKCoordinateSpan(latitudeDelta: 5.5, longitudeDelta: 5.5)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        map.setRegion(region, animated: true)
    }

}
