//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 08/11/2023.
//

import Foundation

public struct NoFilteredResultCellModel {
    public var image: String?
    public var title: String?
    public var description: String?
    
    public init(image: String? = "empty-result-food-icon", title: String? = FilterLocalization.noFilteredResultFoundTitle.text, description: String? = FilterLocalization.noFilteredResultFoundDescription.text) {
        self.image = image
        self.title = title
        self.description = description
    }
}
