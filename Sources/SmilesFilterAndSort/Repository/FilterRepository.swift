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
    func fetchFilters(menuItemType: String?) -> AnyPublisher<FilterDataModel, NetworkError>
}

final class FilterRepository: FilterRepositoryType {
    // MARK: - Properties
    private var networkRequest: Requestable
    private var baseURL: String
    
    // MARK: - Init
    init(networkRequest: Requestable, baseURL: String) {
        self.networkRequest = networkRequest
        self.baseURL = baseURL
        
    }
    
    // MARK: - Functions
    public func fetchFilters(menuItemType: String?) -> AnyPublisher<FilterDataModel, NetworkError> {
        let requestCategory = ListFilterRequest(menuItemType: menuItemType)
        let endPoint = FilterRequestBuilder.listFilters(request: requestCategory)
        
        let request = endPoint.createRequest(
            baseURL: self.baseURL,
            endPoint: FilterEndPoints.listFilters
        )
        
        return networkRequest.request(request)
    }
}
