//
//  ProductCell.swift
//  ProductApp
//
//  Created by Lê Kim Hoàng on 23/3/26.
//

import UIKit

class ProductCell: UITableViewCell {

    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with product: Product) {
        nameLabel.text = product.name
        priceLabel.text = "\(Int(product.price)) VNĐ"
        descriptionLabel.text = product.description
        productImageView.loadImage(from: product.image)
    }
}
