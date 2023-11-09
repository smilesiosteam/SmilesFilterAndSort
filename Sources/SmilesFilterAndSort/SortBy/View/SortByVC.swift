//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 08/11/2023.
//

import UIKit
import SmilesOffers

public protocol SelectedSortDelegate: AnyObject {
    func didSetSort(sortBy: FilterDO)
}

final public class SortByVC: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var sortByTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var applyButtonTitle: UILabel!
    
    var sorts = [FilterDO]()
    weak var delegate: SelectedSortDelegate?
    var selectedSort: FilterDO?
    
    // MARK: Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Actions
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss()
    }
    
    @IBAction func applyButtonTapped(_ sender: UIButton) {
        delegate?.didSetSort(sortBy: selectedSort ?? .init())
        dismiss()
    }
    
    // MARK: Methods
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerCellFromNib(FilterChoiceTVC.self, withIdentifier: String(describing: FilterChoiceTVC.self), bundle: .module)
    }
    
    func updateData(sorts: [FilterDO]) {
        self.sorts = sorts
        
        tableView.reloadData()
    }
}

extension SortByVC {
    static public func create() -> SortByVC {
        let viewController = SortByVC(nibName: String(describing: SortByVC.self), bundle: .module)
        return viewController
    }
}
