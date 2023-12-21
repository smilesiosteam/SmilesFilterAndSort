//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 02/11/2023.
//

import Foundation

enum FilterEndPoints {
    case listFilters
    case offersFilters
    
    var url: String {
        switch self {
        case .listFilters:
            return "menu-list/v1/get-filters-and-sorting"
        case .offersFilters:
            return "home/get-offers-filters"
        }
    }
}
