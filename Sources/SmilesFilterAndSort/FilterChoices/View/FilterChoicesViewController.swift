//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 30/10/2023.
//

import UIKit
import SmilesUtilities
import Combine

final public class FilterChoicesViewController: UIViewController {
    enum TableSection: Int, CaseIterable {
        case filterSearch
        case filterChoice
    }
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    var isSearching = false
    var searchQuery: String?
    
    var filters = [FilterCellViewModel]()
    var selectedFilters = [FilterCellViewModel]()
    var selectedFilter = PassthroughSubject<IndexPath, Never>()
    
    // MARK: Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func updateData(section: FilterSectionUIModel) {
        filters = section.items
        selectedFilters = filters.filter({ $0.isSelected })
        tableView.reloadData()
    }
    
    func clearSelectedFilters() {
        filters = filters.map({
            var filter = $0
            filter.setUnselected()
            filter.setNotIsSearching()
            
            return filter
        })
        
        isSearching = false
        selectedFilters.removeAll()
        searchQuery?.removeAll()
        
        tableView.reloadData()
    }
    
    // MARK: Methods
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerCellFromNib(FilterSearchTableViewCell.self, withIdentifier: String(describing: FilterSearchTableViewCell.self), bundle: .module)
        tableView.registerCellFromNib(FilterChoiceTableViewCell.self, withIdentifier: String(describing: FilterChoiceTableViewCell.self), bundle: .module)
    }
    
    func configureFilterCollectionState(filter: FilterCellViewModel?, isSelected: Bool, sectionsToReload: IndexSet) {
        if let filter, isSelected {
            selectedFilters.append(filter)
        } else {
            if let filtersIndex = filters.firstIndex(where: { $0.filterValue == filter?.filterValue }) {
                filters[filtersIndex].setUnselected()
            }
 
            selectedFilters.removeAll(where: { $0.filterValue == filter?.filterValue })
        }
        
      tableView.reloadData()
    }
}

extension FilterChoicesViewController {
    static public func create() -> FilterChoicesViewController {
        let viewController = FilterChoicesViewController(nibName: String(describing: FilterChoicesViewController.self), bundle: .module)
        return viewController
    }
}
