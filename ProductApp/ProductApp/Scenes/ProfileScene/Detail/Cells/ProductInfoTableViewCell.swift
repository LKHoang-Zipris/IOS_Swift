//
//  ProductInfoTableViewCell.swift
//  ProductApp
//
//  Created by Lê Kim Hoàng on 2/4/26.
//


import UIKit

final class ProductInfoTableViewCell: UITableViewCell {

    private var currentImageURL: String?

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 24
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray6.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 242/255, green: 240/255, blue: 248/255, alpha: 1)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.text = " Featured "
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white
        label.backgroundColor = .systemIndigo
        label.textAlignment = .center
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemRed.withAlphaComponent(0.10)
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .systemRed
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            productImageView,
            titleLabel,
            priceContainerView,
            descriptionTitleLabel,
            descriptionLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        setupUI()
        applyShadow()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        cardView.layer.shadowPath = UIBezierPath(
            roundedRect: cardView.bounds,
            cornerRadius: cardView.layer.cornerRadius
        ).cgPath
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        currentImageURL = nil
        productImageView.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        descriptionLabel.text = nil
    }
}

// MARK: - Setup UI
private extension ProductInfoTableViewCell {

    func setupUI() {
        contentView.addSubview(cardView)
        cardView.addSubview(contentStackView)
        productImageView.addSubview(badgeLabel)
        priceContainerView.addSubview(priceLabel)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            contentStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),

            productImageView.heightAnchor.constraint(equalToConstant: 300),

            badgeLabel.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 14),
            badgeLabel.leadingAnchor.constraint(equalTo: productImageView.leadingAnchor, constant: 14),
            badgeLabel.heightAnchor.constraint(equalToConstant: 32),

            priceLabel.topAnchor.constraint(equalTo: priceContainerView.topAnchor, constant: 12),
            priceLabel.leadingAnchor.constraint(equalTo: priceContainerView.leadingAnchor, constant: 14),
            priceLabel.trailingAnchor.constraint(equalTo: priceContainerView.trailingAnchor, constant: -14),
            priceLabel.bottomAnchor.constraint(equalTo: priceContainerView.bottomAnchor, constant: -12)
        ])

        contentStackView.setCustomSpacing(16, after: productImageView)
        contentStackView.setCustomSpacing(16, after: priceContainerView)
        contentStackView.setCustomSpacing(6, after: descriptionTitleLabel)
    }

    func applyShadow() {
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.10
        cardView.layer.shadowOffset = CGSize(width: 0, height: 10)
        cardView.layer.shadowRadius = 20
        cardView.layer.masksToBounds = false
    }
}

// MARK: - Configure
extension ProductInfoTableViewCell {

    func configure(with product: HomeProduct) {
        titleLabel.text = product.title
        priceLabel.text = product.price.formattedCurrency
        descriptionLabel.text = product.description
        badgeLabel.isHidden = (product.reviews ?? []).isEmpty

        guard let urlString = product.thumbnail else {
            productImageView.image = nil
            return
        }

        currentImageURL = urlString
        productImageView.loadImage(from: urlString)
    }
}