//
//  ForgotPasswordViewController.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/1/21.
//

import UIKit
import RxSwift
import RxCocoa
import Lottie
import Toast

class ForgotPasswordViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: ForgotPasswordViewModelProtocol!
    let disposeBag = DisposeBag()
    var processingView: ProcessingView!
    
    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var invalidEmailFormatLabel: UILabel!
    @IBOutlet weak var sendRequestButton: UIButton!
    @IBOutlet weak var animationView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Localization
        textLabel.text = NSLocalizedString("forgot_password_text", comment: "")
        emailTextField.placeholder = NSLocalizedString("email_", comment: "")
        invalidEmailFormatLabel.text = NSLocalizedString("invalid_email_format", comment: "")
        sendRequestButton.setTitle(NSLocalizedString("send_", comment: ""), for: .normal)
        
        emailTextField.rx
            .text
            .orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        sendRequestButton.rx
            .tap
            .bind(to: viewModel.sendResetRequest)
            .disposed(by: disposeBag)
        
        // Setting up the invalidEmailFormatLabel's isHidden property true or false
        viewModel
            .isEmailFormatValid
            .bind(to: invalidEmailFormatLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        // Setting up the sendRequestButton color
        viewModel
            .isSendResetRequestEnabled
            .map { $0 ? .green : .gray }
            .bind(to: sendRequestButton.rx.backgroundColor)
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
        
        // Go back
        backButton.rx
            .tap
            .bind(to: viewModel.goBackAction)
            .disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backButton.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
        setupAnimation()
    }
    
    // MARK: - Methods
    private func setupAnimation() {
        // Background animation
        animationView.animation = Animation.named("authenticationScreenBackgroundAircraft")
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.play()
    }
    
    func showActivityIndicator() {
        processingView = ProcessingView.createView()
        view.addSubview(processingView)
    }
    
    func removeActivityIndicator() {
        guard let processingView = processingView else { return }
        processingView.removeFromSuperview()
    }

}
