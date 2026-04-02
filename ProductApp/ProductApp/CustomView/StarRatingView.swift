import UIKit

final class StarRatingView: UIView {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var currentStarSize: CGFloat = 16
    private var currentTintColor: UIColor = .systemOrange

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension StarRatingView {

    func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - Configure
extension StarRatingView {

    func configure(
        rating: Double,
        starSize: CGFloat = 16,
        tintColor: UIColor = .systemOrange
    ) {
        currentStarSize = starSize
        currentTintColor = tintColor
        renderStars(rating: rating)
    }

    func reset() {
        clearStars()
    }
}

// MARK: - Private
private extension StarRatingView {

    func renderStars(rating: Double) {
        clearStars()

        let fullStars = Int(rating)
        let hasHalfStar = rating - Double(fullStars) >= 0.5

        for index in 0..<5 {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: currentStarSize).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: currentStarSize).isActive = true
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = currentTintColor

            if index < fullStars {
                imageView.image = UIImage(systemName: "star.fill")
            } else if index == fullStars && hasHalfStar {
                imageView.image = UIImage(systemName: "star.leadinghalf.filled")
            } else {
                imageView.image = UIImage(systemName: "star")
            }

            stackView.addArrangedSubview(imageView)
        }
    }

    func clearStars() {
        stackView.arrangedSubviews.forEach { view in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}
