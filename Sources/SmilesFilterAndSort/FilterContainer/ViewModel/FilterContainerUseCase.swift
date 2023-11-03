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


let json = """
{
  "extTransactionId": "9231554348196",
  "filterList": [
    {
      "title": "Filter By",
      "type": "filterby",
      "filterTypes": [
        {
          "name": "Explore",
          "isMultipleSelection": true,
          "type": "explore",
          "filterValues": [
            {
              "name": "Newly Added",
              "filterKey": "new_places",
              "filterValue": "1",
              "parentTitle": "new_places",
              "image": null,
              "smallImage": null
            },
            {
              "name": "Buy 1 Get 1",
              "filterKey": "bogo",
              "filterValue": "1",
              "parentTitle": "bogo",
              "image": null,
              "smallImage": null
            },
            {
              "name": "Discounts",
              "filterKey": "deals",
              "filterValue": "1",
              "parentTitle": "deals",
              "image": null,
              "smallImage": null
            }
          ]
        },
        {
          "name": "Rating",
          "isMultipleSelection": false,
          "type": "rating",
          "filterValues": [
            {
              "name": "4.5+",
              "filterKey": "ratings",
              "filterValue": "4.5",
              "parentTitle": "ratings",
              "image": null,
              "smallImage": null
            },
            {
              "name": "4.0+",
              "filterKey": "ratings",
              "filterValue": "4.0",
              "parentTitle": "ratings",
              "image": null,
              "smallImage": null
            },
            {
              "name": "3.5+",
              "filterKey": "ratings",
              "filterValue": "3.5",
              "parentTitle": "ratings",
              "image": null,
              "smallImage": null
            }
          ]
        },
        {
          "name": "Price per person",
          "isMultipleSelection": false,
          "type": "perperson",
          "filterValues": [
            {
              "name": "25 to 100",
              "filterKey": "cost",
              "filterValue": "25 - 100",
              "parentTitle": "cost",
              "image": null,
              "smallImage": null
            },
            {
              "name": "100 to 200",
              "filterKey": "cost",
              "filterValue": "100 - 200",
              "parentTitle": "cost",
              "image": null,
              "smallImage": null
            },
            {
              "name": "Above 200",
              "filterKey": "cost",
              "filterValue": "200 - 1000",
              "parentTitle": "cost",
              "image": null,
              "smallImage": null
            }
          ]
        },
        {
          "name": "Dietary",
          "isMultipleSelection": false,
          "type": "dietary",
          "filterValues": [
            {
              "name": "Vegetarian",
              "filterKey": "dietary",
              "filterValue": "1",
              "parentTitle": "dietary",
              "image": null,
              "smallImage": null
            },
            {
              "name": "Gluten Free",
              "filterKey": "dietary",
              "filterValue": "2",
              "parentTitle": "dietary",
              "image": null,
              "smallImage": null
            }
          ]
        }
      ]
    },
    {
      "title": "Cuisines",
      "type": "cuisines",
      "filterTypes": [
        {
          "name": "Cuisines",
          "isMultipleSelection": true,
          "type": "cuisines",
          "filterValues": [
            {
              "name": "Acai ",
              "filterKey": "cuisines",
              "filterValue": "161",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/161.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/161.jpg"
            },
            {
              "name": "Afghani",
              "filterKey": "cuisines",
              "filterValue": "71",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/71.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/71.jpg"
            },
            {
              "name": "African",
              "filterKey": "cuisines",
              "filterValue": "118",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/118.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/118.jpg"
            },
            {
              "name": "American",
              "filterKey": "cuisines",
              "filterValue": "81",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/81.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/81.jpg"
            },
            {
              "name": "Arabic",
              "filterKey": "cuisines",
              "filterValue": "30",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/30.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/30.jpg"
            },
            {
              "name": "Armenian",
              "filterKey": "cuisines",
              "filterValue": "88",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/88.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/88.jpg"
            },
            {
              "name": "Asian",
              "filterKey": "cuisines",
              "filterValue": "79",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/79.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/79.jpg"
            },
            {
              "name": "Australian",
              "filterKey": "cuisines",
              "filterValue": "92",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/92.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/92.jpg"
            },
            {
              "name": "Bakery",
              "filterKey": "cuisines",
              "filterValue": "101",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/101.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/101.jpg"
            },
            {
              "name": "Balkan",
              "filterKey": "cuisines",
              "filterValue": "128",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/128.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/128.jpg"
            },
            {
              "name": "Birthday Cake",
              "filterKey": "cuisines",
              "filterValue": "141",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/141.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/141.jpg"
            },
            {
              "name": "Biryani",
              "filterKey": "cuisines",
              "filterValue": "142",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/142.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/142.jpg"
            },
            {
              "name": "Brazilian",
              "filterKey": "cuisines",
              "filterValue": "151",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/151.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/151.jpg"
            },
            {
              "name": "Breakfast",
              "filterKey": "cuisines",
              "filterValue": "130",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/130.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/130.jpg"
            },
            {
              "name": "British",
              "filterKey": "cuisines",
              "filterValue": "48",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/48.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/48.jpg"
            },
            {
              "name": "British Indian",
              "filterKey": "cuisines",
              "filterValue": "102",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/102.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/102.jpg"
            },
            {
              "name": "Burger",
              "filterKey": "cuisines",
              "filterValue": "134",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/134.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/134.jpg"
            },
            {
              "name": "Cafe",
              "filterKey": "cuisines",
              "filterValue": "123",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/123.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/123.jpg"
            },
            {
              "name": "Cafeteria",
              "filterKey": "cuisines",
              "filterValue": "131",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/131.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/131.jpg"
            },
            {
              "name": "Canadian",
              "filterKey": "cuisines",
              "filterValue": "107",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/107.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/107.jpg"
            },
            {
              "name": "Chaat",
              "filterKey": "cuisines",
              "filterValue": "160",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/160.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/160.jpg"
            },
            {
              "name": "Chinese",
              "filterKey": "cuisines",
              "filterValue": "27",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/27.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/27.jpg"
            },
            {
              "name": "Coffee",
              "filterKey": "cuisines",
              "filterValue": "152",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/152.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/152.jpg"
            },
            {
              "name": "Confectionery",
              "filterKey": "cuisines",
              "filterValue": "20",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/20.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/20.jpg"
            },
            {
              "name": "Continental",
              "filterKey": "cuisines",
              "filterValue": "66",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/66.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/66.jpg"
            },
            {
              "name": "Desserts",
              "filterKey": "cuisines",
              "filterValue": "140",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/140.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/140.jpg"
            },
            {
              "name": "Dutch",
              "filterKey": "cuisines",
              "filterValue": "49",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/49.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/49.jpg"
            },
            {
              "name": "Egyptian",
              "filterKey": "cuisines",
              "filterValue": "82",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/82.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/82.jpg"
            },
            {
              "name": "Eid Offer",
              "filterKey": "cuisines",
              "filterValue": "150",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/150.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/150.jpg"
            },
            {
              "name": "Emirati",
              "filterKey": "cuisines",
              "filterValue": "105",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/105.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/105.jpg"
            },
            {
              "name": "English",
              "filterKey": "cuisines",
              "filterValue": "91",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/91.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/91.jpg"
            },
            {
              "name": "European",
              "filterKey": "cuisines",
              "filterValue": "7",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/7.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/7.jpg"
            },
            {
              "name": "Fast Food",
              "filterKey": "cuisines",
              "filterValue": "36",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/36.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/36.jpg"
            },
            {
              "name": "Filipino",
              "filterKey": "cuisines",
              "filterValue": "35",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/35.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/35.jpg"
            },
            {
              "name": "Flame-grilled",
              "filterKey": "cuisines",
              "filterValue": "146",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/146.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/146.jpg"
            },
            {
              "name": "French",
              "filterKey": "cuisines",
              "filterValue": "74",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/74.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/74.jpg"
            },
            {
              "name": "Fried Chicken",
              "filterKey": "cuisines",
              "filterValue": "149",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/149.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/149.jpg"
            },
            {
              "name": "German",
              "filterKey": "cuisines",
              "filterValue": "97",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/97.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/97.jpg"
            },
            {
              "name": "Gluten-Free",
              "filterKey": "cuisines",
              "filterValue": "153",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/153.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/153.jpg"
            },
            {
              "name": "Greek",
              "filterKey": "cuisines",
              "filterValue": "119",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/119.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/119.jpg"
            },
            {
              "name": "Grills",
              "filterKey": "cuisines",
              "filterValue": "148",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/148.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/148.jpg"
            },
            {
              "name": "Grocery",
              "filterKey": "cuisines",
              "filterValue": "132",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/132.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/132.jpg"
            },
            {
              "name": "Hawaiian",
              "filterKey": "cuisines",
              "filterValue": "126",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/126.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/126.jpg"
            },
            {
              "name": "Healthy Food",
              "filterKey": "cuisines",
              "filterValue": "53",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/53.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/53.jpg"
            },
            {
              "name": "Hot and Cold",
              "filterKey": "cuisines",
              "filterValue": "32",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/32.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/32.jpg"
            },
            {
              "name": "Ice Cream",
              "filterKey": "cuisines",
              "filterValue": "139",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/139.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/139.jpg"
            },
            {
              "name": "Iftar Meal",
              "filterKey": "cuisines",
              "filterValue": "143",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/143.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/143.jpg"
            },
            {
              "name": "Indian",
              "filterKey": "cuisines",
              "filterValue": "26",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/26.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/26.jpg"
            },
            {
              "name": "Indian Parsi",
              "filterKey": "cuisines",
              "filterValue": "95",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/95.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/95.jpg"
            },
            {
              "name": "Indian Vegetarian",
              "filterKey": "cuisines",
              "filterValue": "39",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/39.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/39.jpg"
            },
            {
              "name": "Indonesian",
              "filterKey": "cuisines",
              "filterValue": "24",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/24.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/24.jpg"
            },
            {
              "name": "International",
              "filterKey": "cuisines",
              "filterValue": "4",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/4.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/4.jpg"
            },
            {
              "name": "Iranian",
              "filterKey": "cuisines",
              "filterValue": "13",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/13.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/13.jpg"
            },
            {
              "name": "Iraqi",
              "filterKey": "cuisines",
              "filterValue": "124",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/124.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/124.jpg"
            },
            {
              "name": "Italian",
              "filterKey": "cuisines",
              "filterValue": "6",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/6.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/6.jpg"
            },
            {
              "name": "Japanese",
              "filterKey": "cuisines",
              "filterValue": "83",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/83.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/83.jpg"
            },
            {
              "name": "Jordanian",
              "filterKey": "cuisines",
              "filterValue": "110",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/110.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/110.jpg"
            },
            {
              "name": "Juices & Shakes ",
              "filterKey": "cuisines",
              "filterValue": "158",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/158.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/158.jpg"
            },
            {
              "name": "Kerala",
              "filterKey": "cuisines",
              "filterValue": "100",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/100.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/100.jpg"
            },
            {
              "name": "Korean",
              "filterKey": "cuisines",
              "filterValue": "84",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/84.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/84.jpg"
            },
            {
              "name": "Kuwaiti",
              "filterKey": "cuisines",
              "filterValue": "117",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/117.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/117.jpg"
            },
            {
              "name": "Lebanese",
              "filterKey": "cuisines",
              "filterValue": "17",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/17.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/17.jpg"
            },
            {
              "name": "Levant",
              "filterKey": "cuisines",
              "filterValue": "120",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/120.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/120.jpg"
            },
            {
              "name": "Levantine",
              "filterKey": "cuisines",
              "filterValue": "112",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/112.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/112.jpg"
            },
            {
              "name": "Malay",
              "filterKey": "cuisines",
              "filterValue": "87",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/87.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/87.jpg"
            },
            {
              "name": "Mandi",
              "filterKey": "cuisines",
              "filterValue": "157",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/157.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/157.jpg"
            },
            {
              "name": "Mauritius",
              "filterKey": "cuisines",
              "filterValue": "85",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/85.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/85.jpg"
            },
            {
              "name": "Mediterranean",
              "filterKey": "cuisines",
              "filterValue": "37",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/37.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/37.jpg"
            },
            {
              "name": "Mexican",
              "filterKey": "cuisines",
              "filterValue": "89",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/89.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/89.jpg"
            },
            {
              "name": "Middle Eastern",
              "filterKey": "cuisines",
              "filterValue": "78",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/78.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/78.jpg"
            },
            {
              "name": "Moroccan",
              "filterKey": "cuisines",
              "filterValue": "86",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/86.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/86.jpg"
            },
            {
              "name": "Myanmar (Burmese)",
              "filterKey": "cuisines",
              "filterValue": "90",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/90.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/90.jpg"
            },
            {
              "name": "Nepali",
              "filterKey": "cuisines",
              "filterValue": "127",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/127.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/127.jpg"
            },
            {
              "name": "North Indian",
              "filterKey": "cuisines",
              "filterValue": "122",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/122.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/122.jpg"
            },
            {
              "name": "Organic",
              "filterKey": "cuisines",
              "filterValue": "104",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/104.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/104.jpg"
            },
            {
              "name": "Oriental",
              "filterKey": "cuisines",
              "filterValue": "44",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/44.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/44.jpg"
            },
            {
              "name": "Pakistani",
              "filterKey": "cuisines",
              "filterValue": "31",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/31.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/31.jpg"
            },
            {
              "name": "Palestinian",
              "filterKey": "cuisines",
              "filterValue": "111",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/111.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/111.jpg"
            },
            {
              "name": "Pasta",
              "filterKey": "cuisines",
              "filterValue": "155",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/155.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/155.jpg"
            },
            {
              "name": "PERi-PERi",
              "filterKey": "cuisines",
              "filterValue": "147",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/147.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/147.jpg"
            },
            {
              "name": "Peruvian",
              "filterKey": "cuisines",
              "filterValue": "121",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/121.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/121.jpg"
            },
            {
              "name": "Pizza",
              "filterKey": "cuisines",
              "filterValue": "133",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/133.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/133.jpg"
            },
            {
              "name": "Portuguese",
              "filterKey": "cuisines",
              "filterValue": "43",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/43.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/43.jpg"
            },
            {
              "name": "Pure Veg ",
              "filterKey": "cuisines",
              "filterValue": "156",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/156.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/156.jpg"
            },
            {
              "name": "Russian",
              "filterKey": "cuisines",
              "filterValue": "73",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/73.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/73.jpg"
            },
            {
              "name": "Sadhya-Delivery",
              "filterKey": "cuisines",
              "filterValue": "163",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/163.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/163.jpg"
            },
            {
              "name": "Sadhya-Pick Up",
              "filterKey": "cuisines",
              "filterValue": "164",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/164.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/164.jpg"
            },
            {
              "name": "Salad ",
              "filterKey": "cuisines",
              "filterValue": "162",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/162.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/162.jpg"
            },
            {
              "name": "Sandwiches",
              "filterKey": "cuisines",
              "filterValue": "138",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/138.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/138.jpg"
            },
            {
              "name": "Saudi",
              "filterKey": "cuisines",
              "filterValue": "125",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/125.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/125.jpg"
            },
            {
              "name": "Scottish",
              "filterKey": "cuisines",
              "filterValue": "109",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/109.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/109.jpg"
            },
            {
              "name": "Seafood",
              "filterKey": "cuisines",
              "filterValue": "116",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/116.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/116.jpg"
            },
            {
              "name": "Serbian",
              "filterKey": "cuisines",
              "filterValue": "129",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/129.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/129.jpg"
            },
            {
              "name": "Shawarma",
              "filterKey": "cuisines",
              "filterValue": "136",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/136.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/136.jpg"
            },
            {
              "name": "Singaporean",
              "filterKey": "cuisines",
              "filterValue": "22",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/22.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/22.jpg"
            },
            {
              "name": "South African",
              "filterKey": "cuisines",
              "filterValue": "145",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/145.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/145.jpg"
            },
            {
              "name": "South Indian",
              "filterKey": "cuisines",
              "filterValue": "99",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/99.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/99.jpg"
            },
            {
              "name": "Spanish",
              "filterKey": "cuisines",
              "filterValue": "69",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/69.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/69.jpg"
            },
            {
              "name": "Sri Lankan",
              "filterKey": "cuisines",
              "filterValue": "103",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/103.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/103.jpg"
            },
            {
              "name": "Suhoor Meal",
              "filterKey": "cuisines",
              "filterValue": "144",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/144.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/144.jpg"
            },
            {
              "name": "Sushi",
              "filterKey": "cuisines",
              "filterValue": "135",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/135.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/135.jpg"
            },
            {
              "name": "Syrian",
              "filterKey": "cuisines",
              "filterValue": "75",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/75.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/75.jpg"
            },
            {
              "name": "Tea ",
              "filterKey": "cuisines",
              "filterValue": "159",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/159.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/159.jpg"
            },
            {
              "name": "Thai",
              "filterKey": "cuisines",
              "filterValue": "23",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/23.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/23.jpg"
            },
            {
              "name": "Turkish",
              "filterKey": "cuisines",
              "filterValue": "28",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/28.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/28.jpg"
            },
            {
              "name": "Vegetarian",
              "filterKey": "cuisines",
              "filterValue": "106",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/106.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/106.jpg"
            },
            {
              "name": "Vietnamese",
              "filterKey": "cuisines",
              "filterValue": "80",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/80.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/80.jpg"
            },
            {
              "name": "Yemeni",
              "filterKey": "cuisines",
              "filterValue": "29",
              "parentTitle": "cuisines",
              "image": "https://cdn.eateasily.com/cuisines/mamba/29.jpg",
              "smallImage": "https://cdn.eateasily.com/cuisines/mamba/64x64/29.jpg"
            }
          ]
        }
      ]
    }
  ]
}
"""

let json1 = """
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
