//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 08/11/2023.
//

import UIKit

public class NoFilteredResultFoundTVC: UITableViewCell {
    // MARK: Outlets
    @IBOutlet weak var noFilteredResultFoundView: NoFilteredResultFound!
    
    // MARK: Properties
    public static let module = Bundle.module
    
    // MARK: Lifecycle
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Methods
    public func configureCell(with data: NoFilteredResultCellModel) {
        noFilteredResultFoundView.setupView(with: data)
    }
}
