//
//  ItemTableViewCell.swift
//  DreamLister
//
//  Created by Julian Worden on 7/17/22.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    let itemContentView = UIView()
    let itemImageView = UIImageView()
    lazy var itemLabelStack = UIStackView(arrangedSubviews: [itemNameLabel, itemPriceLabel, itemDetailsLabel])
    let itemNameLabel = UILabel()
    let itemPriceLabel = UILabel()
    let itemDetailsLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        layoutViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureViews(withItem item: Item) {
        contentView.backgroundColor = .clear

        itemContentView.backgroundColor = .white
        itemContentView.shadowDesign = true

        itemImageView.image = UIImage(named: "tesla")
        itemImageView.contentMode = .scaleAspectFit
        itemImageView.clipsToBounds = true

        itemNameLabel.text = item.name
        itemNameLabel.font = UIFont(name: "Helvetica Neue Medium", size: 20)

        itemPriceLabel.text = "$\(item.price)"
        itemPriceLabel.font = UIFont(name: "Helvetica Neue Regular", size: 18)

        itemDetailsLabel.text = item.details
        itemDetailsLabel.textColor = .lightGray
        itemDetailsLabel.font = UIFont(name: "Helvetica Neue Regular", size: 15)
        itemDetailsLabel.numberOfLines = 3

        itemLabelStack.axis = .vertical
        itemLabelStack.distribution = .fill
        itemLabelStack.spacing = 8
    }

    func layoutViews() {
        contentView.addSubview(itemContentView)
        itemContentView.addSubview(itemImageView)
        itemContentView.addSubview(itemLabelStack)

        itemContentView.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemLabelStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            itemContentView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            itemContentView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            itemContentView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            itemContentView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),

            itemImageView.centerYAnchor.constraint(equalTo: itemContentView.centerYAnchor),
            itemImageView.leadingAnchor.constraint(equalTo: itemContentView.leadingAnchor, constant: 8),
            itemImageView.heightAnchor.constraint(equalToConstant: 100),
            itemImageView.widthAnchor.constraint(equalToConstant: 100),

            itemLabelStack.topAnchor.constraint(equalTo: itemContentView.topAnchor, constant: 8),
            itemLabelStack.bottomAnchor.constraint(equalTo: itemContentView.bottomAnchor, constant: -8),
            itemLabelStack.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 8),
            itemLabelStack.trailingAnchor.constraint(equalTo: itemContentView.trailingAnchor)
        ])
    }
}
