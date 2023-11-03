//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 31/10/2023.
//

import UIKit
import SmilesUtilities

extension FilterChoicesVC: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.allCases.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == TableSection.filterSearch.rawValue {
            return 1
        }
        
        return !isSearching ? filters.count : searchedFilters.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == TableSection.filterSearch.rawValue {
            guard let filterSearchCell = tableView.dequeueReusableCell(withIdentifier: "FilterSearchTVC", for: indexPath) as? FilterSearchTVC else { return UITableViewCell() }
            
            filterSearchCell.collectionData = filterTags
            filterSearchCell.configureCell(with: searchQuery)
            filterSearchCell.removeFilter = { [weak self] title in
                guard let self else { return }
                
                let filterToRemove = filterTags.first(where: { $0.title.asStringOrEmpty() == title.asStringOrEmpty() })
                self.configureFilterCollectionState(filter: filterToRemove, shouldAddFilter: false, sectionsToReload: [TableSection.filterSearch.rawValue, TableSection.filterChoice.rawValue])
            }
            
            filterSearchCell.searchQuery = { [weak self] query in
                guard let self else { return }
                
                if query?.isEmpty ?? false {
                    self.isSearching = false
                    self.searchedFilters.removeAll()
                } else {
                    self.isSearching = true
                    self.searchedFilters = self.filters.filter({ ($0.title.asStringOrEmpty()).lowercased().contains(query?.lowercased() ?? "") })
                }
                
                self.searchQuery = query
                self.tableView.reloadSections([TableSection.filterChoice.rawValue], with: .automatic)
            }
            
            return filterSearchCell
        }
        
        guard let filterChoiceCell = tableView.dequeueReusableCell(withIdentifier: "FilterChoiceTVC", for: indexPath) as? FilterChoiceTVC else { return UITableViewCell() }
        
        let filterChoice = !isSearching ? filters[indexPath.row] : searchedFilters[indexPath.row]
        
        filterChoiceCell.configureCell(with: filterChoice)
        filterChoiceCell.filterSelected = { [weak self] title, isSelected in
            guard let self else { return }
            self.configureFilterCollectionState(filter: title, shouldAddFilter: isSelected, sectionsToReload: [TableSection.filterSearch.rawValue])
            self.selectedFilter.send(indexPath)
        }
        
        if indexPath.row == (!isSearching ? (filters.endIndex - 1) : (searchedFilters.endIndex - 1)) {
            filterChoiceCell.separatorView.isHidden = true
        } else {
            filterChoiceCell.separatorView.isHidden = false
        }
        
        return filterChoiceCell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == TableSection.filterSearch.rawValue {
            return UITableView.automaticDimension
        }
        
        return 54.0
    }
}
