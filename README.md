# 📱 ProductApp (UIKit + XIB + CollectionView + TabBar)

Ứng dụng iOS hiển thị danh sách sản phẩm với 2 dạng UI:

* 📋 **List (UITableView + XIB)**
* 🧩 **Grid (UICollectionView + API DummyJSON)**

Sử dụng **UIKit + TabBarController**, kết hợp networking, custom UI và navigation flow.

---

## 🎥 Demo

> *(Thêm video/GIF demo tại đây)*

---

## 🚀 Tính năng

### 🏠 Home (CollectionView)

* Hiển thị sản phẩm dạng **grid 2 cột**
* Fetch API từ DummyJSON
* Pagination (load thêm khi scroll)
* Image loading + cache
* Tap → màn detail

### 🛍 Product (UITableView + XIB)

* Hiển thị danh sách sản phẩm từ JSON local
* Custom cell (`ProductCell.xib`)
* Custom header
* Navigation sang detail

### 👤 Profile

* Placeholder screen

---

## 🧱 Kiến trúc

### Model

* `Product.swift`
* `HomeProduct.swift`
* `ProductResponse.swift`

### View

* `ProductCell.swift + .xib`
* `HomeProductCell.swift`
* `ProductHeaderView.swift`
* `ProductDetailViewController.xib`
* `HomeProductDetailViewController.swift`

### Controller

* `ProductListViewController.swift`
* `HomeViewController.swift`
* `ProductDetailViewController.swift`
* `HomeProductDetailViewController.swift`
* `MainTabBarController.swift`

### Networking

* `APIClient.swift`
* `Endpoint.swift`
* `APIError.swift`

### Services

* `ProductService.swift`

### Extensions

* `UITableView+Reusable.swift`
* `UICollectionView+Reusable.swift`
* `UIImageView+Extension.swift`

---


## 🧩 Công nghệ sử dụng

* UIKit
* Auto Layout
* XIB
* UITableView
* UICollectionView
* UITabBarController
* URLSession
* NSCache (image cache)

---

## 📊 TabBar Structure

```id="6u7r0j"
Home (CollectionView - API)
Product (UITableView - Local JSON)
Profile
```

### Setup

```swift id="8m4cdu"
let homeVC = UINavigationController(rootViewController: HomeViewController())
let productVC = UINavigationController(rootViewController: ProductListViewController())
let profileVC = UINavigationController(rootViewController: UIViewController())

viewControllers = [homeVC, productVC, profileVC]
```

---

## 🌐 API (DummyJSON)

```id="s3s3lg"
https://dummyjson.com/products?limit=20&skip=0
```

### Response

```json id="u4a0s0"
{
  "products": [...],
  "total": 100,
  "skip": 0,
  "limit": 20
}
```

---

## 📋 UITableView Flow

```id="m0b2de"
ProductListViewController
        ↓
ProductDetailViewController
```

---

## 🧩 UICollectionView Flow

```id="1j6xg6"
HomeViewController
        ↓
HomeProductDetailViewController
```

---

## 🔄 Pagination

```swift id="5m8m4v"
let threshold = products.count - 4
if indexPath.item >= threshold {
    fetchProducts()
}
```

---

## 🖼 Load ảnh từ URL

```swift id="jzmb0y"
URLSession.shared.dataTask(with: url) { data, _, _ in
    DispatchQueue.main.async {
        imageView.image = UIImage(data: data)
    }
}.resume()
```

---

## 🎨 UI Notes

* Background: custom light gray
* Card: trắng + bo góc
* Grid 2 cột
* Smooth scroll + lazy loading

---

## ⚠️ Lưu ý

* XIB phải connect IBOutlet đúng
* `reuseIdentifier` phải trùng class
* XIB → dùng `UINib`, không dùng `register(class:)`
* UI update phải trên main thread
* Tránh load image lặp → nên cache

---

## 🧠 Best Practices

* Tách `setupHierarchy` / `setupConstraints`
* Dùng `Layout enum` tránh magic numbers
* Generic register/dequeue cho TableView & CollectionView
* Tách networking layer
* Không hardcode URL


## 📌 Kết luận

Project này kết hợp:

* UITableView (classic)
* UICollectionView (modern)
* Networking + Pagination
* TabBar navigation

