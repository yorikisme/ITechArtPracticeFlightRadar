//
//  SignInViewController.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 8/10/21.
//

import UIKit
import Lottie

class SignInViewController: UIViewController {
    
    var coordinator: SignInCoordinator!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var animationView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSignInButton()
        setupAnimation()
        
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
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
