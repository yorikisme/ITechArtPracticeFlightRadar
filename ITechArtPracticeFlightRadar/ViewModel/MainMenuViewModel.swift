//
//  MainMenuViewModel.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 8/10/21.
//

import Foundation

protocol MainMenuViewModelProtocol {
    func signIn()
    func signUp()
}

class MainMenuViewModel: MainMenuViewModelProtocol {
    
    var coordinator: MainMenuCoordinator!
    
    func signIn() {
        coordinator.startSignInProcedure()
    }
    
    func signUp() {
    }
}
