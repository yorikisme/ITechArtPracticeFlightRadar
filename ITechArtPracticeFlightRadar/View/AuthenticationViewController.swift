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
    
    var viewModel: AuthenticationViewModelProtocol!
    let disposeBag = DisposeBag()
        
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var signInWithGoogle: GIDSignInButton!
    
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
        
        emailTextField
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        passwordTextField
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        viewModel
            .isSignInEnabled
            .map { $0 ? .green : .gray }
            .bind(to: signInButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        signInButton
            .rx
            .tap
            .bind(to: viewModel.signIn)
            .disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        signInWithGoogle.style = .wide
        setupAnimation()
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        //viewModel.signInWith(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction func signInWithGoogleTapped(_ sender: GIDSignInButton) {
        //viewModel.signInWithGoogle()
    }
    
    private func setupAnimation() {
        animationView.animation = Animation.named("mainMenuBackgroundAircraft")
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
    }
    
    deinit {
        print("AuthenticationViewController deinitialized")
    }

}
