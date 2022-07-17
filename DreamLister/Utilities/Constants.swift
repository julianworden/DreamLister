//
//  Constants.swift
//  DreamLister
//
//  Created by Julian Worden on 7/17/22.
//

import Foundation
import UIKit

// swiftlint:disable force_cast
enum Constants {
    static var shadowKey: Bool = false
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let context = appDelegate.persistentContainer.viewContext
    static let cellReuseIdentifier = "ItemCell"
}
