//
//  SettingsViewModel.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/27/21.
//

import Foundation

protocol SettingsViewModelProtocol {
}

class SettingsViewModel: SettingsViewModelProtocol {
    
    // MARK: - Properties
    let coordinator: SettingsCoordinatorProtocol!
    
    init(coordinator: SettingsCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
}
