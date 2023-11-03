//
//  File.swift
//
//
//  Created by Ahmed Naguib on 01/11/2023.
//

import Foundation
import Combine

protocol FilterContainerUseCaseType {
    func fetchFilters() -> AnyPublisher<FilterDataModel, Never>
    func getFilterIndex() -> Int?
    func getCusinesIndex() -> Int?
    var cusinesPublisher: AnyPublisher<FilterUIModel, Never> { get }
    var filterPublisher: AnyPublisher<FilterUIModel, Never> { get }
}

final class FilterContainerUseCase: FilterContainerUseCaseType {
    
    // MARK: - Properties
    private var filterSubject = PassthroughSubject<FilterUIModel, Never>()
    private var cusinesSubject = PassthroughSubject<FilterUIModel, Never>()
    private var filtersList: [FiltersList] = []
    var cusinesPublisher: AnyPublisher<FilterUIModel, Never> {
        cusinesSubject.eraseToAnyPublisher()
    }
    
    var filterPublisher: AnyPublisher<FilterUIModel, Never> {
        filterSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Functions
    func fetchFilters() -> AnyPublisher<FilterDataModel, Never> {
        
        let jsonData = json.data(using: .utf8)
        let filters = try! JSONDecoder().decode(FilterDataModel.self, from: jsonData!)
        filtersList = filters.filtersList ?? []
        handleResponse(filters.filtersList ?? [])
       
        return Just(filters).eraseToAnyPublisher()
    }
    
    private func handleResponse(_ filtersList: [FiltersList]) {
        if let filterIndex = getFilterIndex() {
            let filters = configFilters(filtersList[filterIndex])
            filterSubject.send(filters)
        }
        
        if let cusinesIndex = getCusinesIndex() {
            let cusines = configFilters(filtersList[cusinesIndex])
            cusinesSubject.send(cusines)
        }
    }
    
    func getFilterIndex() -> Int? {
        filtersList.firstIndex(where: { $0.type == FilterStrategy.filter.rawValue })
    }
    
    func getCusinesIndex() -> Int? {
        filtersList.firstIndex(where: { $0.type == FilterStrategy.cusines.rawValue })
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
            var section = FilterSectionUIModel(type: .explore, isMultipleSelection: filterType.isMultipleSelection ?? false)
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



let json = """
{
  "filtersList": [
    {
      "title": "Filter By",
      "type": "filter",
      "filterTypes": [
        {
          "name": "Explore",
          "type": "explore",
          "isMultipleSelection": true,
          "filterValues": [
            {
              "name": "NewlyAdded",
              "filterKey": "explore",
              "filterValue": "1",
              "parentTitle": "Explore",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            },
            {
              "name": "BMW ",
              "filterKey": "explore",
              "filterValue": "2",
              "parentTitle": "explore",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            },
            {
              "name": "KIa ",
              "filterKey": "explore",
              "filterValue": "2",
              "parentTitle": "explore",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            },
            {
              "name": "Buy one Get one threeee ",
              "filterKey": "explore",
              "filterValue": "2",
              "parentTitle": "explore",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            },
            {
              "name": "Buy one Get one tooooooo ",
              "filterKey": "explore",
              "filterValue": "2",
              "parentTitle": "explore",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            },
            {
              "name": "Buy one Get one ",
              "filterKey": "explore",
              "filterValue": "2",
              "parentTitle": "explore",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            },
            {
              "name": "Buy one Get one ",
              "filterKey": "explore",
              "filterValue": "2",
              "parentTitle": "explore",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            }
          ]
        },
        {
          "name": "Rating",
          "type": "rating",
          "isMultipleSelection": true,
          "filterValues": [
            {
              "name": "4.5+",
              "filterKey": "rating",
              "filterValue": "1",
              "parentTitle": "Rating",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            },
            {
              "name": "3.5+",
              "filterKey": "rating",
              "filterValue": "2",
              "parentTitle": "Rating",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            },
            {
              "name": "3.5+",
              "filterKey": "rating",
              "filterValue": "2",
              "parentTitle": "Rating",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            },
            {
              "name": "3.5+",
              "filterKey": "rating",
              "filterValue": "2",
              "parentTitle": "Rating",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            },
            {
              "name": "3.5+",
              "filterKey": "rating",
              "filterValue": "2",
              "parentTitle": "Rating",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            },
            {
              "name": "3.5+",
              "filterKey": "rating",
              "filterValue": "2",
              "parentTitle": "Rating",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            },
            {
              "name": "3.5+",
              "filterKey": "rating",
              "filterValue": "2",
              "parentTitle": "Rating",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            }
          ]
        },
        {
          "name": "Price",
          "type": "price",
          "isMultipleSelection": true,
          "filterValues": [
            {
              "name": "$",
              "filterKey": "price",
              "filterValue": "1",
              "parentTitle": "price",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            },
            {
              "name": "$$",
              "filterKey": "price",
              "filterValue": "2",
              "parentTitle": "price",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            },
            {
              "name": "$$$",
              "filterKey": "price",
              "filterValue": "3",
              "parentTitle": "price",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            },
            {
              "name": "$$$",
              "filterKey": "price",
              "filterValue": "3",
              "parentTitle": "price",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            },
            {
              "name": "$$$",
              "filterKey": "price",
              "filterValue": "3",
              "parentTitle": "price",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            },
            {
              "name": "$$$",
              "filterKey": "price",
              "filterValue": "3",
              "parentTitle": "price",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            },
            {
              "name": "$$$",
              "filterKey": "price",
              "filterValue": "3",
              "parentTitle": "price",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            }
          ]
        },
        {
          "name": "Dietery",
          "type": "dietery",
          "isMultipleSelection": true,
          "filterValues": [
            {
              "name": "4.5+",
              "filterKey": "vegeterian",
              "filterValue": "1",
              "parentTitle": "Dietery",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            },
            {
              "name": "3.5+",
              "filterKey": "Gluten Free",
              "filterValue": "2",
              "parentTitle": "Dietery",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            },
            {
              "name": "3.5+",
              "filterKey": "halal",
              "filterValue": "3",
              "parentTitle": "Dietery",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            },
            {
              "name": "3.5+",
              "filterKey": "halal",
              "filterValue": "3",
              "parentTitle": "Dietery",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            },
            {
              "name": "3.5+",
              "filterKey": "halal",
              "filterValue": "3",
              "parentTitle": "Dietery",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            },
            {
              "name": "3.5+",
              "filterKey": "halal",
              "filterValue": "3",
              "parentTitle": "Dietery",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            },
            {
              "name": "3.5+",
              "filterKey": "halal",
              "filterValue": "3",
              "parentTitle": "Dietery",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            }
          ]
        }
      ]
    },
    {
      "title": "Cusines",
      "type": "cusines",
      "filterTypes": [
        {
          "name": "Cusines",
          "isMultipleSelection": true,
          "filterValues": [
            {
              "name": "NewlyAdded",
              "filterKey": "explore",
              "filterValue": "1",
              "parentTitle": "Explore",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            },
            {
              "name": "Buy one Get one ",
              "filterKey": "explore",
              "filterValue": "2",
              "parentTitle": "explore",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            }
          ]
        }
      ]
    }
  ]
}
"""
