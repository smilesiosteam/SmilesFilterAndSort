//
//  File.swift
//
//
//  Created by Ahmed Naguib on 02/11/2023.
//

import Foundation
import SmilesBaseMainRequestManager

final class ListFilterRequest: SmilesBaseMainRequest {
    var categoryId: Int?
    
    init(categoryId: Int?) {
        super.init()
        self.categoryId = categoryId
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    // MARK: - Model Keys
    enum CodingKeys: String, CodingKey {
        case categoryId
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.categoryId, forKey: .categoryId)
    }
}
