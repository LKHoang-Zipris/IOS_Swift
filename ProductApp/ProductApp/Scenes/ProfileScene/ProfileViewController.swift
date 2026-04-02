import UIKit

final class ProfileViewController: UIViewController {
    private var products: [HomeProduct] = []
    private var isLoading = false

    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 220
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureAppearance()
        setupHierarchy()
        setupConstraints()
        setupTableView()
        fetchProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - Configure
private extension ProfileViewController {

    func configureNavigation() {
        title = ""
    }

    func configureAppearance() {
        view.backgroundColor = .clear
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCell(ProductTableViewCell.self)
    }
}

// MARK: - Setup UI
private extension ProfileViewController {

    func setupHierarchy() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - Data
private extension ProfileViewController {

    func fetchProducts() {
        guard !isLoading else { return }
        isLoading = true

        if products.isEmpty {
            activityIndicator.startAnimating()
        }

        ProductService.shared.fetchProducts(limit: 10, skip: 0) { [weak self] result in
            guard let self else { return }

            self.activityIndicator.stopAnimating()
            self.isLoading = false

            switch result {
            case .success(let response):
                self.products = response.products
                self.tableView.reloadData()

            case .failure(let error):
                self.showError(message: error.localizedDescription)
            }
        }
    }

    func showError(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProductTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: products[indexPath.row], parentViewController: self)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let product = products[indexPath.row]
        let viewController = DetailViewController(product: product)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}
