//
//  ListOfFlightsCoordinator.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 8/11/21.
//

import UIKit

class ListOfFlightsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .green
        navigationController.pushViewController(viewController, animated: true)
    }
}
