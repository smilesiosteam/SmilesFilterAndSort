//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 30/10/2023.
//

import UIKit
import SmilesUtilities
import SmilesFontsManager

final class FilterSearchTVC: UITableViewCell {
    // MARK: Outlets
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var collectionParentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    
    // MARK: Properties
    var collectionData: [FilterCellViewModel]? {
        didSet {
            if collectionData?.isEmpty ?? false {
                collectionParentView.isHidden = true
            } else {
                collectionParentView.isHidden = false
            }
            
            collectionView.reloadData()
        }
    }
    
    var removeFilter: ((_ filter: FilterCellViewModel?) -> Void)?
    var searchQuery: ((_ query: String?) -> Void)?
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupCollectionView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Actions
    @IBAction func searchTextFieldDidChange(_ sender: UITextField) {
        searchQuery?(sender.text)
    }
    
    // MARK: Methods
    private func setupUI() {
        searchView.addMaskedCorner(withMaskedCorner: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], cornerRadius: searchView.bounds.height / 2)
        searchView.addBorder(withBorderWidth: 1.0, borderColor: .black.withAlphaComponent(0.2))
        
        searchTextField.fontTextStyle = .smilesTitle1
        searchTextField.textColor = .black.withAlphaComponent(0.6)
        searchTextField.attributedPlaceholder = NSAttributedString(string: "\("Search".localizedString)...", attributes: [.font: UIFont.circularXXTTMediumFont(size: 16.0), .foregroundColor: UIColor.black.withAlphaComponent(0.6)])
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: String(describing: FilterChipCVC.self), bundle: .module), forCellWithReuseIdentifier: String(describing: FilterChipCVC.self))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = setupCollectionViewLayout()
    }
    
    private func setupCollectionViewLayout() ->  UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            let layoutSize = NSCollectionLayoutSize(
                widthDimension: .estimated(100),
                heightDimension: .absolute(32)
            )
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitems: [.init(layoutSize: layoutSize)])
            group.interItemSpacing = .fixed(8.0)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = .init(top: 0.0, leading: 16.0, bottom: 0, trailing: 16.0)
            section.interGroupSpacing = 8.0
            
            return section
        }
        
        return layout
    }
    
    func configureSearchBar(with searchQuery: String?) {
        searchTextField.text = searchQuery
    }
}

extension FilterSearchTVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let data = collectionData?[indexPath.row] {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterChipCVC", for: indexPath) as? FilterChipCVC else { return UICollectionViewCell() }
            
            cell.configureCell(with: data)
            cell.removeFilter = { [weak self] filter in
                guard let self else { return }
                self.removeFilter?(filter)
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}
