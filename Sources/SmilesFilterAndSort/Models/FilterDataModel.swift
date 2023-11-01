//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 31/10/2023.
//

import Foundation

struct FilterDataModel: Codable {
    let filtersList: [FiltersList]?
}

struct FiltersList: Codable {
    let title, type: String?
    var filterTypes: [FilterType]?
}

// MARK: - FilterType
struct FilterType: Codable {
    let name, type: String?
    let isMultipleSelection: Bool?
    var filterValues: [FilterValue]?
}

// MARK: - FilterValue
struct FilterValue: Codable {
    let name, filterKey, filterValue, parentTitle: String?
    let image, smallImage: String?
    var isSelected: Bool?
    
    mutating func toggle() {
        var value = isSelected ?? false
        value.toggle()
        isSelected = value
    }
}
