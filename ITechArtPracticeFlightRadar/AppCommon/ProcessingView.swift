//
//  ProcessingView.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 8/30/21.
//

import UIKit
import Lottie

class ProcessingView: UIView {

    @IBOutlet weak var blurredBackground: UIVisualEffectView!
    @IBOutlet weak var spinner: AnimationView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        startProcessing()
        messageLabel.text = NSLocalizedString("please_fasten_your_seatbelts", comment: "")
    }
    
    static func createView() -> ProcessingView {
        let nibName = "ProcessingStateView"
        let bundle = Bundle(identifier: "ProcessingStateView")
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: nil, options: nil).first as! ProcessingView
    }
    
    func startProcessing() {
        spinner.animation = Animation.named("spinner")
        spinner.contentMode = .scaleAspectFill
        spinner.loopMode = .loop
        spinner.play()
    }
    
    func stopProcessing() {
        spinner.stop()
    }
    
    deinit {
        stopProcessing()
        print("Successfully deinitialized ")
    }
    
}
