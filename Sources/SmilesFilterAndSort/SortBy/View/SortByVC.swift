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
    // MARK: - Outlets
    @IBOutlet private weak var sortByTitleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var buttonView: UIView!
    @IBOutlet private weak var applyButton: UIButton! {
        didSet {
            applyButton.setTitle(FilterLocalization.apply.text, for: .normal)
            applyButton.fontTextStyle = .smilesTitle1
            applyButton.layer.cornerRadius = 24
        }
    }
    
    @IBOutlet weak var dismissButton: UIButton! {
        didSet {  dismissButton.setImage(UIImage(resource: .closeButton), for: .normal) }
    }
    
    // MARK: - Properties
    var sorts = [FilterDO]()
    weak var delegate: SelectedSortDelegate?
    var selectedSort: FilterDO?
    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        tableView.reloadData()
        buttonView.addShadowToSelf(offset: CGSize(width: 0, height: -1), color: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2), radius: 1.0, opacity: 5)
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
        selectedSort = sorts.filter({ $0.isSelected ?? false }).first
    }
}

extension SortByVC {
    static public func create() -> SortByVC {
        let viewController = SortByVC(nibName: String(describing: SortByVC.self), bundle: .module)
        return viewController
    }
}
