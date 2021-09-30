//
//  SettingsViewController.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/27/21.
//

import UIKit
import RxSwift
import RxCocoa

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: SettingsViewModelProtocol!
    let disposeBag = DisposeBag()
    let dateFormatter = DateFormatter()
    var birthdayView: BirthdayView!
    
    // MARK: - Outlets
    @IBOutlet weak var userPhotoImageView: UIImageView!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var changeUserNameButton: UIButton!
    @IBOutlet weak var changeUserNameView: UIView!
    @IBOutlet weak var newUserNameTextField: UITextField!
    @IBOutlet weak var saveNewUserNameButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var changeEmailButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var changeBirthdayButton: UIButton!
    @IBOutlet weak var birthdayPickerView: UIView!
    @IBOutlet weak var userBirthdayLabel: UILabel!
    
    // MARK: - Lifecycle points
    override func viewDidLoad() {
        super.viewDidLoad()
        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.size.height / 2
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        // MARK: - User name
        /// Setup text property of userNameLabel
        viewModel
            .userName
            .bind(to: userNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        /// Tap changeUserName button
        changeUserNameButton.rx
            .tap
            .bind(to: viewModel.changeUserNameAction)
            .disposed(by: disposeBag)
        
        /// Setup isHidden property of changeUserNameView
        viewModel
            .isChangeUserNameInProgress
            .map { !$0 }
            .bind(to: changeUserNameView.rx.isHidden)
            .disposed(by: disposeBag)
        
        /// Setup text property of newUserNameTextField
        viewModel
            .userName
            .bind(to: newUserNameTextField.rx.text)
            .disposed(by: disposeBag)
        
        /// Sending new user name
        newUserNameTextField.rx
            .text
            .orEmpty
            .bind(to: viewModel.newUserName)
            .disposed(by: disposeBag)
        
        /// Setup isEnabled property of saveNewUserNameButton
        viewModel
            .isSaveNewUserNameActionAvailable
            .bind(to: saveNewUserNameButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        /// Tap saveNewUserNameButton
        saveNewUserNameButton.rx
            .tap
            .bind(to: viewModel.saveNewUserNameAction)
            .disposed(by: disposeBag)
        
        /// Setup title of changeUserEmailButton
        viewModel
            .isChangeUserNameInProgress
            .map { $0 == true ? "Cancel" : "Change" }
            .subscribe(
                onNext: { [changeUserNameButton] in changeUserNameButton?.setTitle($0, for: .normal) })
            .disposed(by: disposeBag)
        
        /// Tap changeEmailButton
        changeEmailButton.rx
            .tap
            .bind(to: viewModel.changeEmail)
            .disposed(by: disposeBag)
        
        // MARK: - Birthday
        /// Tap changeBirthdayButton
        changeBirthdayButton.rx
            .tap
            .bind(to: viewModel.changeBirthdayAction)
            .disposed(by: disposeBag)
        
        /// Show/hide birthdayPickerView
        viewModel
            .isChangeBirthdayInProgress
            .map { !$0 }
            .subscribe(onNext: { [birthdayView, birthdayPickerView] in
                if $0 {
                    birthdayPickerView?.isHidden = $0
                    birthdayView?.removeFromSuperview()
                } else {
                    if let birthdayView = birthdayView {
                        birthdayPickerView?.isHidden = $0
                        birthdayPickerView?.addSubview(birthdayView)
                    }
                }
            }).disposed(by: disposeBag)
        
        /// Setup text property of userBirthdayLabel
        viewModel
            .newBirthdayDate
            .map { [dateFormatter] in dateFormatter.string(from: $0) }
            .bind(to: userBirthdayLabel.rx.text)
            .disposed(by: disposeBag)
        
        // MARK: - Back button
        /// Tap back button
        backButton.rx
            .tap
            .bind(to: viewModel.goBackAction)
            .disposed(by: disposeBag)
        
        /// Setup title of changeBirthdayButton
        viewModel
            .isChangeBirthdayInProgress
            .map { $0 == true ? "Cancel" : "Change" }
            .subscribe(
                onNext: { [changeBirthdayButton] in changeBirthdayButton?.setTitle($0, for: .normal) })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backButton.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
    
}
