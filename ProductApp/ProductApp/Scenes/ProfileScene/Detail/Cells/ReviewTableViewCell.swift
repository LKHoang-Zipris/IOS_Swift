import UIKit

final class ReviewTableViewCell: UITableViewCell {

    private let cardView: UIView = {
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
        view.layer.cornerRadius = 22
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let avatarLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()

    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
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
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let starRatingView = StarRatingView()

    private let ratingValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemOrange
        return label
    }()

    private lazy var ratingContainerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            starRatingView,
            ratingValueLabel
        ])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
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
        stackView.spacing = 10
        stackView.alignment = .fill
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
        avatarLabel.text = nil
        nameLabel.text = nil
        emailLabel.text = nil
        ratingValueLabel.text = nil
        commentLabel.text = nil
        starRatingView.reset()
    }
}

// MARK: - Setup UI
private extension ReviewTableViewCell {

    func setupUI() {
        contentView.addSubview(cardView)
        cardView.addSubview(avatarView)
        avatarView.addSubview(avatarLabel)
        cardView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            avatarView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
            avatarView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
            avatarView.widthAnchor.constraint(equalToConstant: 44),
            avatarView.heightAnchor.constraint(equalToConstant: 44),

            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),

            contentStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
            contentStackView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            contentStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            contentStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -14)
        ])
    }

    func applyShadow() {
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.05
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowRadius = 10
        cardView.layer.masksToBounds = false
    }
}

// MARK: - Configure
extension ReviewTableViewCell {

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
            starRatingView.configure(rating: ratingValue, starSize: 16)
            ratingValueLabel.text = String(format: "%.1f", ratingValue)  
            ratingContainerStackView.isHidden = false
        } else {
            starRatingView.reset()
            ratingValueLabel.text = "Chưa có đánh giá"
            ratingContainerStackView.isHidden = false
        }
    }
}
