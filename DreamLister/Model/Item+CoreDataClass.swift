//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Julian Worden on 7/17/22.
//
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.createdDate = Date()
    }
}
