//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 31/10/2023.
//

import Foundation

public struct FilterDataModel: Codable {
    let extTransactionID: String?
    var filtersList: [FiltersList]?
    enum CodingKeys: String, CodingKey {
        case extTransactionID = "extTransactionId"
        case  filtersList = "filterList"
    }
    
    mutating func setUnselectedValues() -> [FiltersList]?{
        let count = filtersList?.count ?? 0
        for index in 0..<count {
            filtersList?[index].setUnselectedValues()
        }
        
        return filtersList
    }
}

public struct FiltersList: Codable {
    let title, type: String?
    var filterTypes: [FilterType]?
    
    mutating func setUnselectedValues() {
        let count = filterTypes?.count ?? 0
        for index in 0..<count {
            filterTypes?[index].setUnselectedValues()
        }
     }
}

// MARK: - FilterType
public struct FilterType: Codable {
    let name, type: String?
    let isMultipleSelection: Bool?
    var filterValues: [FilterValue]?
    
   mutating func setUnselectedValues() {
       let count = filterValues?.count ?? 0
       for index in 0..<count {
           filterValues?[index].setUnselected()
       }
    }
}

// MARK: - FilterValue
public struct FilterValue: Codable {
    public var filterKey, filterValue: String?
    public let name, parentTitle: String?
    public let image, smallImage: String?
    var isSelected: Bool?
   
    public init(filterKey: String? = nil, 
         filterValue: String? = nil,
         name: String? = nil,
         parentTitle: String? = nil,
         image: String? = nil,
         smallImage: String? = nil,
         isSelected: Bool? = nil) {
        self.filterKey = filterKey
        self.filterValue = filterValue
        self.name = name
        self.parentTitle = parentTitle
        self.image = image
        self.smallImage = smallImage
        self.isSelected = isSelected
    }
    mutating func toggle() {
        var value = isSelected ?? false
        value.toggle()
        isSelected = value
    }
    
    mutating func setUnselected() {
        isSelected = false
    }
}

extension FilterValue {
   
}
