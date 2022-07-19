//
//  ViewController.swift
//  DreamLister
//
//  Created by Julian Worden on 7/17/22.
//

import CoreData
import UIKit

class MainViewController: UIViewController {
    let items = [Item]()

    let segmentedControl = UISegmentedControl()
    let tableView = UITableView()

    var controller: NSFetchedResultsController<Item>!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        layoutViews()
//        generateDummyData()
        attemptFetch()
    }

    func configureViews() {
        view.backgroundColor = .white
        title = "Dream Lister"
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                 target: self,
                                                 action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem

        segmentedControl.insertSegment(withTitle: "Newest", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Price", at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: "Name", at: 2, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: Constants.cellReuseIdentifier)
        tableView.separatorStyle = .none
    }

    func layoutViews() {
        view.addSubview(segmentedControl)
        view.addSubview(tableView)

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    @objc func segmentedControlChanged() {
        attemptFetch()
        tableView.reloadData()
    }

    @objc func addButtonTapped() {
        navigationController?.pushViewController(DetailsViewController(), animated: true)
    }
}

extension MainViewController: NSFetchedResultsControllerDelegate {
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

        switch segmentedControl.selectedSegmentIndex {
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

    // swiftlint:disable force_cast
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemTableViewCell
                configureCell(cell, indexPath: indexPath)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        @unknown default:
            break
        }
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
