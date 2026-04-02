import UIKit

final class ReviewCollectionViewCell: UICollectionViewCell {

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 18
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let avatarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.12)
        view.layer.cornerRadius = 18
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let avatarLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()

    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()

    private lazy var userInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            nameLabel,
            emailLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let starRatingView = StarRatingView()

    private let ratingValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .systemOrange
        return label
    }()

    private lazy var ratingContainerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            starRatingView,
            ratingValueLabel
        ])
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 3
        return label
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            userInfoStackView,
            ratingContainerStackView,
            commentLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupUI()
        applyShadow()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.shadowPath = UIBezierPath(
            roundedRect: containerView.bounds,
            cornerRadius: containerView.layer.cornerRadius
        ).cgPath
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        avatarLabel.text = nil
        nameLabel.text = nil
        emailLabel.text = nil
        ratingValueLabel.text = nil
        commentLabel.text = nil
        starRatingView.reset()
    }
}

// MARK: - Setup UI
private extension ReviewCollectionViewCell {

    func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(avatarView)
        avatarView.addSubview(avatarLabel)
        containerView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),

            avatarView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            avatarView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            avatarView.widthAnchor.constraint(equalToConstant: 36),
            avatarView.heightAnchor.constraint(equalToConstant: 36),

            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),

            contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            contentStackView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 10),
            contentStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            contentStackView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -12)
        ])
    }

    func applyShadow() {
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.05
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 10
        containerView.layer.masksToBounds = false
    }
}

// MARK: - Configure
extension ReviewCollectionViewCell {

    func configure(with review: Review) {
        let reviewerName = review.reviewerName ?? "Unknown user"
        let reviewerEmail = review.reviewerEmail ?? "No email"
        let comment = review.comment ?? "No comment"

        nameLabel.text = reviewerName
        emailLabel.text = reviewerEmail
        commentLabel.text = comment
        avatarLabel.text = String(reviewerName.prefix(1)).uppercased()

        if let rating = review.rating {
            let ratingValue = Double(rating)
            starRatingView.configure(rating: ratingValue, starSize: 13)
            ratingValueLabel.text = String(format: "%.1f", ratingValue)
            ratingContainerStackView.isHidden = false
        } else {
            starRatingView.reset()
            ratingValueLabel.text = "Chưa có đánh giá"
            ratingContainerStackView.isHidden = false
        }
    }
}
