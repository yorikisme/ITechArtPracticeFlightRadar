//
//  ChangePasswordView.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 10/4/21.
//

import UIKit
import RxSwift
import RxCocoa

class ChangePasswordView: UIView {
    
    // MARK: - Properties
    var disposeBag: DisposeBag?
    var viewModel: ChangePasswordViewModelProtocol? { didSet { configure() } }
    
    // MARK: - Outlets
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var insecurePasswordLabel: UILabel!
    @IBOutlet weak var confirmNewPassword: UITextField!
    @IBOutlet weak var passwordsDoNotMatchLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    // MARK: - Methods
    func configure() {
        guard let viewModel = self.viewModel else {
            disposeBag = nil
            return
        }
        disposeBag = DisposeBag()
        
        // Localization
        
        currentPasswordTextField.placeholder = NSLocalizedString("current_password", comment: "")
        newPasswordTextField.placeholder = NSLocalizedString("new_password", comment: "")
        insecurePasswordLabel.text = NSLocalizedString("invalid_password", comment: "")
        confirmNewPassword.placeholder = NSLocalizedString("confirm_password", comment: "")
        passwordsDoNotMatchLabel.text = NSLocalizedString("passwords_do_not_match", comment: "")
        saveButton.setTitle(NSLocalizedString("save_", comment: ""), for: .normal)
        cancelButton.setTitle(NSLocalizedString("cancel_", comment: ""), for: .normal)
        
        // MARK: - currentPasswordTextField
        currentPasswordTextField.rx
            .text
            .orEmpty
            .debug()
            .bind(to: viewModel.currentPassword)
            .disposed(by: disposeBag!)
        
        /// call back
        viewModel
            .currentPassword
            .bind(to: currentPasswordTextField.rx.text.orEmpty)
            .disposed(by: disposeBag!)
        
        // MARK: - newPasswordTextField
        newPasswordTextField.rx
            .text
            .orEmpty
            .debug()
            .bind(to: viewModel.newPassword)
            .disposed(by: disposeBag!)
        
        /// call back
        viewModel
            .newPassword
            .bind(to: newPasswordTextField.rx.text.orEmpty)
            .disposed(by: disposeBag!)
        
        // MARK: - confirmNewPasswordTextField
        confirmNewPassword.rx
            .text
            .orEmpty
            .debug()
            .bind(to: viewModel.newPasswordConfirmation)
            .disposed(by: disposeBag!)
        
        /// call back
        viewModel
            .newPasswordConfirmation
            .bind(to: confirmNewPassword.rx.text.orEmpty)
            .disposed(by: disposeBag!)
        
        // MARK: - insecurePasswordLabel
        viewModel
            .isPasswordSecure
            .bind(to: insecurePasswordLabel.rx.isHidden)
            .disposed(by: disposeBag!)
        
        // MARK: - passwordsDoNotMatchLabel
        viewModel
            .passwordsMatch
            .bind(to: passwordsDoNotMatchLabel.rx.isHidden)
            .disposed(by: disposeBag!)
        
        // MARK: - saveButton
        viewModel
            .isSaveActionAvailable
            .bind(to: saveButton.rx.isEnabled)
            .disposed(by: disposeBag!)
        
        viewModel
            .isSaveActionAvailable
            .subscribe(onNext: { [saveButton] in
                if $0 {
                    saveButton?.backgroundColor = .systemGreen
                } else {
                    saveButton?.backgroundColor = .systemGray
                }
            })
            .disposed(by: disposeBag!)
        
        saveButton.rx
            .tap
            .bind(to: viewModel.saveAction)
            .disposed(by: disposeBag!)
        
        // MARK: - cancelButton
        cancelButton.rx
            .tap
            .bind(to: viewModel.cancelAction)
            .disposed(by: disposeBag!)
    }
    
    static func createView() -> ChangePasswordView {
        let nibName = "ChangePasswordView"
        let bundle = Bundle(identifier: "ChangePasswordView")
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: nil, options: nil).first as! ChangePasswordView
    }
}
