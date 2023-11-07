//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 30/10/2023.
//

import UIKit
import SmilesUtilities
import Combine

final public class FilterChoicesVC: UIViewController {
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
    var searchedFilters = [FilterCellViewModel]()
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
            
            return filter
        })
        
        isSearching = false
        selectedFilters.removeAll()
        searchedFilters.removeAll()
        searchQuery?.removeAll()
        
        tableView.reloadSections([TableSection.filterSearch.rawValue, TableSection.filterChoice.rawValue], with: .automatic)
    }
    
    // MARK: Methods
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerCellFromNib(FilterSearchTVC.self, withIdentifier: String(describing: FilterSearchTVC.self), bundle: .module)
        tableView.registerCellFromNib(FilterChoiceTVC.self, withIdentifier: String(describing: FilterChoiceTVC.self), bundle: .module)
    }
    
    func configureFilterCollectionState(filter: FilterCellViewModel?, isSelected: Bool, sectionsToReload: IndexSet) {
        if let filter, isSelected {
            selectedFilters.append(filter)
        } else {
            if !isSearching {
                if let filtersIndex = filters.firstIndex(where: { $0.filterValue == filter?.filterValue }) {
                    filters[filtersIndex].setUnselected()
                }
            } else {
                if let searchedFiltersIndex = searchedFilters.firstIndex(where: { $0.filterValue == filter?.filterValue }) {
                    searchedFilters[searchedFiltersIndex].setUnselected()
                }
            }
            
            selectedFilters.removeAll(where: { $0.filterValue == filter?.filterValue })
        }
        
        tableView.reloadSections(sectionsToReload, with: .automatic)
    }
}

extension FilterChoicesVC {
    static public func create() -> FilterChoicesVC {
        let viewController = FilterChoicesVC(nibName: String(describing: FilterChoicesVC.self), bundle: .module)
        return viewController
    }
}
