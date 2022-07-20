//
//  ItemTableViewCellViewModel.swift
//  DreamLister
//
//  Created by Julian Worden on 7/20/22.
//

import Foundation

class ItemTableViewCellViewModel {
    let itemName: String
    let itemPrice: Double
    let itemDetails: String
    let itemImage: Image

    init(item: Item) {
        self.itemName = item.name ?? ""
        self.itemPrice = item.price
        self.itemDetails = item.details ?? ""
        self.itemImage = item.image ?? Image()
    }
}
