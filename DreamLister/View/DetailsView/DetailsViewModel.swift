//
//  DetailsViewModel.swift
//  DreamLister
//
//  Created by Julian Worden on 7/20/22.
//

import CoreData
import Foundation

class DetailsViewModel {
    var itemToEdit: Item?

    @Published var selectedStoreIndexPath: Int?
    @Published var stores = [Store]()
    @Published var itemName: String?
    @Published var itemPrice: String?
    @Published var itemDetails: String?
    @Published var itemStore: Store?

    init(itemToEdit: Item?) {
//        generateStores()
        getStores()

        if let itemToEdit = itemToEdit {
            self.itemToEdit = itemToEdit
            loadExistingData()

            if let selectedStoreIndexPath = stores.firstIndex(of: itemToEdit.store!) {
                 self.selectedStoreIndexPath = selectedStoreIndexPath
            }
        }
    }

    func saveItem() {
        var item: Item!
//        let image = Image(context: Constants.context)
//        image.image = itemImageView.image

        if itemToEdit != nil {
            item = itemToEdit
        } else {
            item = Item(context: Constants.context)
            //            itemImageView.image = UIImage(named: "imagePick")
        }

        guard let name = itemName,
              let price = itemPrice,
              let details = itemDetails,
              !name.isEmpty,
              !price.isEmpty else { return }

        item.name = name
        item.price = Double(price) ?? 0.0
        item.details = details
//        item.image = image
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

    // This function is only called when itemToEdit is set, so it won't be nil
    func loadExistingData() {
        itemName = itemToEdit!.name
        itemPrice = String(itemToEdit!.price)
        itemDetails = itemToEdit!.details
//        itemImageView.image = itemToEdit!.image?.image as? UIImage ?? UIImage(named: "imagePick")

        if let store = itemToEdit!.store,
           let indexPath = stores.firstIndex(of: store) {
            selectedStoreIndexPath = indexPath
        } else {
            selectedStoreIndexPath = 0
        }
    }
}
