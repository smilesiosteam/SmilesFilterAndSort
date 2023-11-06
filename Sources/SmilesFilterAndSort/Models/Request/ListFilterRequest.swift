//
//  File.swift
//
//
//  Created by Ahmed Naguib on 02/11/2023.
//

import Foundation
import SmilesBaseMainRequestManager

final class ListFilterRequest: SmilesBaseMainRequest {
    var menuItemType: String?
    
    init(menuItemType: String?) {
        super.init()
        self.menuItemType = menuItemType
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    // MARK: - Model Keys
    enum CodingKeys: String, CodingKey {
        case menuItemType
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.menuItemType, forKey: .menuItemType)
    }
}
