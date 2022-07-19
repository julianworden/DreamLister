//
//  MainViewController+UITableViewDataSource.swift
//  DreamLister
//
//  Created by Julian Worden on 7/17/22.
//

import Foundation
import UIKit

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = viewModel.controller.sections {
            return sections.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = viewModel.controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseIdentifier, for: indexPath) as? ItemTableViewCell {
            configureCell(cell, indexPath: indexPath)
            return cell
        } else {
            return UITableViewCell()
        }
    }

    func configureCell(_ cell: ItemTableViewCell, indexPath: IndexPath) {
        cell.selectionStyle = .none

        let item = viewModel.controller.object(at: indexPath)
        cell.configureViews(withItem: item)
    }
}
