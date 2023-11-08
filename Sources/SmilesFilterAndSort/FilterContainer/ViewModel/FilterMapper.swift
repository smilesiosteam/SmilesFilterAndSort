//
//  File.swift
//
//
//  Created by Ahmed Naguib on 08/11/2023.
//

import Foundation

struct FilterMapper {
    static func configFilters(_ filters: FiltersList) -> FilterUIModel {
        var filterUIModel = FilterUIModel()
        filterUIModel.title = filters.title
        let sections = mapFilterTypes(filters.filterTypes ?? [])
        filterUIModel.sections = sections
        return filterUIModel
    }
    
    private static func mapFilterTypes(_ types: [FilterType]) -> [FilterSectionUIModel] {
        var filters: [FilterSectionUIModel] = []
        for type in types {
            let filter = configFilterType(type)
            filters.append(filter)
        }
        return filters
    }
    
    private static func configFilterType(_ filterType: FilterType) -> FilterSectionUIModel {
        
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
    
    private static func mapFilterValues(_ values: [FilterValue]) -> [FilterCellViewModel] {
        return values.map({ self.mapFilterValue($0) })
    }
    
    private static func mapFilterValue(_ value: FilterValue) -> FilterCellViewModel {
        var item = FilterCellViewModel(filterKey: value.filterKey ?? "", filterValue: value.filterValue ?? "")
        item.isSelected = value.isSelected ?? false
        item.title = value.name
        return item
    }
}
