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
    let disposeBag = DisposeBag()
    
    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var changeEmailButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    // MARK: - Lifecycle points
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tap changeEmail button
        changeEmailButton.rx
            .tap
            .bind(to: viewModel.changeEmail)
            .disposed(by: disposeBag)
        
        // Tap back button
        backButton.rx
            .tap
            .bind(to: viewModel.goBackAction)
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backButton.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
    
}
