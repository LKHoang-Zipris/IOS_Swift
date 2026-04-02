import UIKit

final class DetailViewController: UIViewController {

    private let product: HomeProduct
    private let reviews: [Review]

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.sectionHeaderTopPadding = 8
        return tableView
    }()

    init(product: HomeProduct) {
        self.product = product
        self.reviews = product.reviews ?? []
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
}

// MARK: - Setup UI
private extension DetailViewController {

    func setupUI() {
        title = "\(product.title)"
        view.backgroundColor = .systemGroupedBackground

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: -64),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCell(ProductInfoTableViewCell.self)
        tableView.registerCell(ReviewTableViewCell.self)
    }
}

// MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return reviews.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: ProductInfoTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(with: product)
            return cell

        case 1:
            let cell: ReviewTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(with: reviews[indexPath.row])
            return cell

        default:
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate
extension DetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return nil
        case 1:
            return reviews.isEmpty ? nil : "Customer Reviews"
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }

        tableView.deselectRow(at: indexPath, animated: true)

        let review = reviews[indexPath.row]
        let viewController = CommentDetailViewController(review: review, nameProduct: product.title)
        let navigationController = UINavigationController(rootViewController: viewController)

        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
        }

        present(navigationController, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return .leastNormalMagnitude
        case 1:
            return reviews.isEmpty ? .leastNormalMagnitude : 36
        default:
            return .leastNormalMagnitude
        }
    }
}
