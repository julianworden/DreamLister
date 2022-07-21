//
//  DetailsViewController+UIPickerViewDelegate.swift
//  DreamLister
//
//  Created by Julian Worden on 7/19/22.
//

import Foundation
import UIKit

extension DetailsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.selectedStoreIndexPath = row
    }
}
