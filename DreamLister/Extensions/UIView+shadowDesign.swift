//
//  UIView+shadowDesign.swift
//  DreamLister
//
//  Created by Julian Worden on 7/17/22.
//

import Foundation
import UIKit

extension UIView {
    var shadowDesign: Bool {
        get {
            return Constants.shadowKey
        }

        set {
            Constants.shadowKey = newValue

            if Constants.shadowKey {
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 3
                self.layer.shadowOpacity = 0.8
                self.layer.shadowRadius = 3
                self.layer.shadowOffset = CGSize(width: 0.0, height: 2)
                self.layer.shadowColor = UIColor.gray.cgColor
            } else {
                self.layer.cornerRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowColor = nil
            }
        }
    }
}
