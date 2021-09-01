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

class ForgotPasswordViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: ForgotPasswordViewModelProtocol!
    let disposeBag = DisposeBag()
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var invalidEmailFormatLabel: UILabel!
    @IBOutlet weak var sendRequestButton: UIButton!
    @IBOutlet weak var animationView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
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

}
