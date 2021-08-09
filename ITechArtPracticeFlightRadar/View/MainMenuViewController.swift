//
//  MainMenuViewController.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 8/9/21.
//

import UIKit
import Lottie

class MainMenuViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var animationView: AnimationView!
    
    // MARK: - Lifecycle load points
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonsUp()
        setAnimationUp()
    }
    
    // MARK: - Methods
    private func setAnimationUp() {
        animationView.animation = Animation.named("mainMenuBackgroundAircraft")
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
    }
    
    private func setButtonsUp() {
        signInButton.layer.cornerRadius = 20
        signUpButton.layer.cornerRadius = 20
    }
}
