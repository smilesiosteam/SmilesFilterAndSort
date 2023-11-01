//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 30/10/2023.
//

import UIKit
import SmilesUtilities

final public class FilterChoicesVC: UIViewController {
    enum TableSection: Int, CaseIterable {
        case filterSearch
        case filterChoice
    }
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    var mockFilterChoices = ["American", "Arabic", "Indian", "Pakistani", "Armenian", "African", "Asian", "Bakery", "Cake", "Coffee", "Burger", "Pizza", "Sandwich", "Wrap", "Shawarma"]
    
    // MARK: Lifecycle
    public init() {
        super.init(nibName: "FilterChoicesVC", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    // MARK: Methods
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerCellFromNib(FilterSearchTVC.self, withIdentifier: String(describing: FilterSearchTVC.self), bundle: .module)
        tableView.registerCellFromNib(FilterChoiceTVC.self, withIdentifier: String(describing: FilterChoiceTVC.self), bundle: .module)
    }
}
