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
    @IBOutlet weak var signInButton: UIButton!
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
        animationView.animation = Animation.named("mainMenuBackgroundAircraft")
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
    }
    
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        //viewModel.signInWith(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction func signInWithGoogleTapped(_ sender: GIDSignInButton) {
        //viewModel.signInWithGoogle()
    }
    
    deinit {
        print("AuthenticationViewController deinitialized")
    }

}
