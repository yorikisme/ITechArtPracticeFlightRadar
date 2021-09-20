//
//  SideMenuViewController.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/14/21.
//

import UIKit
import RxSwift
import RxCocoa

protocol SideMenuViewModelProtocol {
    var settings: PublishRelay<Void> { get }
    var signOut: PublishRelay<Void> { get }
}

class SideMenuViewController: UIViewController {
    
    @IBOutlet weak var settingsButton: UIButton!
    
    var viewModel: SideMenuViewModelProtocol!
    let disposeBag = DisposeBag()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsButton.rx
            .tap
            .bind(to: viewModel.settings)
            .disposed(by: disposeBag)
    }
}
