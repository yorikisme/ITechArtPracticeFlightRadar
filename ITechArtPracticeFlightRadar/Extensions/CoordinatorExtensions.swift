//
//  CoordinatorExtensions.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/7/21.
//

import UIKit

extension Coordinator {
    
    func showAlertWith(title: String, message: String, navigationController: UINavigationController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(action)
        navigationController.topViewController?.present(alert, animated: true, completion: nil)
    }
    
}
