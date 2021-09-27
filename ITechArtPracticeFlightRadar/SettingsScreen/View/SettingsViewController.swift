//
//  SettingsViewController.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/27/21.
//

import UIKit
import RxSwift
import RxCocoa

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: SettingsViewModelProtocol!
    
    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var changeEmailButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    // MARK: - Lifecycle points
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backButton.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
    
}
