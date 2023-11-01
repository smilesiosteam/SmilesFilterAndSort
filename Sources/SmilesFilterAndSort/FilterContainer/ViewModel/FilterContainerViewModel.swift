//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 31/10/2023.
//

import Foundation

final class FilterContainerViewModel {
    
    var filters: [FilterSectionUIModel] = []
    var cuisines: [FilterSectionUIModel] = []
    private var filtersList: [FiltersList] = []
    
    func loadData() {
        do {
            
            
            if let jsonData = json.data(using: .utf8) {
                let filters = try JSONDecoder().decode(FilterDataModel.self, from: jsonData)
                
                handleResponse(filters.filtersList ?? [])
                
            }
            
        } catch {
            print(error)
        }
    }
    private func handleResponse(_ filtersList: [FiltersList]) {
        self.filtersList = filtersList
        if let filterIndex = getFilterIndex(filtersList) {
            configFilters(filtersList[filterIndex])
        }
        
        if let cusinesIndex = getCusinesIndex(filtersList) {
            configCusines(filtersList[cusinesIndex])
        }
    }
    
    private func getFilterIndex(_ filtersList: [FiltersList]) -> Int? {
        filtersList.firstIndex(where: { $0.type == FilterStrategy.filter.rawValue })
    }
    
    private func getCusinesIndex(_ filtersList: [FiltersList]) -> Int? {
        filtersList.firstIndex(where: { $0.type == FilterStrategy.cusines.rawValue })
    }
    
    private func configFilters(_ filters: FiltersList) {
        var filterUIModel = FilterUIModel()
        filterUIModel.title = filters.title
        mapFilterTypes(filters.filterTypes ?? [])
    }
    
    private func configCusines(_ cusines: FiltersList) {
        
    }
    
    private func mapFilterTypes(_ types: [FilterType]) {
        for type in types {
            let filter = configFilterType(type)
            filters.append(filter)
        }
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
            var section = FilterSectionUIModel(type: .dietary, isMultipleSelection: filterType.isMultipleSelection ?? false)
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
    
    func updateFilter(with index: IndexPath) {
        if let filterIndex = getFilterIndex(filtersList) {
            filtersList[filterIndex].filterTypes?[index.section].filterValues?[index.row].toggle()
        }
    }
    
    func getSelectedFilters() -> Int {
        var counter = 0
        var dic: [String: [String]] = [:]
        if let filterIndex = getFilterIndex(filtersList) {
            let filterTypes = filtersList[filterIndex].filterTypes ?? []
            var selectedFilter: [FilterValue] = []
            filterTypes.forEach { item in
                let selected = (item.filterValues ?? []).filter({ $0.isSelected == true })
                counter += selected.count
                selectedFilter.append(contentsOf: selected)
            }
            
            selectedFilter.forEach { item in
                if var ids = dic[item.filterKey ?? ""] {
                    ids.append(item.filterValue ?? "")
                    dic[item.filterKey ?? ""] = ids
                    
                } else {
                    dic[item.filterKey ?? ""] = [item.filterValue ?? ""]
                }
                
            }
            print(dic)
            return counter
            
        }
        
        return counter
    }
}


extension Optional where Wrapped == Bool {
    mutating func toggler() {
        self = self.map { !$0 }
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
