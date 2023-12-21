//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 20/12/2023.
//

import Foundation
import SmilesBaseMainRequestManager

public class OffersFilterRequest: SmilesBaseMainRequest {
    // MARK: - Properties
    public var categoryId: String?
    public var sortingType: String?
//    public var isGuestUser: Bool?
    
    // MARK: - Initializer
    public init(categoryId: String?, sortingType: String?) {
        super.init()
        self.categoryId = categoryId
        self.sortingType = sortingType
    }
    
    public required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case categoryId
        case sortingType
    }
    
    // MARK: - Encoder
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.categoryId, forKey: .categoryId)
        try container.encodeIfPresent(self.sortingType, forKey: .sortingType)
    }
}
