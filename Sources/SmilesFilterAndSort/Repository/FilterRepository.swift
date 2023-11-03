//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 02/11/2023.
//

import Foundation
import Combine
import NetworkingLayer

protocol FilterRepositoryType {
    
}

public final class FilterRepository {
    private var networkRequest: Requestable
    private var baseURL: String
    
   public init(networkRequest: Requestable, baseURL: String) {
        self.networkRequest = networkRequest
        self.baseURL = baseURL

    }
    
    public func fetchFilters(categoryId: Int?) -> AnyPublisher<FilterDataModel, NetworkError> {
        let requestCategory = ListFilterRequest(categoryId: categoryId)
        let endPoint = FilterRequestBuilder.listFilters(request: requestCategory)
        
        let request = endPoint.createRequest(
            baseURL: self.baseURL,
            endPoint: FilterEndPoints.listFilters
        )
        
        return networkRequest.request(request)
        
    }
}
