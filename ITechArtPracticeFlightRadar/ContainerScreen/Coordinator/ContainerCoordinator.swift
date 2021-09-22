//
//  ContainerCoordinator.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/14/21.
//

import UIKit
import RxSwift
import RxCocoa

protocol ContainerCoordinatorProtocol: Coordinator, AnyObject {
    func goToSettings()
    func signOut()
}

class ContainerCoordinator: ContainerCoordinatorProtocol {
    let navigationController: UINavigationController
    let service: NetworkManagerProtocol
    
    init(navigationController: UINavigationController, service: NetworkManagerProtocol) {
        self.navigationController = navigationController
        self.service = service
    }
    
    func start() {
        let containerViewController = ContainerViewController()
        let containerViewModel = ContainerViewModel(coordinator: self)
        
        let sideMenuViewModel = SideMenuViewModel(coordinator: self, service: service)
        let radarDashboardViewModel = RadarDashboardViewModel(coordinator: self, service: service)
        
        let sideMenuViewController = SideMenuViewController()
        let radarDashboardViewController = RadarDashboardViewController()
        
        sideMenuViewController.viewModel = sideMenuViewModel
        radarDashboardViewController.viewModel = radarDashboardViewModel
        containerViewController.viewModel = containerViewModel
        
        containerViewController.sideMenuViewController = sideMenuViewController
        containerViewController.contentViewController = radarDashboardViewController
        
        navigationController.pushViewController(containerViewController, animated: true)
    }
}

extension ContainerCoordinator: RadarDashboardCoordinatorProtocol {
    
}

extension ContainerCoordinator: SideMenuCoordinatorProtocol {
    func goToSettings() {
        print("Settings")
    }
    
    func signOut() {
        navigationController.popToRootViewController(animated: true)
    }
}
