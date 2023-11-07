//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 06/11/2023.
//

import UIKit
import NetworkingLayer
import SmilesUtilities

public enum FilterConfiguration {
    
    public static func getGetListFilters(menuType: String?,
                                   previousResponse: Data? = nil,
                                         delegate: SelectedFiltersDelegate) -> UIViewController {
        let baseURL = AppCommonMethods.serviceBaseUrl
        let networkRequest = NetworkingLayerRequestable(requestTimeOut: 60)
        let repository = FilterRepository(networkRequest: networkRequest, baseURL: baseURL)
        let useCase = FilterContainerUseCase(repository: repository, menuItemType: menuType, previousResponse: previousResponse)
        let viewModel = FilterContainerViewModel(useCase: useCase)
        viewModel.delegate = delegate
        let viewController = FilterContainerViewController.create()
        viewController.viewModel = viewModel
        return viewController
    }
}
