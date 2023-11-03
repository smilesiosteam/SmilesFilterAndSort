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
    var searchedFilters = [FilterCellViewModel]()
    var filterTags = [FilterCellViewModel]()
//    private var original lFilters
    var selectedFilter = PassthroughSubject<IndexPath, Never>()
    
    // MARK: Lifecycle
//    public init() {
//        super.init(nibName: "FilterChoicesVC", bundle: .module)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func updateData(section: FilterSectionUIModel) {
        filters = section.items
        tableView.reloadData()
    }
    
    func clearSelectedFilters() {
        filters = filters.map({
            var filter = $0
            filter.setUnselected()
            
            return filter
        })
        
        isSearching = false
        searchedFilters.removeAll()
        filterTags.removeAll()
        
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
    
    func configureFilterCollectionState(filter: FilterCellViewModel?, shouldAddFilter: Bool, sectionsToReload: IndexSet) {
        if let filter, shouldAddFilter {
            self.filterTags.append(filter)
        } else {
            self.filterTags.removeAll(where: { $0.title == filter?.title })
        }
    
        tableView.reloadSections(sectionsToReload, with: .automatic)
    }
    
    func updateSearchedList(with id: String) {
        if let index = filters.firstIndex(where: { $0.title == id }) {
            filters[index].toggle()
//            tableView.reloadRows(at: [IndexPath(item: index, section: 1)], with: .fade)
            tableView.reloadData()
        }
        
        if let index = filterTags.firstIndex(where: { $0.title == id }) { 
            filterTags.remove(at: index)
//            tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .fade)
            tableView.reloadData()
        }
        
    }
}

extension FilterChoicesVC {
    static public func create() -> FilterChoicesVC {
        let viewController = FilterChoicesVC(nibName: String(describing: FilterChoicesVC.self), bundle: .module)
        return viewController
    }
}
