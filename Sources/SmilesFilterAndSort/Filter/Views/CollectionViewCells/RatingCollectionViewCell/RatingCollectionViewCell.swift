//
//  RatingCollectionViewCell.swift
//  
//
//  Created by Ahmed Naguib on 30/10/2023.
//

import UIKit

final class RatingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var rateLabel: UILabel!
    @IBOutlet private weak var starImage: UIImageView!
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 8
    }
    
    // MARK: - Functions
    func updateCell(with viewModel: FilterCellViewModel) {
        rateLabel.text = viewModel.title
        viewModel.isSelected ? configSelectedItem() : configUnSelectedItem()
    }
    
    private func configSelectedItem() {
        containerView.backgroundColor = UIColor( red: 66/255, green: 76/255, blue:153/255, alpha: 0.2)
        containerView.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        starImage.tintColor = UIColor(red: 68 / 255, green: 76 / 255, blue: 148 / 255, alpha: 1)
        starImage.image = UIImage(systemName: "star.fill")
    }
    
    private func configUnSelectedItem() {
        containerView.backgroundColor = .clear
        containerView.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        starImage.image = UIImage(systemName: "star")
    }
}
