//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 31/10/2023.
//

import UIKit

extension FilterChoicesVC: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.allCases.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == TableSection.filterSearch.rawValue {
            return 1
        }
        
        return mockFilterChoices.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == TableSection.filterSearch.rawValue {
            guard let filterSearchCell = tableView.dequeueReusableCell(withIdentifier: "FilterSearchTVC", for: indexPath) as? FilterSearchTVC else { return UITableViewCell() }
            
            return filterSearchCell
        }
        
        guard let filterChoiceCell = tableView.dequeueReusableCell(withIdentifier: "FilterChoiceTVC", for: indexPath) as? FilterChoiceTVC else { return UITableViewCell() }
        
        filterChoiceCell.configureCell(with: mockFilterChoices[indexPath.row])
        return filterChoiceCell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == TableSection.filterSearch.rawValue {
            return UITableView.automaticDimension
        }
        
        return 54.0
    }
}