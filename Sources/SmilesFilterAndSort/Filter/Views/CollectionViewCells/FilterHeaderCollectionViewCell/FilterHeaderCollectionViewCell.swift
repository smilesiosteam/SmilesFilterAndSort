//
//  FilterHeaderCollectionViewCell.swift
//
//
//  Created by Ahmed Naguib on 30/10/2023.
//

import UIKit
import SmilesFontsManager
import SmilesUtilities

final class FilterHeaderCollectionViewCell: UICollectionReusableView {
    
    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var lineView: UIView!
    @IBOutlet private weak var lineStack: UIStackView!
    
    static let identifier = String(describing: FilterHeaderCollectionViewCell.self)
    
    // MARK: - Functions
    func setupHeader(with title: String?) {
        titleLabel.text = title
        titleLabel.fontTextStyle = .smilesHeadline3
        lineView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    func hideLineView() {
        lineStack.isHidden = true
    }
    
    func showLineView() {
        lineStack.isHidden = false
    }
}
