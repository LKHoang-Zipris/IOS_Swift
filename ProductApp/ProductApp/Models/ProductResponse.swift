//
//  ProductResponse.swift
//  ProductApp
//
//  Created by Lê Kim Hoàng on 30/3/26.
//


import Foundation

struct ProductResponse: Decodable {
    let products: [HomeProduct]
    let total: Int
    let skip: Int
    let limit: Int
}

struct HomeProduct: Decodable {
    let id: Int
    let title: String
    let description: String?
    let category: String?
    let price: Double
    let discountPercentage: Double?
    let rating: Double?
    let stock: Int?
    let tags: [String]?
    let brand: String?
    let sku: String?
    let weight: Int?
    let dimensions: Dimensions?
    let warrantyInformation: String?
    let shippingInformation: String?
    let availabilityStatus: String?
    let reviews: [Review]?
    let returnPolicy: String?
    let minimumOrderQuantity: Int?
    let meta: ProductMeta?
    let thumbnail: String?
    let images: [String]?
}

struct Dimensions: Decodable {
    let width: Double?
    let height: Double?
    let depth: Double?
}

struct Review: Decodable {
    let rating: Int?
    let comment: String?
    let date: String?
    let reviewerName: String?
    let reviewerEmail: String?
}

struct ProductMeta: Decodable {
    let createdAt: String?
    let updatedAt: String?
    let barcode: String?
    let qrCode: String?
}
