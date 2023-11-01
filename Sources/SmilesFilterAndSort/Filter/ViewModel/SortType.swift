//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 30/10/2023.
//

import Foundation

enum SortType: Int {
    case explore
    case rating
    case price
    case dietary
    
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
        }
    }
}
