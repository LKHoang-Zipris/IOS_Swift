//
//  Product.swift
//  ProductApp
//
//  Created by Lê Kim Hoàng on 23/3/26.
//


import Foundation

struct Product: Codable {
    let id: Int
    let name: String
    let price: Double
    let description: String
    var image: String
}

func loadProducts() -> [Product] {
    guard let url = Bundle.main.url(forResource: "products_with_images", withExtension: "json") else {
        return []
    }
    
    do {
        let data = try Data(contentsOf: url)
        let products = try JSONDecoder().decode([Product].self, from: data)
        return products
    } catch {
        print("Load JSON error:", error)
        return []
    }
}
