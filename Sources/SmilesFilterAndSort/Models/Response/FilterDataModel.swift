//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 31/10/2023.
//

import Foundation

public struct FilterDataModel: Codable {
    let filtersList: [FiltersList]?
}

public struct FiltersList: Codable {
    let title, type: String?
    var filterTypes: [FilterType]?
}

// MARK: - FilterType
public struct FilterType: Codable {
    let name, type: String?
    let isMultipleSelection: Bool?
    var filterValues: [FilterValue]?
}

// MARK: - FilterValue
public struct FilterValue: Codable {
    let name, filterKey, filterValue, parentTitle: String?
    let image, smallImage: String?
    var isSelected: Bool?
    
    mutating func toggle() {
        var value = isSelected ?? false
        value.toggle()
        isSelected = value
    }
}
