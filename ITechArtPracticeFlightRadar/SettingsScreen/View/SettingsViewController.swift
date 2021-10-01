//
//  SettingsViewController.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/27/21.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase

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
        userPhotoImageView.image = UIImage(named: "JenniferLawrence")
        //dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
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
            .subscribe(onNext: { [changeUserNameView] isHidden in
                    UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseIn) {
                        changeUserNameView?.isHidden = isHidden
                    } completion: { _ in
                        print("done")
                    }
            }).disposed(by: disposeBag)
        
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
            .subscribe(onNext: { [weak self] in
                if $0 {
                    self?.hide(view: self?.birthdayPickerView, subview: self?.birthdayView)
                } else {
                    self?.show(view: self?.birthdayPickerView, subview: self?.birthdayView)
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
        userEmailLabel.text = Auth.auth().currentUser?.email
    }
    
    // MARK: - Methods
    func show(view: UIView?, subview: UIView?) {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseIn)
        {
            if let subview = subview {
                view?.isHidden = false
                view?.addSubview(subview)
            }
        } completion: { _ in
            print("Done")
        }
    }
    
    func hide(view: UIView?, subview: UIView?) {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseIn)
        {
            view?.isHidden = true
            subview?.removeFromSuperview()
        } completion: { _ in
            print("Done")
        }
    }
    
}
