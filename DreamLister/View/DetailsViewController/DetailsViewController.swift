//
//  DetailsViewController.swift
//  DreamLister
//
//  Created by Julian Worden on 7/18/22.
//

import CoreData
import UIKit

class DetailsViewController: UIViewController {

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

    var stores = [Store]()
    var itemToEdit: Item? {
        didSet {
            loadExistingData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        layoutViews()

//        generateStores()
        getStores()

        if itemToEdit != nil {
            loadExistingData()
        }
    }

    func configureViews() {
        view.backgroundColor = .white
        title = "Add / Edit"
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteTapped))
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

    @objc func saveTapped() {
        var item: Item!
        let image = Image(context: Constants.context)
        image.image = itemImageView.image

        if itemToEdit != nil {
            item = itemToEdit
        } else {
            item = Item(context: Constants.context)
//            itemImageView.image = UIImage(named: "imagePick")
        }

        guard let title = itemNameTextField.text,
              let price = itemPriceTextField.text,
              let details = itemDetailsTextField.text,
              !title.isEmpty,
              !price.isEmpty else { return }

        item.name = title
        item.price = Double(price) ?? 0
        item.details = details
        item.image = image
        item.store = stores[storePicker.selectedRow(inComponent: 0)]

        Constants.appDelegate.saveContext()

        navigationController?.popViewController(animated: true)
    }

    @objc func deleteTapped() {
        if itemToEdit != nil {
            Constants.context.delete(itemToEdit!)
            Constants.appDelegate.saveContext()
        }

        navigationController?.popViewController(animated: true)
    }

    @objc func addImageTapped() {
        present(imagePicker, animated: true)
    }
}

// MARK: Retrieve Stores
extension DetailsViewController {
    func generateStores() {
        let store1 = Store(context: Constants.context)
        store1.name = "Best Buy"

        let store2 = Store(context: Constants.context)
        store2.name = "Apple"

        let store3 = Store(context: Constants.context)
        store3.name = "Tesla Motors"

        let store4 = Store(context: Constants.context)
        store4.name = "CVS"

        let store5 = Store(context: Constants.context)
        store5.name = "Amazon"

        let store6 = Store(context: Constants.context)
        store6.name = "Lids"

        Constants.appDelegate.saveContext()
    }

    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]

        do {
            self.stores = try Constants.context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            print(error.localizedDescription)
        }
    }

    // This function is only called when itemToEdit is set, so it won't be nil
    func loadExistingData() {
        itemNameTextField.text = itemToEdit!.name
        itemPriceTextField.text = String(itemToEdit!.price)
        itemDetailsTextField.text = itemToEdit!.details
        itemImageView.image = itemToEdit!.image?.image as? UIImage ?? UIImage(named: "imagePick")

        if let store = itemToEdit!.store,
           let indexPath = stores.firstIndex(of: store) {
            storePicker.selectRow(indexPath, inComponent: 0, animated: false)
        } else {
            storePicker.selectRow(0, inComponent: 0, animated: false)
        }
    }
}
