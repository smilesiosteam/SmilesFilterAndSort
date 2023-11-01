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
        checkBoxImageView.image = !sender.isSelected ? UIImage(named: "checkbox-unselected-icon", in: .module, with: nil) : UIImage(named: "checkbox-selected-icon", in: .module, with: nil)
    }
    
    // MARK: Methods
    private func setupUI() {
        choiceLabel.fontTextStyle = .smilesBody2
        choiceLabel.textColor = .black.withAlphaComponent(0.8)
        
        separatorView.backgroundColor = .filterRevampCellSeparatorColor
    }
    
    func configureCell(with title: String) {
//        selectionButton.isSelected = false
//        checkBoxImageView.image = UIImage(named: "checkbox-unselected-icon", in: .module, with: nil)
        
        choiceLabel.text = title
    }
}
