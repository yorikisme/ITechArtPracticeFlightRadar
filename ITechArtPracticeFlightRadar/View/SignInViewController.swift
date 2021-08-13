//
//  SignInViewController.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 8/10/21.
//

import UIKit
import Lottie
import GoogleSignIn

class SignInViewController: UIViewController {
    
    var viewModel: SignInProtocol!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var signInWithGoogle: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSignInButton()
        setupAnimation()
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        viewModel.signInWith(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction func signInWithGoogleTapped(_ sender: GIDSignInButton) {
        viewModel.signInWithGoogle()
    }
    
    private func setupSignInButton() {
        signInButton.layer.cornerRadius = 20
    }
    
    private func setupAnimation() {
        animationView.animation = Animation.named("mainMenuBackgroundAircraft")
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
    }
    
    deinit {
        print("SignInViewController deinited")
    }

}
