//
//  ApiResponse.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 06.07.24.
//

import Foundation




// MARK: - ApiResponse
struct ApiResponse: Codable {
    let result: Result
}

// MARK: - Result
struct Result: Codable {
    let status: Status
    let settings: Settings
    let base: Base
    let resultList: [ResultList]
}

// MARK: - Base
struct Base: Codable {
    let hasNextPage: Bool
    let totalResults, pageSize: Int
    let q: String
    let sortValues: [String]
}

// MARK: - ResultList
struct ResultList: Codable {
    let item: Item
    let delivery: Delivery
}

// MARK: - Delivery
struct Delivery: Codable {
    let freeShipping: Bool
    let shippingFee: Int?
    let shippingDisplay: String
}

// MARK: - Item
struct Item: Codable {
    let itemId: Int
    let title: String
    let sales: Int
    let image: String
    let sku: Sku
    let averageStarRate: Double?
}

// MARK: - Sku
struct Sku: Codable {
    let def: Def
}

// MARK: - Def
struct Def: Codable {
    let price, promotionPrice: Double?
    let prices: Prices
}

// MARK: - Prices
struct Prices: Codable {
    let pc, app: Double
}

// MARK: - Settings
struct Settings: Codable {
    let q, catId, brandId, loc, attr, sort, page, startPrice, endPrice, region, locale, currency: String
}

// MARK: - Status
struct Status: Codable {
    let code: Int
    let attempt: Int
    let data: String
    let executionTime, requestTime, requestId, endpoint, apiVersion, functionsVersion, la: String
    let pmu, mu: Int
}
