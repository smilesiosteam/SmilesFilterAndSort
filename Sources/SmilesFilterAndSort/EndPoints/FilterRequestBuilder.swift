//
//  File.swift
//
//
//  Created by Ahmed Naguib on 02/11/2023.
//

import Foundation
import NetworkingLayer

enum FilterRequestBuilder {
    case listFilters(request: ListFilterRequest)
    
    var requestTimeOut: Int {
        return 100
    }
    
    var httpMethod: SmilesHTTPMethod {
        switch self {
        case .listFilters:
            return .POST
        }
    }
    
    func createRequest(baseURL: String, endPoint: FilterEndPoints) -> NetworkRequest {
        var headers: [String: String] = [:]
        
        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        headers["CUSTOM_HEADER"] = "pre_prod"
        return NetworkRequest(url: getURL(from: baseURL, for: endPoint), headers: headers, reqBody: requestBody, httpMethod: httpMethod)
    }
    
    var requestBody: Encodable? {
        switch self {
        case .listFilters(let request):
            return request
        }
    }
    
    func getURL(from baseURL: String, for endPoint: FilterEndPoints) -> String {
        let endPoint = endPoint.url
        
        switch self {
        case .listFilters:
            return "\(baseURL)\(endPoint)"
        }
    }
}
