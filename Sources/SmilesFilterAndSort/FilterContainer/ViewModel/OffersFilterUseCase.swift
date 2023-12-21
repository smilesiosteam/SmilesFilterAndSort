//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 20/12/2023.
//

import Foundation
import Combine

protocol OffersFilterUseCaseType {
    func fetchFilters()
    func getFilterIndex() -> Int?
    var statePublisher: AnyPublisher<OffersFilterUseCase.State, Never> { get }
}

final class OffersFilterUseCase: OffersFilterUseCaseType {
    // MARK: - Private Properties
    private var filtersList: [FiltersList] = []
    private let repository: FilterRepositoryType
    private let categoryId: String?
    private let sortingType: String?
    private var cancellables = Set<AnyCancellable>()
    private var stateSubject = PassthroughSubject<State, Never>()
    private var previousResponse: Data?
    private let selectedFilters: [FilterValue]
    private let filterSelection = FilterSelection()
    
    // MARK: - Public Properties
    var statePublisher: AnyPublisher<State, Never> {
        return stateSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    init(repository: FilterRepositoryType,
         categoryId: String?,
         sortingType: String?,
         previousResponse: Data?,
         selectedFilters: [FilterValue]) {
        self.repository = repository
        self.categoryId = categoryId
        self.sortingType = sortingType
        self.previousResponse = previousResponse
        self.selectedFilters = selectedFilters
    }
    
    // MARK: - Methods
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
        repository.fetchOffersFilters(categoryId: categoryId, sortingType: sortingType)
            .sink { [weak self] completion in
                guard let self else {
                    return
                }
                if case .failure(let error) = completion {
                    self.stateSubject.send(.error(message: error.localizedDescription))
                }
                
            } receiveValue: { [weak self] values in
                guard let self else {
                    return
                }
                let list = mapFilterObjects(response: values)
                self.filtersList = list
                self.handleSuccessResponse()
            }
        .store(in: &cancellables)
    }
    
    private func handleSuccessResponse() {
        var dependency: FilterSelection.Dependency = .init()
        dependency.filterIndex = getFilterIndex()
        dependency.filtersList = filtersList
        dependency.selectedFilters = selectedFilters
        filtersList = filterSelection.getSelectedItems(dependency: dependency)
        stateSubject.send(.listFilters(filters: .init(extTransactionID: "", filtersList: filtersList)))
        handleResponse()
    }
    
    private func handleResponse() {
        var filters: FilterUIModel = .init()
        
        if let filterIndex = getFilterIndex() {
            filters = FilterMapper.configFilters(filtersList[filterIndex])
        }
        
        stateSubject.send(.values(filters: filters))
    }
    
    func getFilterIndex() -> Int? {
        filtersList.firstIndex(where: { $0.type == FilterStrategy.filter(title: nil).text })
    }
    
    private func mapFilterObjects(response: OffersFilterResponse) -> [FiltersList] {
        var filterValues = [FilterValue]()
        var filterTypes = [FilterType]()
        var filters = [FiltersList]()
        
        if categoryId == "9" {
            if let categories = response.categories, !categories.isEmpty {
                categories.forEach { category in
                    var filter = FiltersList(title: category.categoryName, type: "filterby")
                    category.categoryTypes?.forEach { categoryType in
                        let filterValue = FilterValue(filterKey: "\(categoryType.categoryTypeId ?? 0)", filterValue: "\(category.categoryId ?? 1)", name: categoryType.categoryTypeName, parentTitle: category.categoryName, isSelected: false)
                        filterValues.append(filterValue)
                    }
                    let filterType = FilterType(name: FilterLocalization.explore.text, type: "explore", isMultipleSelection: true, filterValues: filterValues)
                    filterTypes.append(filterType)
                    filter.filterTypes = filterTypes
                    filters.append(filter)
                }
            }
        } else {
            if let subCategories = response.subCategories, !subCategories.isEmpty {
                subCategories.forEach { subCategory in
                    var filter = FiltersList(title: subCategory.subCategoryName, type: "filterby")
                    subCategory.subCategoryTypes?.forEach { subCategoryType in
                        let filterValue = FilterValue(filterKey: "\(subCategoryType.subCategoryTypeId ?? 0)", filterValue: "\(subCategory.subCategoryId ?? 1)", name: subCategoryType.subCategoryTypeName, parentTitle: subCategory.subCategoryName, isSelected: false)
                        filterValues.append(filterValue)
                    }
                    let filterType = FilterType(name: FilterLocalization.explore.text, type: "explore", isMultipleSelection: true, filterValues: filterValues)
                    filterTypes.append(filterType)
                    filter.filterTypes = filterTypes
                    filters.append(filter)
                }
            }
        }
        
        return filters
    }
}

extension OffersFilterUseCase {
    enum State {
        case error(message: String)
        case listFilters(filters: FilterDataModel)
        case values(filters: FilterUIModel)
    }
}
