//
//  MainViewController+UITableViewDelegate.swift
//  DreamLister
//
//  Created by Julian Worden on 7/17/22.
//

import Foundation
import UIKit

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objects = controller.fetchedObjects,
               objects.count > 0 {
                   let item = objects[indexPath.row]
                   let detailsViewController = DetailsViewController()
                   detailsViewController.itemToEdit = item
                   navigationController?.pushViewController(detailsViewController, animated: true)
               }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
