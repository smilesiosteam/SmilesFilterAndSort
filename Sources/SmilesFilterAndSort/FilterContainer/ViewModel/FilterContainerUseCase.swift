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
    private let previousResponse: Data?
    var statePublisher: AnyPublisher<State, Never> {
        return stateSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    init(repository: FilterRepositoryType, menuItemType: String?, previousResponse: Data?) {
        self.repository = repository
        self.menuItemType = menuItemType
        self.previousResponse = previousResponse
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
            self.stateSubject.send(.listFilters(filters: values))
            self.handleResponse(values.filtersList ?? [])
        } else {
            fetchFilters()
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
                self.stateSubject.send(.listFilters(filters: values))
                self.handleResponse(values.filtersList ?? [])
            }
            .store(in: &cancellable)
    }
    
    private func handleResponse(_ filtersList: [FiltersList]) {
        var filters: FilterUIModel = .init()
        var cusines: FilterUIModel = .init()
        
        if let filterIndex = getFilterIndex() {
            filters = configFilters(filtersList[filterIndex])
        }
        
        if let cusinesIndex = getCusinesIndex() {
            cusines = configFilters(filtersList[cusinesIndex])
        }
        
        stateSubject.send(.values(filters: filters, cusines: cusines))
    }
    
    func getFilterIndex() -> Int? {
        filtersList.firstIndex(where: { $0.type == FilterStrategy.filter(title: nil).text })
    }
    
    func getCusinesIndex() -> Int? {
        filtersList.firstIndex(where: { $0.type == FilterStrategy.cusines(title: nil).text })
    }
    
    private func configFilters(_ filters: FiltersList) -> FilterUIModel {
        var filterUIModel = FilterUIModel()
        filterUIModel.title = filters.title
        let sections = mapFilterTypes(filters.filterTypes ?? [])
        filterUIModel.sections = sections
        return filterUIModel
    }
    
    private func mapFilterTypes(_ types: [FilterType]) -> [FilterSectionUIModel] {
        var filters: [FilterSectionUIModel] = []
        for type in types {
            let filter = configFilterType(type)
            filters.append(filter)
        }
        
        return filters
    }
    
    private func configFilterType(_ filterType: FilterType) -> FilterSectionUIModel {
        
        let type = filterType.type ?? ""
        
        switch type {
        case SortType.explore.name:
            var section = FilterSectionUIModel(type: .explore, isMultipleSelection: filterType.isMultipleSelection ?? false)
            section.title = filterType.name
            section.items = mapFilterValues(filterType.filterValues ?? [])
            return section
        case SortType.price.name:
            var section = FilterSectionUIModel(type: .price, isMultipleSelection: filterType.isMultipleSelection ?? false)
            section.title = filterType.name
            section.items = mapFilterValues(filterType.filterValues ?? [])
            return section
        case SortType.rating.name:
            var section = FilterSectionUIModel(type: .rating, isMultipleSelection: filterType.isMultipleSelection ?? false)
            section.title = filterType.name
            section.items = mapFilterValues(filterType.filterValues ?? [])
            return section
        case SortType.dietary.name:
            var section = FilterSectionUIModel(type: .dietary, isMultipleSelection: filterType.isMultipleSelection ?? false)
            section.title = filterType.name
            section.items = mapFilterValues(filterType.filterValues ?? [])
            return section
        default:
            var section = FilterSectionUIModel(type: .custom(name: type), isMultipleSelection: filterType.isMultipleSelection ?? false)
            section.title = filterType.name
            section.items = mapFilterValues(filterType.filterValues ?? [])
            return section
        }
    }
    
    private func mapFilterValues(_ values: [FilterValue]) -> [FilterCellViewModel] {
        return values.map({ self.mapFilterValue($0) })
    }
    
    private func mapFilterValue(_ value: FilterValue) -> FilterCellViewModel {
        var item = FilterCellViewModel(filterKey: value.filterKey ?? "", filterValue: value.filterValue ?? "")
        item.isSelected = value.isSelected ?? false
        item.title = value.name
        return item
    }
}

extension FilterContainerUseCase {
    enum State {
        case error(message: String)
        case listFilters(filters: FilterDataModel)
        case values(filters: FilterUIModel, cusines: FilterUIModel)
    }
}
