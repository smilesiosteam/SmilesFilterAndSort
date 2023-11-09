//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 09/11/2023.
//

import UIKit

extension SortByVC: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sorts.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sortCell = tableView.dequeueReusableCell(withIdentifier: "FilterChoiceTVC", for: indexPath) as? FilterChoiceTVC else { return UITableViewCell() }
        
        sortCell.configureCell(with: sorts[indexPath.row])
        sortCell.sortSelected = { [weak self] sort, isSelected in
            guard let self else { return }
            
        }
        
        return sortCell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.0
    }
}
