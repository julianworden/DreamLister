//
//  DetailsViewModel.swift
//  DreamLister
//
//  Created by Julian Worden on 7/20/22.
//

import CoreData
import Foundation
import UIKit.UIImage

class DetailsViewModel {
    var itemToEdit: Item?

    @Published var selectedStoreIndexPath: Int?
    @Published var stores = [Store]()
    @Published var itemName: String?
    @Published var itemPrice: String?
    @Published var itemDetails: String?
    @Published var itemStore: Store?
    @Published var itemImage: UIImage?

    init(itemToEdit: Item?) {
//        generateStores()
        self.itemToEdit = itemToEdit

        getStores()
        attemptToLoadExistingData()
    }

    func saveItem() {
        var item: Item!
        let image = Image(context: Constants.context)
        image.image = itemImage

        if itemToEdit != nil {
            item = itemToEdit
        } else {
            item = Item(context: Constants.context)
            itemImage = UIImage(named: "imagePick")
        }

        guard let name = itemName,
              let price = itemPrice,
              let details = itemDetails,
              !name.isEmpty,
              !price.isEmpty else { return }

        item.name = name
        item.price = Double(price) ?? 0.0
        item.details = details
        item.image = image
        item.store = stores[selectedStoreIndexPath ?? 0]
        Constants.appDelegate.saveContext()
    }

    func deleteItem() {
        if itemToEdit != nil {
            Constants.context.delete(itemToEdit!)
            Constants.appDelegate.saveContext()
        }
    }

    func generateStores() {
        let store1 = Store(context: Constants.context)
        store1.name = "Best Buy"

        let store2 = Store(context: Constants.context)
        store2.name = "Apple"

        let store3 = Store(context: Constants.context)
        store3.name = "Tesla Motors"

        let store4 = Store(context: Constants.context)
        store4.name = "CVS"

        let store5 = Store(context: Constants.context)
        store5.name = "Amazon"

        let store6 = Store(context: Constants.context)
        store6.name = "Lids"

        Constants.appDelegate.saveContext()
    }

    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]

        do {
            self.stores = try Constants.context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }

    func attemptToLoadExistingData() {
        guard let itemToEdit = itemToEdit else {
            itemImage = UIImage(named: "imagePick")
            return
        }

        self.itemToEdit = itemToEdit
        itemName = itemToEdit.name
        itemPrice = String(itemToEdit.price)
        itemDetails = itemToEdit.details
        itemImage = itemToEdit.image?.image as? UIImage ?? UIImage(named: "imagePick")

        if let store = itemToEdit.store,
           let indexPath = stores.firstIndex(of: store) {
            selectedStoreIndexPath = indexPath
        } else {
            selectedStoreIndexPath = 0
        }
    }
}
