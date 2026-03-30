//
//  ProductService.swift
//  ProductApp
//
//  Created by Lê Kim Hoàng on 30/3/26.
//


import Foundation

final class ProductService {
    
    static let shared = ProductService()
    
    private init() {}
    
    func fetchProducts(
        limit: Int,
        skip: Int,
        completion: @escaping (Result<ProductResponse, Error>) -> Void
    ) {
        APIClient.shared.request(
            endpoint: .products(limit: limit, skip: skip),
            completion: completion
        )
    }
}