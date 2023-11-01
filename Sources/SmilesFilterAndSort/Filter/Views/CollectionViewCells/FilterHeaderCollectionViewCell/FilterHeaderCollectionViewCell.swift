//
//  FilterHeaderCollectionViewCell.swift
//
//
//  Created by Ahmed Naguib on 30/10/2023.
//

import UIKit

final class FilterHeaderCollectionViewCell: UICollectionReusableView {
    
    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
   
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var lineStack: UIStackView!
    
    // MARK: - Functions
    func setupHeader(with title: String?) {
        titleLabel.text = title
        lineView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    func hideLineView() {
        lineStack.isHidden = true
    }
    
    func showLineView() {
        lineStack.isHidden = false
    }
}
