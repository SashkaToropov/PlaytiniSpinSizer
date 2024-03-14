//
//  UIDevice+Extensions.swift
//  PlaytiniSpinSizer
//
//  Created by  Toropov Oleksandr on 14.03.2024.
//

import UIKit
import AudioToolbox

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
