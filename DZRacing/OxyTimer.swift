//
//  OxyTimer.swift
//  DZRacing
//
//  Created by алексей ганзицкий on 18.06.2022.
//

import Foundation
import UIKit

class OxyTimer {
    var oxygen = 100
    var timer = Timer()
    
    func oxygenTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            self.oxygen -= 1
        }
        timer.fire()

    }
    
    
}
