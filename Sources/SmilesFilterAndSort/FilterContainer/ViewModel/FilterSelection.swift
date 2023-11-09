//
//  File.swift
//
//
//  Created by Ahmed Naguib on 08/11/2023.
//

import Foundation

extension FilterSelection {
    struct Dependency {
        var filtersList: [FiltersList] = []
        var selectedFilters: [FilterValue] = []
        var selectedCusines: FilterValue?
        var cusinesIndex: Int?
        var filterIndex: Int?
    }
}

class FilterSelection {
    
    private var filtersList: [FiltersList] = []
    private var selectedFilters: [FilterValue] = []
    private var selectedCusines: FilterValue?
    private var cusinesIndex: Int?
    private var filterIndex: Int?
    
    func getSelectedItems(dependency: Dependency) -> [FiltersList] {
        filtersList = dependency.filtersList
        selectedCusines = dependency.selectedCusines
        selectedFilters = dependency.selectedFilters
        cusinesIndex = dependency.cusinesIndex
        filterIndex = dependency.filterIndex
        updateSelectedFilters()
        setSelectedCuisine()
        return filtersList
    }
    
    private func updateSelectedFilters() {
        for item in selectedFilters {
            print(item.indexPath)
            guard let type = item.indexPath?.section else {
                return
            }
            switch type {
            case -1:
                processCusines(filterIndex: cusinesIndex, indexPath: item.indexPath)
                
            default:
                processFilter(filterIndex: filterIndex, indexPath: item.indexPath)
                break
            }
        }
        
        func processFilter(filterIndex: Int?, indexPath: IndexPath?) {
            guard let filterIndex,
                  let indexPath,
                  let _ = filtersList[safe: filterIndex]?.filterTypes?[safe: indexPath.section]?.filterValues?[safe: indexPath.row]
            else { return }
            filtersList[filterIndex].filterTypes?[indexPath.section].filterValues?[indexPath.row].setSelected()
            filtersList[filterIndex].filterTypes?[indexPath.section].filterValues?[indexPath.row].indexPath = indexPath
        }
        
        func processCusines(filterIndex: Int?, indexPath: IndexPath?) {
            guard let filterIndex,
                  let indexPath,
                  let _ = filtersList[safe: filterIndex]?.filterTypes?.first?.filterValues?[safe: indexPath.row]
            else { return }
            
            filtersList[filterIndex].filterTypes?[0].filterValues?[indexPath.row].setSelected()
            filtersList[filterIndex].filterTypes?[0].filterValues?[indexPath.row].indexPath = indexPath
        }
        
    }
    
    private func setSelectedCuisine() {
        guard let selectedCusines,
              let cuisineIndex = cusinesIndex,
              let values = filtersList[cuisineIndex].filterTypes?.first?.filterValues,
              let selectedIndex = values.firstIndex(where: { $0.filterKey ==  selectedCusines.filterKey && $0.filterValue == selectedCusines.filterValue })
        else {
            return
        }
        filtersList[cuisineIndex].filterTypes?[0].filterValues?[selectedIndex].setSelected()
        filtersList[cuisineIndex].filterTypes?[0].filterValues?[selectedIndex].indexPath = IndexPath(row: selectedIndex, section: -1)
        
    }
}
