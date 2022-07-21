//
//  MainViewModel.swift
//  DreamLister
//
//  Created by Julian Worden on 7/19/22.
//

import CoreData
import Foundation

class MainViewModel: NSObject, NSFetchedResultsControllerDelegate {
    var controller: NSFetchedResultsController<Item>!
    var selectedSegmentIndex: Int?
    var controllerChangeType: NSFetchedResultsChangeType?

    @Published var updatedIndexPath: IndexPath?
    @Published var tableViewDidBeginUpdates = false
    @Published var tableViewDidEndUpdates = false

    func generateDummyData() {
        let item1 = Item(context: Constants.context)
        item1.name = "MacBook Pro"
        item1.price = 3000
        item1.details = "I'd really like a new MacBook with a keyboard that doesn't break all the time..."

        let item2 = Item(context: Constants.context)
        item2.name = "Bose N700 Headphones"
        item2.price = 349
        item2.details = "They are pricey, but being able to block out other people is worth it."

        let item3 = Item(context: Constants.context)
        item3.name = "Tesla Model Y"
        item3.price = 62000
        item3.details = "This is like buying the future."

        Constants.appDelegate.saveContext()
    }

    func attemptFetch() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "createdDate", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let nameSort = NSSortDescriptor(key: "name", ascending: true)

        switch selectedSegmentIndex {
        case 0:
            fetchRequest.sortDescriptors = [dateSort]
        case 1:
            fetchRequest.sortDescriptors = [priceSort]
        case 2:
            fetchRequest.sortDescriptors = [nameSort]
        default:
            break
        }

        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: Constants.context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)

        controller.delegate = self
        self.controller = controller

        do {
            try controller.performFetch()
        } catch let error {
            print(error)
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                self.controllerChangeType = .insert
                self.updatedIndexPath = indexPath
            }
        case .delete:
            if let indexPath = indexPath {
                self.controllerChangeType = .delete
                self.updatedIndexPath = indexPath
            }
        case .update:
            if let indexPath = indexPath {
                self.controllerChangeType = .update
                self.updatedIndexPath = indexPath
            }
        case .move:
            if let indexPath = newIndexPath {
                self.controllerChangeType = .move
                self.updatedIndexPath = indexPath
            }
        @unknown default:
            break
        }
    }
}
