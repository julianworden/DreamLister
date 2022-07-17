//
//  MainViewController+UITableViewDelegate.swift
//  DreamLister
//
//  Created by Julian Worden on 7/17/22.
//

import Foundation
import UIKit

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
