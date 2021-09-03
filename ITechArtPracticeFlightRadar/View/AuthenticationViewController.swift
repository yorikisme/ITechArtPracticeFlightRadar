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
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var invalidEmailFormatLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var insecurePasswordLabel: UILabel!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var signInWithGoogle: GIDSignInButton!
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        var processingView: ProcessingView?
        
        viewModel
            .state
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .standby:
                    if let processingView = processingView {
                        processingView.removeFromSuperview()
                    }
                case .processing:
                    processingView = ProcessingView.createView()
                    self?.view.addSubview(processingView!)
                case .failure(let error):
                    if let processingView = processingView {
                        processingView.removeFromSuperview()
                        self?.view.makeToast(error.localizedDescription)
                    }
                }
            })
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
    
    deinit {
        print("AuthenticationViewController deinitialized")
    }

}
