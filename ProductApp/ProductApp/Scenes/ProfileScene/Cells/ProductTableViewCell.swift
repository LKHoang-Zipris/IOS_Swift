import UIKit

final class ProductTableViewCell: UITableViewCell {

    private weak var parentViewController: UIViewController?
    private var reviews: [Review] = []
    private var nameProduct: String = "comment"
    private var currentImageURL: String?

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.secondarySystemBackground
        view.layer.cornerRadius = 22
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.systemGray5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 18
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.text = "Featured"
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .white
        label.backgroundColor = UIColor.systemIndigo
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemRed.withAlphaComponent(0.10)
        view.layer.cornerRadius = 14
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .systemRed
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let reviewsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Customer Reviews"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var reviewsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        collectionView.register(ReviewCollectionViewCell.self)
        return collectionView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            productImageView,
            titleLabel,
            priceContainerView,
            descriptionLabel,
            reviewsTitleLabel,
            reviewsCollectionView
        ])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        contentView.backgroundColor = .white
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
        parentViewController = nil
        currentImageURL = nil
        productImageView.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        descriptionLabel.text = nil
        reviews = []
        reviewsCollectionView.reloadData()
        reviewsTitleLabel.isHidden = false
        reviewsCollectionView.isHidden = false
        badgeLabel.isHidden = false
    }
}

// MARK: - Setup UI
private extension ProductTableViewCell {

    func setupUI() {
        contentView.addSubview(cardView)
        cardView.addSubview(contentStackView)
        productImageView.addSubview(badgeLabel)
        priceContainerView.addSubview(priceLabel)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            contentStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
            contentStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
            contentStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            contentStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -14),

            productImageView.heightAnchor.constraint(equalToConstant: 200),

            badgeLabel.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 12),
            badgeLabel.leadingAnchor.constraint(equalTo: productImageView.leadingAnchor, constant: 12),
            badgeLabel.heightAnchor.constraint(equalToConstant: 28),
            badgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 78),

            priceLabel.topAnchor.constraint(equalTo: priceContainerView.topAnchor, constant: 10),
            priceLabel.leadingAnchor.constraint(equalTo: priceContainerView.leadingAnchor, constant: 12),
            priceLabel.trailingAnchor.constraint(equalTo: priceContainerView.trailingAnchor, constant: -12),
            priceLabel.bottomAnchor.constraint(equalTo: priceContainerView.bottomAnchor, constant: -10),

            reviewsCollectionView.heightAnchor.constraint(equalToConstant: 120)
        ])

        contentStackView.setCustomSpacing(14, after: productImageView)
        contentStackView.setCustomSpacing(14, after: descriptionLabel)
    }

    func applyShadow() {
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowOffset = CGSize(width: 0, height: 8)
        cardView.layer.shadowRadius = 18
        cardView.layer.masksToBounds = false
    }
}

// MARK: - Configure
extension ProductTableViewCell {

    func configure(with product: HomeProduct, parentViewController: UIViewController) {
        self.parentViewController = parentViewController
        nameProduct = product.title
        titleLabel.text = nameProduct
        priceLabel.text = product.price.formattedCurrency
        descriptionLabel.text = product.description
        reviews = product.reviews ?? []
        reviewsCollectionView.reloadData()

        reviewsTitleLabel.isHidden = reviews.isEmpty
        reviewsCollectionView.isHidden = reviews.isEmpty
        badgeLabel.isHidden = product.reviews?.isEmpty ?? true

        guard let urlString = product.thumbnail else {
            productImageView.image = nil
            return
        }

        currentImageURL = urlString

        URLSession.shared.dataTask(with: URL(string: urlString)!) { [weak self] data, _, _ in
            guard let self,
                  let data,
                  let image = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                guard self.currentImageURL == urlString else { return }
                self.productImageView.image = image
            }
        }.resume()
    }
}

// MARK: - UICollectionViewDataSource
extension ProductTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        reviews.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ReviewCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(with: reviews[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProductTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 250, height: 116)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let review = reviews[indexPath.item]
        let viewController = CommentDetailViewController(review: review, nameProduct: nameProduct)
        let navigationController = UINavigationController(rootViewController: viewController)

        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
        }

        parentViewController?.present(navigationController, animated: true)
    }
}
