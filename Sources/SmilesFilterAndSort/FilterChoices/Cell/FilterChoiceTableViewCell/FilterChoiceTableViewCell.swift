//
//  File.swift
//
//
//  Created by Muhammad Shayan Zahid on 31/10/2023.
//

import UIKit
import SmilesUtilities
import SmilesFontsManager
import SmilesOffers

final class FilterChoiceTableViewCell: UITableViewCell {
    // MARK: Outlets
    @IBOutlet weak var selectionButton: UIButton!
    @IBOutlet weak var choiceLabel: UILabel!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    @IBOutlet weak var separatorView: UIView!
    
    // MARK: Properties
    var filterChoice: FilterCellViewModel?
    var sortChoice: FilterDO?
    var choiceCellType: ChoiceCellType = .filter
    var filterSelected: ((_ filter: FilterCellViewModel?, _ isSelected: Bool) -> Void)?
    var sortSelected: ((_ sort: FilterDO?, _ isSelected: Bool) -> Void)?
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Actions
    @IBAction func selectionButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        configureSelectionStateUI(isSelected: sender.isSelected)
        
        if let filterChoice {
            filterSelected?(filterChoice, sender.isSelected)
        } else if let sortChoice {
            sortSelected?(sortChoice, sender.isSelected)
        }
    }
    
    // MARK: Methods
    private func setupUI() {
        choiceLabel.fontTextStyle = .smilesBody2
        choiceLabel.textColor = .black.withAlphaComponent(0.8)
        
        separatorView.backgroundColor = .filterRevampCellSeparatorColor
    }
    
    private func configureSelectionStateUI(isSelected: Bool) {
        if !isSelected {
            if choiceCellType == .filter {
                checkBoxImageView.image = UIImage(named: "checkbox-unselected-icon", in: .module, with: nil)
            } else {
                checkBoxImageView.image = UIImage(named: "unchecked-radio-icon", in: .module, with: nil)
            }
            
            choiceLabel.fontTextStyle = .smilesBody2
            choiceLabel.textColor = .black.withAlphaComponent(0.8)
        } else {
            if choiceCellType == .filter {
                checkBoxImageView.image = UIImage(named: "checkbox-selected-icon", in: .module, with: nil)
            } else {
                checkBoxImageView.image = UIImage(named: "checked-radio-icon", in: .module, with: nil)
            }
            
            choiceLabel.fontTextStyle = .smilesTitle1
            choiceLabel.textColor = .black
        }
    }
    
    func configureCell(with filter: FilterCellViewModel) {
        filterChoice = filter
        choiceCellType = .filter
        
        selectionButton.isSelected = filter.isSelected
        configureSelectionStateUI(isSelected: filter.isSelected)
        
        choiceLabel.text = filter.title
    }
    
    func configureCell(with sort: FilterDO) {
        sortChoice = sort
        choiceCellType = .sortBy
        
        configureSelectionStateUI(isSelected: sort.isSelected.asBoolOrFalse())
        
        choiceLabel.text = sort.name
    }
    
    func hideLineView(isHidden: Bool) {
        separatorView.isHidden = isHidden
    }
}
