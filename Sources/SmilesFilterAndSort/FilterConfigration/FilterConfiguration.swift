//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 06/11/2023.
//

import UIKit
import NetworkingLayer
import SmilesUtilities
import SmilesOffers

public protocol SelectedSortDelegate: AnyObject {
    func didSetSort(sortBy: FilterDO)
}


public enum FilterConfiguration {
    
    public static func getGetListFilters(menuType: String?,
                                         previousResponse: Data? = nil,
                                         selectedFilters: [FilterValue],
                                         selectedCusines: FilterValue? = nil,
                                         delegate: SelectedFiltersDelegate) -> UIViewController {
        let baseURL = AppCommonMethods.serviceBaseUrl
        let networkRequest = NetworkingLayerRequestable(requestTimeOut: 60)
        let repository = FilterRepository(networkRequest: networkRequest, baseURL: baseURL)
        let useCase = FilterContainerUseCase(repository: repository, menuItemType: menuType, previousResponse: previousResponse, selectedFilters: selectedFilters)
        useCase.selectedCusines = selectedCusines
        let viewModel = FilterContainerViewModel(useCase: useCase)
     
        viewModel.delegate = delegate
        let viewController = FilterContainerViewController.create()
        viewController.viewModel = viewModel
        return viewController
    }
    
    public static func getListSort(sortModels: [FilterDO], delegate: SelectedSortDelegate) -> UIViewController {
        return UIViewController()
    }
}
