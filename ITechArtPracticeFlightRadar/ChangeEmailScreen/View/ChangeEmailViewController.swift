//
//  ChangeEmailViewController.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/27/21.
//

import UIKit
import RxSwift
import RxCocoa

class ChangeEmailViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: ChangeEmailViewModelProtocol!
    let disposeBag = DisposeBag()
    var processingView: ProcessingView!
    
    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var newEmailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: Lifecycle points
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backButton.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
        
        // Email
        newEmailTextField.rx
            .text
            .orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        // Password
        passwordTextField.rx
            .text
            .orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        // saveButton isEnabled
        viewModel
            .isSaveActionAvailable
            .bind(to: saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // Save new email
        saveButton.rx
            .tap
            .bind(to: viewModel.saveAction)
            .disposed(by: disposeBag)
        
        // Back to settings
        backButton.rx
            .tap
            .bind(to: viewModel.goBackAction)
            .disposed(by: disposeBag)
        
        // State determination
        viewModel
            .isLoading
            .subscribe(onNext: { [weak self] in
                if $0 {
                    self?.showActivityIndicator()
                } else {
                    self?.removeActivityIndicator()
                }
            })
            .disposed(by: disposeBag)
        
        // Occurred error message
        viewModel
            .errorMessage
            .subscribe(onNext: { [weak self] message in self?.view.makeToast(message) })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Methods
    func showActivityIndicator() {
        processingView = ProcessingView.createView()
        view.addSubview(processingView)
    }
    
    func removeActivityIndicator() {
        guard let processingView = processingView else { return }
        processingView.removeFromSuperview()
    }

}
