//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 30/10/2023.
//

import Foundation

enum SortType {
    case explore
    case rating
    case price
    case dietary
    case custom(name: String)
    
    var name: String {
        switch self {
        case .explore:
            return "explore"
        case .rating:
            return "rating"
        case .price:
           return "price"
        case .dietary:
            return "dietery"
        case .custom(name: let name):
            return name
        }
    }
}
