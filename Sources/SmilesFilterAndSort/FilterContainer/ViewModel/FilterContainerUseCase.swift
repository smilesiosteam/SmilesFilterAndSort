//
//  File.swift
//
//
//  Created by Ahmed Naguib on 01/11/2023.
//

import Foundation
import NetworkingLayer
import Combine

protocol FilterContainerUseCaseType {
    func fetchFilters()
    func getFilterIndex() -> Int?
    func getCusinesIndex() -> Int?
    var statePublisher: AnyPublisher<FilterContainerUseCase.State, Never> { get }
}

final class FilterContainerUseCase: FilterContainerUseCaseType {
    
    // MARK: - Properties
    private var filtersList: [FiltersList] = []
    private let repository: FilterRepositoryType
    private let menuItemType: String?
    private var cancellable = Set<AnyCancellable>()
    private var stateSubject = PassthroughSubject<State, Never>()
    private var previousResponse: Data?
    var selectedCusines: FilterValue?
    private let selectedFilters: [FilterValue]
    private let filterSelection = FilterSelection()
    
    var statePublisher: AnyPublisher<State, Never> {
        return stateSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    init(repository: FilterRepositoryType,
         menuItemType: String?,
         previousResponse: Data?,
         selectedFilters: [FilterValue]) {
        self.repository = repository
        self.menuItemType = menuItemType
        self.previousResponse = previousResponse
        self.selectedFilters = selectedFilters
    }
    
    // MARK: - Functions
    func fetchFilters() {
        if let previousResponse {
            fetchLocalFilters(data: previousResponse)
        } else {
            fetchRemoteFilters()
        }
    }
    
    private func fetchLocalFilters(data: Data) {
        if let values: FilterDataModel = data.decoded() {
            let list = values.filtersList ?? []
            self.filtersList = list
            self.handleSuccessResponse()
            
        } else {
            fetchRemoteFilters()
        }
    }
    
    private func fetchRemoteFilters() {
        repository.fetchFilters(menuItemType: menuItemType)
            .sink { [weak self] completion in
                guard let self else {
                    return
                }
                if case .failure(let error)  = completion {
                    self.stateSubject.send(.error(message: error.localizedDescription))
                }
                
            } receiveValue: { [weak self] values in
                guard let self else {
                    return
                }
                let list = values.filtersList ?? []
                self.filtersList = list
                self.handleSuccessResponse()
            }
            .store(in: &cancellable)
    }
    
    private func handleSuccessResponse() {
        var dependency: FilterSelection.Dependency = .init()
        dependency.cusinesIndex = getCusinesIndex()
        dependency.filterIndex = getFilterIndex()
        dependency.filtersList = filtersList
        dependency.selectedCusines = selectedCusines
        dependency.selectedFilters = selectedFilters
        filtersList = filterSelection.getSelectedItems(dependency: dependency)
        stateSubject.send(.listFilters(filters: .init(extTransactionID: "", filtersList: filtersList)))
        handleResponse()
    }
    
    private func handleResponse() {
        var filters: FilterUIModel = .init()
        var cusines: FilterUIModel = .init()
        
        if let filterIndex = getFilterIndex() {
            filters = FilterMapper.configFilters(filtersList[filterIndex])
        }
        
        if let cusinesIndex = getCusinesIndex() {
            cusines = FilterMapper.configFilters(filtersList[cusinesIndex])
        }
        
        stateSubject.send(.values(filters: filters, cusines: cusines))
    }
    
    func getFilterIndex() -> Int? {
        filtersList.firstIndex(where: { $0.type == FilterStrategy.filter(title: nil).text })
    }
    
    func getCusinesIndex() -> Int? {
        filtersList.firstIndex(where: { $0.type == FilterStrategy.cusines(title: nil).text })
    }
}

extension FilterContainerUseCase {
    enum State {
        case error(message: String)
        case listFilters(filters: FilterDataModel)
        case values(filters: FilterUIModel, cusines: FilterUIModel)
    }
}
