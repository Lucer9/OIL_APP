//
//  UIButton.swift
//  OIL_APP
//
//  Created by Miguel Gallardo on 3/19/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//

import UIKit

extension UIButton {
    func roundCorners(){
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
}
