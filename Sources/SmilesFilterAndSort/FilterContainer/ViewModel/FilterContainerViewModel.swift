//
//  File.swift
//
//
//  Created by Ahmed Naguib on 31/10/2023.
//

import Foundation
import Combine

final class FilterContainerViewModel {
    
    // MARK: - Properties
    var filters: [FilterSectionUIModel] = []
    var cuisines: [FilterSectionUIModel] = []
    private var filtersList: [FiltersList] = []
    private var selectedFilter: [FilterValue] = []
    
    @Published var countOfSelectedFilters = 0
    private var cancellable = Set<AnyCancellable>()
    private let useCase: FilterContainerUseCaseType
    
    // MARK: - Init
    init(useCase: FilterContainerUseCaseType = FilterContainerUseCase()) {
        self.useCase = useCase
        bindFilters()
    }
    
    // MARK: - Functions
    func fetchFilters() {
        useCase.fetchFilters()
            .sink { [weak self] values in
                guard let self else {
                    return
                }
                self.filtersList = values.filtersList ?? []
            }
            .store(in: &cancellable)
    }
    
    private func bindFilters() {
        useCase.cusinesPublisher.sink { [weak self] values in
            guard let self else {
                return
            }
            self.cuisines = values.sections
        }.store(in: &cancellable)
        
        useCase.filterPublisher.sink { [weak self] values in
            guard let self else {
                return
            }
            self.filters = values.sections
        }.store(in: &cancellable)
    }
    
    func updateFilter(with index: IndexPath) {
        if let filterIndex = useCase.getFilterIndex() {
            filtersList[filterIndex].filterTypes?[index.section].filterValues?[index.row].toggle()
        }
    }
    
    func updateCusines(with index: IndexPath) {
        if let filterIndex = useCase.getCusinesIndex() {
            filtersList[filterIndex].filterTypes?[index.section].filterValues?[index.row].toggle()
        }
    }
    
    func updateSelectedFilters() {
        countOfSelectedFilters = 0
        guard let filterIndex = useCase.getFilterIndex() else {
            return
        }
        let filterTypes = filtersList[filterIndex].filterTypes ?? []
        
        // Get Selected Filters
        filterTypes.forEach { item in
            let selected = (item.filterValues ?? []).filter({ $0.isSelected == true })
            countOfSelectedFilters += selected.count
            selectedFilter.append(contentsOf: selected)
        }
    }
    
    func getFiltersDictionary() -> [String: [String]] {
        var filteredData: [String: [String]] = [:]
        selectedFilter.forEach { item in
            let key = item.filterKey ?? ""
            let value = item.filterValue ?? ""
            
            if var values = filteredData[key] {
                values.append(value)
                filteredData[key] = values // Update the values for existing key
            } else {
                filteredData[key] = [value] // Add new Key
            }
        }
        return filteredData
    }
}

