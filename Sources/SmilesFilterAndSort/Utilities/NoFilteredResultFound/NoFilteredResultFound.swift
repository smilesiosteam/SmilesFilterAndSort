//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 07/11/2023.
//

import UIKit
import SmilesUtilities

public class NoFilteredResultFound: UIView {
    // MARK: Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emptyResultImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        containerView = view
    }
    
    // MARK: Methods
    func commonInit() {
        _ = Bundle.module.loadNibNamed("NoFilteredResultFound", owner: self, options: nil)?.first as? UIView
        addSubview(containerView)
        containerView.frame = bounds
        
        containerView.bindFrameToSuperviewBounds()
        
        titleLabel.fontTextStyle = .smilesHeadline3
        titleLabel.textColor = .black.withAlphaComponent(0.8)
        
        descriptionLabel.fontTextStyle = .smilesBody3
        descriptionLabel.textColor = .black.withAlphaComponent(0.4)
    }
    
    public func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: "NoFilteredResultFound", bundle: Bundle.module)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    public func setupView(iconName: String? = "empty-result-icon", title: String?, description: String?) {
        emptyResultImageView.image = UIImage(named: iconName.asStringOrEmpty())
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
