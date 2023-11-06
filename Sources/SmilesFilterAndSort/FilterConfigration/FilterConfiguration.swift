//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 06/11/2023.
//

import UIKit
import NetworkingLayer

public enum FilterConfiguration {
    
    public static func getGetListFilters(menuType: String?,
                                  baseUrl: String,
                                  networkRequest: Requestable,
                                   previousResponse: Data? = nil,
                                  didSetFilters: (([String: [String]], Data?) -> Void)?) -> UIViewController {
        let repository = FilterRepository(networkRequest: networkRequest, baseURL: baseUrl)
        let useCase = FilterContainerUseCase(repository: repository, menuItemType: menuType, previousResponse: previousResponse)
        let viewModel = FilterContainerViewModel(useCase: useCase)
        viewModel.didSetFilters = didSetFilters
        let viewController = FilterContainerViewController.create()
        viewController.viewModel = viewModel
        return viewController
    }
}
