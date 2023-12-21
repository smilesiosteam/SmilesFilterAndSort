//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 20/12/2023.
//

import Foundation

public struct OffersFilterResponse: Codable {
    // MARK: - Properties
    public let extTransactionId: String?
    public let categories: [Category]?
    public let subCategories: [SubCategory]?
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case extTransactionId
        case categories
        case subCategories
    }
    
    // MARK: - Decoder
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.extTransactionId = try container.decodeIfPresent(String.self, forKey: .extTransactionId)
        self.categories = try container.decodeIfPresent([Category].self, forKey: .categories)
        self.subCategories = try container.decodeIfPresent([SubCategory].self, forKey: .subCategories)
    }
}

public struct Category: Codable {
    public let categoryName: String?
    public let categoryTypes: [CategoryType]?
    public let categoryId: Int?
    
    public struct CategoryType: Codable {
        public let categoryTypeName: String?
        public let categoryTypeId: Int?
    }
}

public struct SubCategory: Codable {
    public let subCategoryName: String?
    public let subCategoryTypes: [SubCategoryType]?
    public let subCategoryId: Int?
    
    public struct SubCategoryType: Codable {
        public let subCategoryTypeName: String?
        public let subCategoryTypeId: Int?
    }
}
