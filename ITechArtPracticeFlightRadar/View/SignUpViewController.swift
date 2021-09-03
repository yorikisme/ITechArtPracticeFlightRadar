//
//  SignUpViewController.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/2/21.
//

import UIKit
import RxSwift
import RxCocoa
import Lottie

class SignUpViewController: UIViewController {
    
    // MARK: Properties
    var viewModel: SignUpViewModelProtocol!
    let disposeBag = DisposeBag()
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var invalidEmailFormatLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var invalidPasswordLabel: UILabel!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var invalidConfirmPasswordLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var backgroundAnimationView: AnimationView!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Sending text from emailTextField to viewModel's email
        emailTextField.rx
            .text
            .orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        /// Backward connection
        viewModel
            .email
            .bind(to: emailTextField.rx.text)
            .disposed(by: disposeBag)
        
        // 2. Sending password from passwordTextField to viewModel's password
        passwordTextField.rx
            .text
            .orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        /// Backward connection
        viewModel
            .password
            .bind(to: passwordTextField.rx.text)
            .disposed(by: disposeBag)
        
        // 3. Sending password confirmation from confirmTextField to viewModel's passwordConfirmation
        confirmPasswordTextField.rx
            .text
            .orEmpty
            .bind(to: viewModel.passwordConfirmation)
            .disposed(by: disposeBag)
        
        /// Backward connection
        viewModel
            .passwordConfirmation
            .bind(to: confirmPasswordTextField.rx.text)
            .disposed(by: disposeBag)
        
        // 4. Getting data from viewModel's isEmailValid then map it to determine
        // invalidEmailFormatLabel's isHidden property true or false
        viewModel
            .isEmailValid
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { $0 ? true : false }
            .bind(to: invalidEmailFormatLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        // 5. Getting data from viewModel's isPasswordValid then map it to determine
        // invalidPasswordLabel's isHidden property true or false
        viewModel
            .isPasswordValid
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { $0 ? true : false }
            .bind(to: invalidPasswordLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        // 6. Getting data from viewModel's passwordMatch then map it to determine
        // invalidConfirmPasswordLabel's isHidden property true or false
        viewModel
            .passwordMatch
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { $0 ? true : false }
            .bind(to: invalidConfirmPasswordLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        // 7. Getting data from viewModel's isSignUpEnabled to determine
        // signUpButton's isEnabled property true or false
        viewModel
            .isSignUpEnabled
            .bind(to: signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        /// Determination of the signUpButton's background color
        viewModel
            .isSignUpEnabled
            .map { $0 ? .green : .gray }
            .bind(to: signUpButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        // 8. SignUpButton got tapped
        signUpButton.rx
            .tap
            .bind(to: viewModel.signUp)
            .disposed(by: disposeBag)
        
        // 9. State determination
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
        
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startBackgroundAnimation()
    }
    
    // MARK: - Methods
    func startBackgroundAnimation() {
        backgroundAnimationView.contentMode = .scaleAspectFill
        backgroundAnimationView.loopMode = .loop
        backgroundAnimationView.play()
    }

}
