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
    @IBOutlet weak var emailNotVerifiedLabel: UILabel!
    @IBOutlet weak var sideMenuViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var radarViewWidthConstraint: NSLayoutConstraint!
    
    let disposeBag = DisposeBag()
    var viewModel: ContainerViewModelProtocol!
    var sideMenuViewController: UIViewController!
    var contentViewController: UIViewController!
    var blurEffectView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        setChildViewControllers()
        
        sideMenuButton.rx
            .tap
            .bind(to: viewModel.menuAction)
            .disposed(by: disposeBag)
        
        viewModel
            .isMenuOpen
            .distinctUntilChanged()
            .skip(1)
            .subscribe(onNext: { [weak self] in
                if $0 {
                    self?.openSideMenu()
                } else {
                    self?.closeSideMenu()
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Email verification
        viewModel
            .isEmailVerified
            .bind(to: emailNotVerifiedLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    func setChildViewControllers() {
        sideMenuViewWidthConstraint.constant = 0
        radarViewWidthConstraint.constant = 428
        
        addChild(sideMenuViewController)
        sideMenuView.addSubview(sideMenuViewController.view)
        addConstraintsTo(child: sideMenuViewController.view, parent: sideMenuView)
        sideMenuViewController.didMove(toParent: self)
        
        addChild(contentViewController)
        radarView.addSubview(contentViewController.view)
        addConstraintsTo(child: contentViewController.view, parent: radarView)
        contentViewController.didMove(toParent: self)
    }
    
    func openSideMenu() {
        addBlurEffectView()
        sideMenuButton.isEnabled = false
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseIn) { [weak self] in
                self?.sideMenuViewWidthConstraint.constant = 200
                self?.blurEffectView.alpha = 1
                self?.view.layoutIfNeeded()
        } completion: { [weak self] _ in
            self?.sideMenuButton.isEnabled = true
        }
    }
    
    func closeSideMenu() {
        sideMenuButton.isEnabled = false
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn) { [weak self] in
                self?.sideMenuViewWidthConstraint.constant = 0
                self?.blurEffectView.alpha = 0
                self?.view.layoutIfNeeded()
        } completion: { [weak self] _ in
            self?.removeBlurEffectView()
            self?.sideMenuButton.isEnabled = true
        }
    }
    
    func addBlurEffectView() {
        let effect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: effect)
        blurEffectView.frame = radarView.bounds
        blurEffectView.alpha = 0
        radarView.addSubview(blurEffectView)
    }
    
    func removeBlurEffectView() {
        blurEffectView.removeFromSuperview()
    }
    
    func addConstraintsTo(child: UIView, parent: UIView) {
        child.layer.masksToBounds = true
        child.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = child.leadingAnchor.constraint(equalTo: parent.leadingAnchor)
        let trailing = child.trailingAnchor.constraint(equalTo: parent.trailingAnchor)
        let top = child.topAnchor.constraint(equalTo: parent.topAnchor)
        let bottom = child.bottomAnchor.constraint(equalTo: parent.bottomAnchor)

        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
}

// MARK: - Protocols
protocol ContainerViewModelProtocol {
    var isMenuOpen: BehaviorRelay<Bool> { get }
    var menuAction: PublishRelay<Void> { get }
    var isEmailVerified: BehaviorRelay<Bool> { get }
}
