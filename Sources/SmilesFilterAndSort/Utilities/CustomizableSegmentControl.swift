//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 06/11/2023.
//


import UIKit

class CustomizableSegmentControl: UISegmentedControl {
    
    private(set) lazy var radius:CGFloat = bounds.height / 2
    
    /// Configure selected segment inset, can't be zero or size will error when click segment
    private var segmentInset: CGFloat = 0.1{
        didSet{
            if segmentInset == 0{
                segmentInset = 0.1
            }
        }
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        selectedSegmentIndex = 0
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func layoutSubviews(){
        super.layoutSubviews()
        self.backgroundColor = UIColor.black.withAlphaComponent(0.01)
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.withAlphaComponent(0.05).cgColor
        
        //MARK: - Configure Background Radius
        self.layer.cornerRadius = self.radius
        self.layer.masksToBounds = true

        //MARK: - Find selectedImageView
        let selectedImageViewIndex = numberOfSegments
        if let selectedImageView = subviews[selectedImageViewIndex] as? UIImageView {
            //MARK: - Configure selectedImageView Color
            selectedImageView.backgroundColor = .white
            selectedImageView.image = nil
            
            //MARK: - Configure selectedImageView Inset with SegmentControl
            selectedImageView.bounds = selectedImageView.bounds.insetBy(dx: 7, dy: 6)
//            selectedImageView.
            //MARK: - Configure selectedImageView cornerRadius
            selectedImageView.layer.masksToBounds = true
            selectedImageView.layer.cornerRadius = (bounds.height - 6) / 2
            
            selectedImageView.layer.removeAnimation(forKey: "SelectionBounds")
        }
    }
}
