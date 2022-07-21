//
//  DetailsViewController+UIImagePickerControllerDelegate.swift
//  DreamLister
//
//  Created by Julian Worden on 7/19/22.
//

import Foundation
import UIKit

extension DetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            viewModel.itemImage = image
        }

        picker.dismiss(animated: true)
    }
}
