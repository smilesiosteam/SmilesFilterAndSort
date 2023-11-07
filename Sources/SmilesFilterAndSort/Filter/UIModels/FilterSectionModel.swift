//
//  File.swift
//
//
//  Created by Ahmed Naguib on 31/10/2023.
//

import Foundation

struct FilterUIModel {
    var title: String?
    var sections: [FilterSectionUIModel] = []
    
    mutating func setUnselectedValues() -> [FilterSectionUIModel] {
        let count = sections.count
        for index in 0..<count {
            sections[index].setUnselectedValues()
        }
        
        return sections
    }
}

struct FilterSectionUIModel {
    var type: SortType = .explore
    var title: String?
    var isMultipleSelection: Bool = false
    var isFirstSection = false
    var items: [FilterCellViewModel] = []
    
    mutating func setUnselectedValues() {
        let count = items.count
        for index in 0..<count {
            items[index].setUnselected()
        }
    }
}

struct FilterCellViewModel {
    var title: String?
    var isSelected = false
    var filterKey: String = ""
    var filterValue: String = ""
    var isSearching = false
    
    mutating func toggle() {
        isSelected.toggle()
    }
    
    mutating func setUnselected() {
        isSelected = false
    }
    
    mutating func toggleSearching() {
        isSearching.toggle()
    }
    
    mutating func setNotIsSearching() {
        isSearching = false
    }
}
