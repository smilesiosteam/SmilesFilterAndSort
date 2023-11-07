//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 07/11/2023.
//

import Foundation
import SmilesUtilities

enum FilterLocalization {
    case filter
    case apply
    case search
    case clearAll
    case filtersSelected
    var text: String {
        switch self {
        case .filter:
            return "FilterMainTitle".localizedString
        case .apply:
            return "ApplyTitle".localizedString
        case .search:
            return "Search".localizedString
        case .clearAll:
            return "clearAll".localizedString
        case .filtersSelected:
            return "filtersSelected".localizedString
        }
    }
}




