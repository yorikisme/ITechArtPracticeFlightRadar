//
//  ContainerViewController.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/14/21.
//

import UIKit
import RxSwift
import RxCocoa

class ContainerViewController: UIViewController {
    
    // MARK - Outlets
    @IBOutlet weak var sideMenuButton: UIButton!
    @IBOutlet weak var radarView: UIView!
    @IBOutlet weak var sideMenuView: UIView!
    @IBOutlet weak var radarViewWidth: NSLayoutConstraint!
    
    let disposeBag = DisposeBag()
    var viewModel: ContainerViewModelProtocol!
    var menuViewController: UIViewController!
    var contentViewController: UIViewController!
    lazy var blur = UIBlurEffect(style: .dark)
    lazy var blurEffectView = UIVisualEffectView(effect: blur)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        blurEffectView.frame = radarView.bounds
        setChildViewControllers()
        
        sideMenuButton.rx
            .tap
            .bind(to: viewModel.menuAction)
            .disposed(by: disposeBag)
        
        viewModel
            .isMenuOpen
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] in
                if $0 {
                    self?.openSideMenu()
                } else {
                    self?.closeSideMenu()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setChildViewControllers() {
        addChild(menuViewController)
        menuViewController.view.frame = sideMenuView.bounds
        sideMenuView.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: self)
        
        addChild(contentViewController)
        contentViewController.view.frame = radarView.bounds
        radarView.addSubview(contentViewController.view)
        contentViewController.didMove(toParent: self)
    }
    
    func openSideMenu() {
        radarView.addSubview(blurEffectView)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut) { [weak self] in
            self?.radarViewWidth.constant = 148
            self?.view.layoutIfNeeded()
        }
    }
    
    func closeSideMenu() {
        blurEffectView.removeFromSuperview()
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut) { [weak self] in
            self?.radarViewWidth.constant = 0
            self?.view.layoutIfNeeded()
        }
    }
}

// MARK: - Protocols
protocol ContainerViewModelProtocol {
    var isMenuOpen: BehaviorRelay<Bool> { get }
    var menuAction: PublishRelay<Void> { get }
}
