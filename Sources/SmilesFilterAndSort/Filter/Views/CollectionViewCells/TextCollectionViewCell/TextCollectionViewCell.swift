//
//  TextCollectionViewCell22.swift
//  
//
//  Created by Ahmed Naguib on 30/10/2023.
//

import UIKit
import SmilesFontsManager

final class TextCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    static let identifier = String(describing: TextCollectionViewCell.self)
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 8
        titleLabel.fontTextStyle = .smilesBody2
    }
    
    // MARK: - Functions
    func updateCell(with viewModel: FilterCellViewModel) {
        titleLabel.text = viewModel.title
        configSelectedItem()
        viewModel.isSelected ? configSelectedItem() : configUnSelectedItem()
    }
    
    private func configSelectedItem() {
        containerView.backgroundColor =  UIColor( red: 66/255, green: 76/255, blue:153/255, alpha: 0.2)
        containerView.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
    }
    
    private func configUnSelectedItem() {
        containerView.backgroundColor = .clear
        containerView.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
    }
}
