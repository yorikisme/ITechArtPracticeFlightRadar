//
//  RadarDashboardViewModel.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/7/21.
//

import Foundation

protocol RadarDashboardViewModelProtocol {
}

class RadarDashboardViewModel: RadarDashboardViewModelProtocol {
    
    var coordinator: RadarDashboardCoordinatorProtocol!
    
    init(coordinator: RadarDashboardCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
}
