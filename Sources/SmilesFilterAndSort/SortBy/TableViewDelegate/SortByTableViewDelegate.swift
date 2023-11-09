//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 09/11/2023.
//

import UIKit

extension SortByViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sorts.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sortCell = tableView.dequeueReusableCell(withIdentifier: "FilterChoiceTableViewCell", for: indexPath) as? FilterChoiceTableViewCell else { return UITableViewCell() }
        
        sortCell.configureCell(with: sorts[indexPath.row])
        sortCell.sortSelected = { [weak self] sort, isSelected in
            guard let self else { return }
            self.setAllDataUnselected()
            self.selectedSort = sort
            sorts[indexPath.row].isSelected = true
            tableView.reloadData()
        }
        sorts.count == (indexPath.row + 1) ? sortCell.hideLineView(isHidden: true) : sortCell.hideLineView(isHidden: false)
        
        return sortCell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.0
    }
    
    private func setAllDataUnselected() {
        let count = sorts.count
        for index in 0..<count {
            sorts[index].isSelected = false
        }
    }
}
