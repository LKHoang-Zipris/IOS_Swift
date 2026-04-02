import UIKit

final class CommentDetailViewController: UIViewController {

    private let review: Review
    private var nameProduct: String = "comment"

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 22
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let avatarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.12)
        view.layer.cornerRadius = 24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let avatarLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()

    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()

    private let starRatingView = StarRatingView()

    private let ratingValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .systemOrange
        return label
    }()

    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            starRatingView,
            ratingValueLabel
        ])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()

    private lazy var userInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            nameLabel,
            emailLabel,
            ratingStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let commentTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Comment"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .label
        return label
    }()

    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()

    private lazy var commentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            commentTitleLabel,
            commentLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    init(review: Review, nameProduct: String) {
        self.review = review
        self.nameProduct = nameProduct
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        applyShadow()
        bindData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cardView.layer.shadowPath = UIBezierPath(
            roundedRect: cardView.bounds,
            cornerRadius: cardView.layer.cornerRadius
        ).cgPath
    }
}

// MARK: - Setup UI
private extension CommentDetailViewController {

    func setupUI() {
        title = nameProduct
        view.backgroundColor = .white

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )

        view.addSubview(cardView)
        cardView.addSubview(avatarView)
        avatarView.addSubview(avatarLabel)
        cardView.addSubview(userInfoStackView)
        cardView.addSubview(commentStackView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            avatarView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 18),
            avatarView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 18),
            avatarView.widthAnchor.constraint(equalToConstant: 48),
            avatarView.heightAnchor.constraint(equalToConstant: 48),

            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),

            userInfoStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 18),
            userInfoStackView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 14),
            userInfoStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -18),

            commentStackView.topAnchor.constraint(equalTo: userInfoStackView.bottomAnchor, constant: 16),
            commentStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 18),
            commentStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -18),
            commentStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -18)
        ])
    }

    func applyShadow() {
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.05
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowRadius = 10
        cardView.layer.masksToBounds = false
    }

    func bindData() {
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
        } else {
            starRatingView.reset()
            ratingValueLabel.text = "Chưa có đánh giá"
        }
    }

    @objc func didTapClose() {
        dismiss(animated: true)
    }
}
