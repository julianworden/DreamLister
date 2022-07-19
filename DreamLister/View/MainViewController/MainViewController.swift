//
//  ViewController.swift
//  DreamLister
//
//  Created by Julian Worden on 7/17/22.
//

import Combine
import CoreData
import UIKit

// swiftlint:disable force_cast

class MainViewController: UIViewController {
    let viewModel = MainViewModel()
    var subscribers = Set<AnyCancellable>()

    let segmentedControl = UISegmentedControl()
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        layoutViews()
        configureSubscribers()
//        viewModel.generateDummyData()
        viewModel.attemptFetch()
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
        viewModel.selectedSegmentIndex = segmentedControl.selectedSegmentIndex

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

    func configureSubscribers() {
        subscribers = [
            viewModel.$updatedIndexPath
                .sink(receiveValue: { indexPath in
                    if let indexPath = indexPath {
                        switch self.viewModel.controllerChangeType {
                        case .insert:
                            self.tableView.insertRows(at: [indexPath], with: .fade)
                            self.tableView.reloadData()
                        case .delete:
                            self.tableView.deleteRows(at: [indexPath], with: .fade)
                            self.tableView.reloadData()
                        case .update:
                            let cell = self.tableView.cellForRow(at: indexPath) as! ItemTableViewCell
                            self.configureCell(cell, indexPath: indexPath)
                            self.tableView.reloadData()
                        case .move:
                            self.tableView.insertRows(at: [indexPath], with: .fade)
                            self.tableView.reloadData()
                        default:
                            self.tableView.reloadData()
                        }
                    }
                }),
            viewModel.$tableViewDidBeginUpdates
                .sink(receiveValue: { _ in
                    self.tableView.beginUpdates()
                }),
            viewModel.$tableViewDidEndUpdates
                .sink(receiveValue: { _ in
                    self.tableView.endUpdates()
                })
        ]
    }

    @objc func segmentedControlChanged() {
        viewModel.attemptFetch()
        tableView.reloadData()
    }

    @objc func addButtonTapped() {
        navigationController?.pushViewController(DetailsViewController(), animated: true)
    }
}
