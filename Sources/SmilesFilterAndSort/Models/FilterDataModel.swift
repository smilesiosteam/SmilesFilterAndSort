//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 31/10/2023.
//

import Foundation

//enum FilterName: String, Codable {
//    case explore = "Explore"
//    case rating = "Rating"
//    case price = "Price"
//    case dietery = "Dietery"
//    case cuisines = "Cusines"
//}
//
//struct FilterValue: Codable {
//    let name: String?
//    let filterKey: String?
//    let filterValue: String?
//    let parentTitle: String?
//    let image: String?
//    let smallImage: String?
//    var isSelected: Bool?
//}
//
//enum FilterType: Codable {
//    case explore(isMultipleSelection: Bool, filterValues: [FilterValue])
//    case rating(isMultipleSelection: Bool, filterValues: [FilterValue])
//    case price(isMultipleSelection: Bool, filterValues: [FilterValue])
//    case dietery(isMultipleSelection: Bool, filterValues: [FilterValue])
//    case cuisines(isMultipleSelection: Bool, filterValues: [FilterValue])
//   
//    enum CodingKeys: String, CodingKey {
//        case name
//        case isMultipleSelection
//        case filterValues
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let name = try container.decode(FilterName.self, forKey: .name)
//        let isMultipleSelection = try container.decode(Bool.self, forKey: .isMultipleSelection)
//        let filterValues = try container.decode([FilterValue].self, forKey: .filterValues)
//
//        switch name {
//        case .explore:
//            self = .explore(isMultipleSelection: isMultipleSelection, filterValues: filterValues)
//        case .rating:
//            self = .rating(isMultipleSelection: isMultipleSelection, filterValues: filterValues)
//        case .cuisines:
//            self = .cuisines(isMultipleSelection: isMultipleSelection, filterValues: filterValues)
//        case .price:
//            self = .price(isMultipleSelection: isMultipleSelection, filterValues: filterValues)
//        case .dietery:
//            self = .dietery(isMultipleSelection: isMultipleSelection, filterValues: filterValues)
//        }
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        switch self {
//        case .explore(let isMultipleSelection, let filterValues):
//            try container.encode(FilterName.explore, forKey: .name)
//            try container.encode(isMultipleSelection, forKey: .isMultipleSelection)
//            try container.encode(filterValues, forKey: .filterValues)
//        case .rating(let isMultipleSelection, let filterValues):
//            try container.encode(FilterName.rating, forKey: .name)
//            try container.encode(isMultipleSelection, forKey: .isMultipleSelection)
//            try container.encode(filterValues, forKey: .filterValues)
//        case .cuisines(let isMultipleSelection, let filterValues):
//            try container.encode(FilterName.cuisines, forKey: .name)
//            try container.encode(isMultipleSelection, forKey: .isMultipleSelection)
//            try container.encode(filterValues, forKey: .filterValues)
//        case .price(isMultipleSelection: let isMultipleSelection, filterValues: let filterValues):
//            try container.encode(FilterName.price, forKey: .name)
//            try container.encode(isMultipleSelection, forKey: .isMultipleSelection)
//            try container.encode(filterValues, forKey: .filterValues)
//        case .dietery(isMultipleSelection: let isMultipleSelection, filterValues: let filterValues):
//            try container.encode(FilterName.dietery, forKey: .name)
//            try container.encode(isMultipleSelection, forKey: .isMultipleSelection)
//            try container.encode(filterValues, forKey: .filterValues)
//        }
//    }
//}
//
//struct FilterCategory: Codable {
//    let title: String?
//    let filterTypes: [FilterType]
//}
//
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
