//
//  ItemTableViewCellViewModel.swift
//  DreamLister
//
//  Created by Julian Worden on 7/20/22.
//

import Foundation
import UIKit.UIImage

class ItemTableViewCellViewModel {
    let itemName: String
    let itemPrice: Double
    let itemDetails: String
    let itemImage: UIImage

    // swiftlint:disable force_cast
    init(item: Item) {
        self.itemName = item.name ?? ""
        self.itemPrice = item.price
        self.itemDetails = item.details ?? ""
        self.itemImage = item.image?.image as! UIImage
    }
}
