//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 31/10/2023.
//

import UIKit
import SmilesUtilities

extension FilterChoicesViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.allCases.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == TableSection.filterSearch.rawValue {
            return 1
        }
        
        return !isSearching ? filters.filter({ !$0.isSearching }).count : filters.filter({ $0.isSearching }).count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == TableSection.filterSearch.rawValue {
            guard let filterSearchCell = tableView.dequeueReusableCell(withIdentifier: "FilterSearchTableViewCell", for: indexPath) as? FilterSearchTableViewCell else { return UITableViewCell() }
            
            filterSearchCell.collectionData = selectedFilters
            filterSearchCell.configureSearchBar(with: searchQuery)
            filterSearchCell.removeFilter = { [weak self] filter in
                guard let self else { return }
                
                self.configureFilterCollectionState(filter: filter, isSelected: false, sectionsToReload: [TableSection.filterSearch.rawValue, TableSection.filterChoice.rawValue])

                if let index = self.filters.firstIndex(where: { filter?.title == $0.title }) {
                    self.selectedFilter.send(IndexPath(row: index, section: indexPath.section))
                }
            }
            
            filterSearchCell.searchQuery = { [weak self] query in
                guard let self else { return }
                
                if query?.isEmpty ?? false {
                    self.isSearching = false
                    self.filters = self.filters.map({
                        var filter = $0
                        filter.setNotIsSearching()
                        
                        return filter
                    })
                } else {
                    self.isSearching = true
                    self.filters = self.filters.map({
                        var filter = $0
                        if $0.title?.lowercased().contains(query?.lowercased() ?? "") == true {
                            filter.isSearching = true
                        } else {
                            filter.setNotIsSearching()
                        }
                        
                        return filter
                    })
                }
                
                self.searchQuery = query
                self.tableView.reloadSections([TableSection.filterChoice.rawValue], with: .automatic)
            }
            
            return filterSearchCell
        }
        
        guard let filterChoiceCell = tableView.dequeueReusableCell(withIdentifier: "FilterChoiceTableViewCell", for: indexPath) as? FilterChoiceTableViewCell else { return UITableViewCell() }
        
        if let filterChoice = !isSearching ? filters.filter({ !$0.isSearching })[safe: indexPath.row] : filters.filter({ $0.isSearching })[safe: indexPath.row] {
            filterChoiceCell.configureCell(with: filterChoice)
        }
        
        
        filterChoiceCell.filterSelected = { [weak self] filter, isSelected in
            guard let self else { return }
            
            if let index = self.filters.firstIndex(where: { $0.filterValue == filter?.filterValue }) {
                self.filters[index].toggle()
            }
            
            self.configureFilterCollectionState(filter: filter, isSelected: isSelected, sectionsToReload: [TableSection.filterSearch.rawValue])

            if let index = self.filters.firstIndex(where: { filter?.title == $0.title }) {
                self.selectedFilter.send(IndexPath(row: index, section: indexPath.section))
            }
        }
        
        let filteredFilters = !isSearching ? filters : filters.filter({ $0.isSearching })
        if indexPath.row == (filteredFilters.endIndex - 1) {
            filterChoiceCell.hideLineView(isHidden: true)
        } else {
            filterChoiceCell.hideLineView(isHidden: false)
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
