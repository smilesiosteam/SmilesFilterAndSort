//
//  File.swift
//
//
//  Created by Muhammad Shayan Zahid on 31/10/2023.
//

import UIKit
import SmilesUtilities
import SmilesFontsManager

final class FilterChoiceTVC: UITableViewCell {
    // MARK: Outlets
    @IBOutlet weak var selectionButton: UIButton!
    @IBOutlet weak var choiceLabel: UILabel!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    @IBOutlet weak var separatorView: UIView!
    
    // MARK: Properties
    var filterChoice: String?
    var filterSelected: ((_ title: String?, _ isSelected: Bool) -> Void)?
    
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
        
        filterSelected?(filterChoice, sender.isSelected)
    }
    
    // MARK: Methods
    private func setupUI() {
        choiceLabel.fontTextStyle = .smilesBody2
        choiceLabel.textColor = .black.withAlphaComponent(0.8)
        
        separatorView.backgroundColor = .filterRevampCellSeparatorColor
    }
    
    private func configureSelectionStateUI(isSelected: Bool) {
        if !isSelected {
            checkBoxImageView.image = UIImage(named: "checkbox-unselected-icon", in: .module, with: nil)
            choiceLabel.fontTextStyle = .smilesBody2
            choiceLabel.textColor = .black.withAlphaComponent(0.8)
        } else {
            checkBoxImageView.image = UIImage(named: "checkbox-selected-icon", in: .module, with: nil)
            choiceLabel.fontTextStyle = .smilesTitle1
            choiceLabel.textColor = .black
        }
    }
    
    func configureCell(with title: String, isSelected: Bool) {
        selectionButton.isSelected = isSelected
        
        configureSelectionStateUI(isSelected: isSelected)
        
        filterChoice = title
        choiceLabel.text = title
    }
}
