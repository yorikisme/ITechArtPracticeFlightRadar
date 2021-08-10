//
//  Coordinator.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 8/10/21.
//

import UIKit

protocol CoordinatorProtocol {
    static func setUpMainMenuViewController() -> UIViewController
}

struct Coordinator: CoordinatorProtocol {
    static func setUpMainMenuViewController() -> UIViewController {
        let view = MainMenuViewController()
        let viewModel = MainMenuViewModel()
        view.viewModel = viewModel
        return view
    }
}
