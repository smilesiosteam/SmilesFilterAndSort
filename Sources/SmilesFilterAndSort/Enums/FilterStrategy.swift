//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 31/10/2023.
//

import Foundation

public enum FilterStrategy {
    case filter(title: String?)
    case cusines(title: String?)
    
    var text: String {
        switch self {
        case .filter:
            return "filterby"
        case .cusines:
            return  "cuisines"
        }
    }
}
