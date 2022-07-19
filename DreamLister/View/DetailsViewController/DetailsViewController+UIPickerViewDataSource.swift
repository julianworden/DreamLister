//
//  DetailsViewController+UIPickerViewDataSource.swift
//  DreamLister
//
//  Created by Julian Worden on 7/19/22.
//

import Foundation
import UIKit

extension DetailsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store.name
    }
}
