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
}

struct FilterSectionUIModel {
    let type: SortType
    var title: String?
    let isMultipleSelection: Bool
    var isFirstSection = false
    var items: [FilterCellViewModel] = []
}

struct FilterCellViewModel {
    var title: String?
    var isSelected = false
    var filterKey: String = ""
    var filterValue: String = ""
    
    mutating func toggle() {
        isSelected.toggle()
    }
    
    mutating func setUnselected() {
        isSelected = false
    }
}
