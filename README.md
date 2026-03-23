# 📱 ProductApp (UIKit + XIB)

Ứng dụng iOS hiển thị danh sách sản phẩm và màn hình chi tiết sản phẩm, được xây dựng bằng **UIKit + XIB + UITableView**.


![Simulator Screen Recording - iPhone 17 Pro - 2026-03-23 at 12 32 17](https://github.com/user-attachments/assets/2955294b-c4e5-4a71-9e4d-3754d2b17976)


---

## 🚀 Tính năng

* Hiển thị danh sách sản phẩm bằng `UITableView`
* Custom cell (`ProductCell.xib`)
* Custom header (`ProductHeaderView`)
* Màn hình chi tiết (`ProductDetailViewController.xib`)
* Load ảnh từ URL (public image)
* Navigation giữa List → Detail

---

## 🧱 Kiến trúc

* **Model**

  * `Product.swift`

* **View**

  * `ProductCell.swift` + `ProductCell.xib`
  * `ProductHeaderView.swift`
  * `ProductDetailViewController.xib`

* **Controller**

  * `ProductListViewController.swift`
  * `ProductDetailViewController.swift`

* **Extensions**

  * `UITableView+Reusable.swift`
  * `UIImageView+Extension.swift`

---

## 📂 Cấu trúc thư mục

```
ProductApp/
├── Model/
│   └── Product.swift
├── View/
│   ├── ProductCell.swift
│   ├── ProductCell.xib
│   ├── ProductHeaderView.swift
│   ├── ProductDetailViewController.swift
│   └── ProductDetailViewController.xib
├── Controller/
│   └── ProductListViewController.swift
├── Extensions/
│   ├── UITableView+Reusable.swift
│   └── UIImageView+Extension.swift
├── Resources/
│   └── products.json
```

---

## 🧩 Công nghệ sử dụng

* UIKit
* Auto Layout
* XIB (Interface Builder)
* UITableView
* URLSession (load image từ URL)

---

## 📄 JSON Data

Dữ liệu sản phẩm nằm trong:

```
products.json
```

Ví dụ:

```json
{
  "id": 1,
  "name": "iPhone 15",
  "price": 22990000,
  "description": "Điện thoại Apple hiệu năng cao.",
  "image": "https://..."
}
```

---

## 🖼 Load ảnh từ URL

Sử dụng extension:

```swift
extension UIImageView {
    func loadImage(from urlString: String) {
        self.image = nil
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data,
                  let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self?.image = image
            }
        }.resume()
    }
}
```

---

## 🔄 Navigation

```swift
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let product = products[indexPath.row]
    let detailVC = ProductDetailViewController(product: product)
    navigationController?.pushViewController(detailVC, animated: true)
}
```

---

## ⚠️ Lưu ý

* Phải connect đúng IBOutlet trong XIB
* `reuseIdentifier` phải trùng với class name
* Không dùng `register(class:)` khi dùng XIB → phải dùng `UINib`
* Khi load ảnh bằng URLSession cần update UI trên main thread

---

## 📈 Nâng cấp trong tương lai

* [ ] Thêm cache ảnh (NSCache)
* [ ] Async/await networking
* [ ] MVVM Architecture
* [ ] API thật
* [ ] Search / Filter

