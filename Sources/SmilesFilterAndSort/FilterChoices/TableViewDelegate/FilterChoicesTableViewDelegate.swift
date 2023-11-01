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
        
        return !isSearching ? mockFilterChoices.count : filteredFilterChoices.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == TableSection.filterSearch.rawValue {
            guard let filterSearchCell = tableView.dequeueReusableCell(withIdentifier: "FilterSearchTVC", for: indexPath) as? FilterSearchTVC else { return UITableViewCell() }
            
            filterSearchCell.collectionData = mockFilterChips
            filterSearchCell.removeFilter = { [weak self] title in
                guard let self else { return }
                self.configureFilterCollectionState(filter: title, shouldAddFilter: false, sectionsToReload: [TableSection.filterSearch.rawValue, TableSection.filterChoice.rawValue])
            }
            
            filterSearchCell.searchQuery = { [weak self] query in
                guard let self else { return }
                
                if query?.isEmpty ?? false {
                    self.isSearching = false
                    self.filteredFilterChoices.removeAll()
                } else {
                    self.isSearching = true
                    self.filteredFilterChoices = self.mockFilterChoices.filter({ $0.lowercased().contains(query?.lowercased() ?? "") })
                }
                
                self.tableView.reloadSections([TableSection.filterChoice.rawValue], with: .automatic)
            }
            
            return filterSearchCell
        }
        
        guard let filterChoiceCell = tableView.dequeueReusableCell(withIdentifier: "FilterChoiceTVC", for: indexPath) as? FilterChoiceTVC else { return UITableViewCell() }
        
        let filterChoice = !isSearching ? mockFilterChoices[indexPath.row] : filteredFilterChoices[indexPath.row]
        let isSelected = mockFilterChips.contains(where: { $0 == filterChoice })
        
        filterChoiceCell.configureCell(with: filterChoice, isSelected: isSelected)
        filterChoiceCell.filterSelected = { [weak self] title, isSelected in
            guard let self else { return }
            self.configureFilterCollectionState(filter: title, shouldAddFilter: isSelected, sectionsToReload: [TableSection.filterSearch.rawValue])
        }
        
        if indexPath.row == (!isSearching ? (mockFilterChoices.endIndex - 1) : (filteredFilterChoices.endIndex - 1)) {
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
