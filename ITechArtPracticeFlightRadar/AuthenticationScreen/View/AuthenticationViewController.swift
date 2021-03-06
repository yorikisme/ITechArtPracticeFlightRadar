//
//  AuthenticationViewController.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 8/10/21.
//

import UIKit
import RxSwift
import RxCocoa
import GoogleSignIn
import Lottie
import Toast

class AuthenticationViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: AuthenticationViewModelProtocol!
    let disposeBag = DisposeBag()
    var processingView: ProcessingView!
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var invalidEmailFormatLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var insecurePasswordLabel: UILabel!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var dontHaveAnAccountLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var signInWithGoogle: GIDSignInButton!
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup localization
        emailTextField.placeholder = NSLocalizedString("email_", comment: "")
        invalidEmailFormatLabel.text = NSLocalizedString("invalid_email_format", comment: "")
        passwordTextField.placeholder = NSLocalizedString("password_", comment: "")
        insecurePasswordLabel.text = NSLocalizedString("invalid_password", comment: "")
        signInButton.setTitle(NSLocalizedString("sign_in", comment: ""), for: .normal)
        forgotPasswordButton.setTitle(NSLocalizedString("forgot_password", comment: ""), for: .normal)
        dontHaveAnAccountLabel.text = NSLocalizedString("don't_have_an_account", comment: "")
        signUpButton.setTitle(NSLocalizedString("sign_up", comment: ""), for: .normal)
        orLabel.text = NSLocalizedString("or_label_text", comment: "")
        
        viewModel
            .email
            .bind(to: emailTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .password
            .bind(to: passwordTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .isSignInEnabled
            .bind(to: signInButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel
            .isSignInEnabled
            .map { $0 ? .green : .gray }
            .bind(to: signInButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        emailTextField
            .rx
            .text
            .orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        passwordTextField
            .rx
            .text
            .orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        signInButton
            .rx
            .tap
            .bind(to: viewModel.signIn)
            .disposed(by: disposeBag)
        
        // Invalid email format check
        viewModel
            .isEmailFormatValid
            .bind(to: invalidEmailFormatLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        // Password security check
        viewModel
            .isPasswordSecure
            .bind(to: insecurePasswordLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        // Authentication with Google
        signInWithGoogle
            .rx
            .controlEvent(.touchUpInside)
            .bind(to: viewModel.googleAuthentication)
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
        
        // Forgot password
        forgotPasswordButton.rx
            .tap
            .bind(to: viewModel.forgotPassword)
            .disposed(by: disposeBag)
        
        // Sign up with a personal email
        signUpButton.rx
            .tap
            .bind(to: viewModel.signUp)
            .disposed(by: disposeBag)
    }
    
    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        signInWithGoogle.style = .wide
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
    
    deinit {
        print("AuthenticationViewController deinitialized")
    }

}
