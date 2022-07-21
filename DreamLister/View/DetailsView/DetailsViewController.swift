//
//  DetailsViewController.swift
//  DreamLister
//
//  Created by Julian Worden on 7/18/22.
//

import Combine
import CoreData
import UIKit

class DetailsViewController: UIViewController {
    var viewModel: DetailsViewModel! {
        didSet {
            configureViews()
            layoutViews()
            configureSubscribers()
        }
    }
    var subscribers = Set<AnyCancellable>()

    var imagePicker: UIImagePickerController!
    let itemImageView = UIImageView()
    let itemImageButton = UIButton()
    lazy var itemNameAndDetailsStack = UIStackView(arrangedSubviews: [itemNameTextField, itemPriceTextField])
    let itemNameTextField = CustomTextField()
    let itemPriceTextField = CustomTextField()
    let itemDetailsTextField = CustomTextField()
    lazy var bottomSectionStack = UIStackView(arrangedSubviews: [selectStoreLabel, storePicker, saveItemButton])
    let selectStoreLabel = UILabel()
    let storePicker = UIPickerView()
    let saveItemButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func configureViews() {
        view.backgroundColor = .white
        title = "Add / Edit"
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash,
                                                 target: self,
                                                 action: #selector(deleteTapped))
        rightBarButtonItem.tintColor = .red
        navigationItem.rightBarButtonItem = rightBarButtonItem

        imagePicker = UIImagePickerController()
        imagePicker.delegate = self

        itemImageView.contentMode = .scaleAspectFit

        itemImageButton.addTarget(self, action: #selector(addImageTapped), for: .touchUpInside)

        itemNameAndDetailsStack.distribution = .fillEqually
        itemNameAndDetailsStack.axis = .vertical
        itemNameAndDetailsStack.alignment = .leading
        itemNameAndDetailsStack.spacing = 8

        itemNameTextField.placeholder = "Name"
        itemNameTextField.borderStyle = .roundedRect

        itemPriceTextField.placeholder = "Price"
        itemPriceTextField.borderStyle = .roundedRect

        itemDetailsTextField.placeholder = "Details"
        itemDetailsTextField.borderStyle = .roundedRect

        bottomSectionStack.axis = .vertical
        bottomSectionStack.distribution = .fill
        bottomSectionStack.spacing = 0

        selectStoreLabel.text = "Select Store"
        selectStoreLabel.textAlignment = .center

        storePicker.delegate = self
        storePicker.dataSource = self

        saveItemButton.setTitle("Save Item", for: .normal)
        saveItemButton.setTitleColor(.white, for: .normal)
        saveItemButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 21)
        saveItemButton.backgroundColor = .darkGray
        saveItemButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }

    func configureSubscribers() {
        subscribers = [
            viewModel.$itemName
                .assign(to: \.text, on: itemNameTextField),
            viewModel.$itemPrice
                .assign(to: \.text, on: itemPriceTextField),
            viewModel.$itemDetails
                .assign(to: \.text, on: itemDetailsTextField),
            viewModel.$itemImage
                .assign(to: \.image, on: itemImageView),
            viewModel.$selectedStoreIndexPath
                .sink(receiveValue: { indexPath in
                    if let indexPath = indexPath {
                        self.storePicker.selectRow(indexPath, inComponent: 0, animated: true)
                    }
                }),
            viewModel.$stores
                .sink(receiveValue: { _ in
                    self.storePicker.reloadAllComponents()
                })
        ]
    }

    @objc func saveTapped() {
        viewModel.itemName = itemNameTextField.text
        viewModel.itemPrice = itemPriceTextField.text
        viewModel.itemDetails = itemDetailsTextField.text
        viewModel.saveItem()
        navigationController?.popViewController(animated: true)
    }

    @objc func deleteTapped() {
        viewModel.deleteItem()
        navigationController?.popViewController(animated: true)
    }

    @objc func addImageTapped() {
        present(imagePicker, animated: true)
    }
}

// MARK: - Constraints

extension DetailsViewController {
    func layoutViews() {
        view.addSubview(itemImageView)
        view.addSubview(itemImageButton)
        view.addSubview(itemNameAndDetailsStack)
        view.addSubview(itemDetailsTextField)
        view.addSubview(bottomSectionStack)

        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemImageButton.translatesAutoresizingMaskIntoConstraints = false
        itemNameAndDetailsStack.translatesAutoresizingMaskIntoConstraints = false
        itemNameTextField.translatesAutoresizingMaskIntoConstraints = false
        itemDetailsTextField.translatesAutoresizingMaskIntoConstraints = false
        bottomSectionStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            itemImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            itemImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            itemImageView.widthAnchor.constraint(equalToConstant: 100),
            itemImageView.heightAnchor.constraint(equalToConstant: 100),

            itemImageButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            itemImageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            itemImageButton.widthAnchor.constraint(equalToConstant: 100),
            itemImageButton.heightAnchor.constraint(equalToConstant: 100),

            itemNameAndDetailsStack.topAnchor.constraint(equalTo: itemImageView.topAnchor),
            itemNameAndDetailsStack.bottomAnchor.constraint(equalTo: itemImageView.bottomAnchor),
            itemNameAndDetailsStack.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 8),
            itemNameAndDetailsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            itemNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            itemPriceTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            itemDetailsTextField.topAnchor.constraint(equalTo: itemNameAndDetailsStack.bottomAnchor, constant: 8),
            itemDetailsTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            itemDetailsTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            itemDetailsTextField.heightAnchor.constraint(equalToConstant: 60),

            bottomSectionStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSectionStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSectionStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
