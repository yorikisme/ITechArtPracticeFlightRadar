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
    
    let disposeBag = DisposeBag()
    var viewModel: ContainerViewModelProtocol!
    var menuViewController: UIViewController!
    var contentViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setChildViewControllers()
        
        viewModel
            .isMenuOpened
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
        menuViewController.view.frame = view.frame
        view.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: self)
        
        addChild(contentViewController)
        contentViewController.view.frame = view.frame
        view.addSubview(contentViewController.view)
        contentViewController.didMove(toParent: self)
    }
    
    func openSideMenu() {
        guard contentViewController.view.frame.origin.x == 0 else { return }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut) { [weak self] in
            self?.contentViewController.view.frame.origin.x = (self?.contentViewController.view.frame.size.width)! - 150
        }
    }
    
    func closeSideMenu() {
        guard contentViewController.view.frame.origin.x == contentViewController.view.frame.size.width - 150.0 else { return }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut) { [weak self] in
            self?.contentViewController.view.frame.origin.x = 0
        }
    }

}


protocol ContainerViewModelProtocol {
    var isMenuOpened: BehaviorRelay<Bool> { get }
}
