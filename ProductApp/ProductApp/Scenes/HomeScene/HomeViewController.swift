import UIKit

final class HomeViewController: UIViewController {
    
    private enum Layout {
        static let lineSpacing: CGFloat = 12
        static let interItemSpacing: CGFloat = 12
        static let sectionInset: CGFloat = 12
        static let loadMoreThreshold = 4
        static let itemHeight: CGFloat = 250
    }
    
    // MARK: - Variables
    private var products: [HomeProduct] = []
    private var totalProducts = 0
    private let limit = 20
    private var skip = 0
    private var isLoading = false
    
    // MARK: - UI
    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.alwaysBounceVertical = true
        view.dataSource = self
        view.delegate = self
        view.register(HomeProductCell.self)
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureAppearance()
        setupHierarchy()
        setupConstraints()
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
private extension HomeViewController {
    
    func configureNavigation() {
        navigationItem.title = ""
    }
    
    func configureAppearance() {
        view.backgroundColor = .systemBackground
    }
    
    func makeCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Layout.lineSpacing
        layout.minimumInteritemSpacing = Layout.interItemSpacing
        layout.sectionInset = UIEdgeInsets(
            top: Layout.sectionInset,
            left: Layout.sectionInset,
            bottom: Layout.sectionInset,
            right: Layout.sectionInset
        )
        return layout
    }
}

// MARK: - Setup UI
private extension HomeViewController {
    
    func setupHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - Data
private extension HomeViewController {
    
    func fetchProducts() {
        guard !isLoading else { return }
        isLoading = true
        
        if products.isEmpty {
            activityIndicator.startAnimating()
        }
        
        ProductService.shared.fetchProducts(limit: limit, skip: skip) { [weak self] result in
            guard let self else { return }
            
            self.activityIndicator.stopAnimating()
            self.isLoading = false
            
            switch result {
            case .success(let response):
                self.handleFetchSuccess(response)
            case .failure(let error):
                self.showError(message: error.localizedDescription)
            }
        }
    }
    
    func handleFetchSuccess(_ response: ProductResponse) {
        totalProducts = response.total
        products.append(contentsOf: response.products)
        skip += response.limit
        collectionView.reloadData()
    }
    
    func loadMoreIfNeeded(for indexPath: IndexPath) {
        let threshold = products.count - Layout.loadMoreThreshold
        if indexPath.item >= threshold, products.count < totalProducts {
            fetchProducts()
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

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        loadMoreIfNeeded(for: indexPath)
        
        let cell: HomeProductCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(with: products[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalHorizontalInset = Layout.sectionInset * 2
        let totalSpacing = Layout.interItemSpacing
        let availableWidth = collectionView.bounds.width - totalHorizontalInset - totalSpacing
        let width = floor(availableWidth / 2)
        
        return CGSize(width: width, height: Layout.itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = products[indexPath.item]
        let viewController = HomeProductDetailViewController(product: product)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}
