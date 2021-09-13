//
//  SettingsViewModel.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/10/21.
//

import Foundation

protocol SettingsViewModelProtocol {
}

class SettingsViewModel: SettingsViewModelProtocol {
    
    var coordinator: SettingsCoordinatorProtocol!
    
    init(coordinator: SettingsCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
}
