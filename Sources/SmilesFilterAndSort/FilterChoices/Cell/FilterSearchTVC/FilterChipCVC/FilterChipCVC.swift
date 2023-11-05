//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 31/10/2023.
//

import UIKit
import SmilesUtilities
import SmilesFontsManager

final class FilterChipCVC: UICollectionViewCell {
    // MARK: Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: Properties
    var filter: FilterCellViewModel?
    var removeFilter: ((_ filter: FilterCellViewModel?) -> Void)?
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: Actions
    @IBAction func crossButtonTapped(_ sender: UIButton) {
        removeFilter?(filter)
    }
    
    // MARK: Methods
    private func setupUI() {
        containerView.backgroundColor = .appRevampFilterCountBGColor.withAlphaComponent(0.2)
        containerView.addMaskedCorner(withMaskedCorner: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], cornerRadius: 8.0)
        containerView.addBorder(withBorderWidth: 1.0, borderColor: .black.withAlphaComponent(0.5))
        
        titleLabel.textColor = .black
        titleLabel.fontTextStyle = .smilesTitle2
    }
    
    func configureCell(with filter: FilterCellViewModel?) {
        self.filter = filter
        titleLabel.text = filter?.title
    }
}
