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
    private var originalFiltersList: [FiltersList] = []
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
                self.originalFiltersList = values.filtersList ?? []
            }
            .store(in: &cancellable)
    }
    
    func clearData() {
        filtersList = originalFiltersList
        updateSelectedFilters()
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
            let countOfItems =  filtersList[filterIndex].filterTypes?[index.section].filterValues?.count ?? 0
            let isMultiSelection =  filtersList[filterIndex].filterTypes?[index.section].isMultipleSelection ?? false
            if isMultiSelection {
                filtersList[filterIndex].filterTypes?[index.section].filterValues?[index.row].toggle()
            } else {
                for i in 0..<countOfItems {
                    i != index.row ? filtersList[filterIndex].filterTypes?[index.section].filterValues?[i].setUnselected() : ()
                }
                filtersList[filterIndex].filterTypes?[index.section].filterValues?[index.row].toggle()
            }
            
        }
    }
    
    func updateCusines(with index: IndexPath) {
        if let filterIndex = useCase.getCusinesIndex() {
            filtersList[filterIndex].filterTypes?[0].filterValues?[index.row].toggle()
        }
    }
    
    func updateSelectedFilters() {
        countOfSelectedFilters = 0
        guard let filterIndex = useCase.getFilterIndex(), let cusinesIndex = useCase.getCusinesIndex() else {
            return
        }
        let filterTypes = filtersList[filterIndex].filterTypes ?? []
        let cusinesTypes = filtersList[cusinesIndex].filterTypes ?? []
        // Get Selected Filters
        filterTypes.forEach { item in
            let selected = (item.filterValues ?? []).filter({ $0.isSelected == true })
            countOfSelectedFilters += selected.count
            selectedFilter.append(contentsOf: selected)
        }
        
        cusinesTypes.forEach { item in
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

