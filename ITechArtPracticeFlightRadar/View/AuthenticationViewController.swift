//
//  AuthenticationViewController.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 8/10/21.
//

import UIKit
import Lottie
import GoogleSignIn
import Toast

class AuthenticationViewController: UIViewController, UITextFieldDelegate {
    
    var viewModel: AuthenticationViewModelProtocol!
    var timer: Timer?
        
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var signInWithGoogle: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        signInWithGoogle.style = .wide
        setupAnimation()
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        viewModel.signInWith(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction func signInWithGoogleTapped(_ sender: GIDSignInButton) {
        viewModel.signInWithGoogle()
    }
    
    @IBAction func emailChanged(_ sender: UITextField) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5,
                                     repeats: false,
                                     block: { [weak self] timer in
                                        let emailIsValid = self?.viewModel.validateEmail(candidate: sender.text!)
                                        if emailIsValid! {
                                            self?.signInButton.isEnabled = true
                                            self?.signInButton.backgroundColor = .green
                                        } else {
                                            self?.signInButton.isEnabled = false
                                            self?.signInButton.backgroundColor = .gray
                                            self?.view.makeToast("Invalid email format", duration: 1.5)
                                        }
                                     })
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
