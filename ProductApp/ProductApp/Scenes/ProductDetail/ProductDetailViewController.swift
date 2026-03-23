import UIKit

final class ProductDetailViewController: UIViewController {
    
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    private let product: Product
    
    init(product: Product) {
        self.product = product
        super.init(nibName: "ProductDetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindData()
    }
    
    private func setupUI() {
        title = "Chi tiết sản phẩm"
        view.backgroundColor = .systemBackground
        
        productImageView.layer.cornerRadius = 12
        productImageView.clipsToBounds = true
        productImageView.contentMode = .scaleAspectFill
        
        nameLabel.font = .boldSystemFont(ofSize: 24)
        nameLabel.textColor = .label
        nameLabel.numberOfLines = 0
        
        priceLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        priceLabel.textColor = .systemRed
        
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0
    }
    
    private func bindData() {
        nameLabel.text = product.name
        priceLabel.text = "\(Int(product.price)) VNĐ"
        descriptionLabel.text = product.description
        productImageView.loadImage(from: product.image)
    }
}
