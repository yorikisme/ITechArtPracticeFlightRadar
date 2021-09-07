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

class RadarDashboardViewController: UIViewController {
    
    var viewModel: RadarDashboardViewModelProtocol!
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var map: MKMapView!
    
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let coordinates = CLLocationCoordinate2DMake(53.9036, 27.5593)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        map.setRegion(region, animated: true)
    }

}
