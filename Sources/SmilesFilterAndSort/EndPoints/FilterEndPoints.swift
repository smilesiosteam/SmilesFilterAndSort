//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 02/11/2023.
//

import Foundation


enum FilterEndPoints {
    case listFilters
    
    var url: String {
        switch self {
        case .listFilters:
            return "menu-list/v1/get-filters-and-sorting"
        }
    }
}
