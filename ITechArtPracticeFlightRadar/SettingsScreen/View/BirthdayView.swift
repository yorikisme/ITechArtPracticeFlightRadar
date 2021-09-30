//
//  BirthdayView.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/29/21.
//

import UIKit
import RxSwift
import RxCocoa

class BirthdayView: UIView {
    
    // MARK: - Properties
    var viewModel: BirthdayViewViewModelProtocol!
    let disposeBag = DisposeBag()
    
    // MARK: - Outlets
    @IBOutlet weak var userBirthdayDatePicker: UIDatePicker!
    @IBOutlet weak var saveBirthdayButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with viewModel: BirthdayViewViewModelProtocol) {
        self.viewModel = viewModel
        userBirthdayDatePicker.maximumDate = Date()
        saveBirthdayButton.rx
            .tap
            .bind(to: viewModel.saveUserBirthdayAction)
            .disposed(by: disposeBag)
        
        userBirthdayDatePicker.rx
            .date
            .bind(to: viewModel.birthdayDate)
            .disposed(by: disposeBag)
    }
    
    static func createView() -> BirthdayView {
        let nibName = "BirthdayView"
        let bundle = Bundle(identifier: "BirthdayView")
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: nil, options: nil).first as! BirthdayView
    }
}
