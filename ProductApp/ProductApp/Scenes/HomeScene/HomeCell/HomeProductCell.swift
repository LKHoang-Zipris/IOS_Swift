//
//  HomeProductCell.swift
//  ProductApp
//
//  Created by Lê Kim Hoàng on 30/3/26.
//


import UIKit

final class HomeProductCell: UICollectionViewCell {
        
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let brandLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .systemRed
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let discountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .semibold)
        label.textColor = .white
        label.backgroundColor = .systemOrange
        label.textAlignment = .center
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var currentImageURL: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        currentImageURL = nil
        productImageView.image = nil
        titleLabel.text = nil
        brandLabel.text = nil
        priceLabel.text = nil
        discountLabel.text = nil
        ratingLabel.text = nil
        discountLabel.isHidden = false
    }
    
    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 14
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.clipsToBounds = true
        
        contentView.addSubview(productImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(brandLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(discountLabel)
        contentView.addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            productImageView.heightAnchor.constraint(equalToConstant: 120),
            
            titleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            brandLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            brandLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            brandLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            priceLabel.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 6),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            discountLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            discountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            discountLabel.heightAnchor.constraint(equalToConstant: 22),
            discountLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 52),
            
            ratingLabel.centerYAnchor.constraint(equalTo: discountLabel.centerYAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            discountLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with product: HomeProduct) {
        titleLabel.text = product.title
        brandLabel.text = product.brand ?? product.category ?? "Unknown"
        priceLabel.text = Self.formattedPrice(product.price)
        
        if let discount = product.discountPercentage {
            discountLabel.text = String(format: "-%.0f%%", discount)
            discountLabel.isHidden = false
        } else {
            discountLabel.isHidden = true
        }
        
        if let rating = product.rating {
            ratingLabel.text = String(format: "⭐️ %.1f", rating)
        } else {
            ratingLabel.text = "⭐️ --"
        }
        
        guard let urlString = product.thumbnail else {
            productImageView.image = nil
            return
        }
        
        currentImageURL = urlString
        
        ImageLoader.shared.loadImage(from: urlString) { [weak self] image in
            guard let self else { return }
            guard self.currentImageURL == urlString else { return }
            self.productImageView.image = image
        }
    }
    
    private static func formattedPrice(_ price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let text = formatter.string(from: NSNumber(value: price)) ?? "\(price)"
        return "$\(text)"
    }
}
