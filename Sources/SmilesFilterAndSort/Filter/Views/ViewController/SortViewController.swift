//
//  SortViewController.swift
//
//
//  Created by Ahmed Naguib on 30/10/2023.
//

import UIKit
import Combine
import SmilesUtilities

public final class SortViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    private let layout = FilterLayout()
    private var manipulatedSections: [FilterSectionUIModel] = []
    private var sections: [FilterSectionUIModel] = []
    var selectedFilter = PassthroughSubject<IndexPath, Never>()
    
    
    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    // MARK: - Functions
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: TextCollectionViewCell.identifier, bundle: .module), forCellWithReuseIdentifier: TextCollectionViewCell.identifier)
        
        collectionView.register(UINib(nibName: RatingCollectionViewCell.identifier, bundle: .module), forCellWithReuseIdentifier: RatingCollectionViewCell.identifier)
        
        collectionView.register(UINib(nibName: FilterHeaderCollectionViewCell.identifier, bundle: .module), forSupplementaryViewOfKind: "header", withReuseIdentifier: FilterHeaderCollectionViewCell.identifier)
        
        collectionView.collectionViewLayout = layout.createLayout(sections: [])
    }
    
    func setupSections(filterModel: FilterUIModel) {
        manipulatedSections = filterModel.sections
        sections = manipulatedSections
        reloadData()
    }
    
    func clearData() {
        manipulatedSections = sections
       reloadData()
    }
    
    private func reloadData() {
        !manipulatedSections.isEmpty ? manipulatedSections[0].isFirstSection = true : ()
        collectionView.collectionViewLayout = layout.createLayout(sections: manipulatedSections)
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension SortViewController: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return manipulatedSections.count
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        manipulatedSections[section].items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = manipulatedSections[indexPath.section]
        
        switch section.type {
        case .rating:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RatingCollectionViewCell.identifier, for: indexPath) as! RatingCollectionViewCell
            cell.updateCell(with: section.items[indexPath.row])
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionViewCell.identifier, for: indexPath) as! TextCollectionViewCell
            cell.updateCell(with: section.items[indexPath.row])
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: "header", withReuseIdentifier: FilterHeaderCollectionViewCell.identifier, for: indexPath) as! FilterHeaderCollectionViewCell
        let section = indexPath.section
        let currentSection = manipulatedSections[section]
        currentSection.isFirstSection ? header.hideLineView() : header.showLineView()
        header.setupHeader(with: currentSection.title)
        return header
    }
}

extension SortViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        let selectedSection = manipulatedSections[section]
        
        if selectedSection.isMultipleSelection {
            manipulatedSections[section].items[indexPath.row].toggle()
        } else {
            
            for i in 0..<selectedSection.items.count {
                
                i != indexPath.row ? manipulatedSections[section].items[i].setUnselected() : ()
            }
            manipulatedSections[section].items[indexPath.row].toggle()
        }
        selectedFilter.send(indexPath)
        collectionView.reloadSections(IndexSet(integer: section))
    }
}

// MARK: - Create
extension SortViewController {
    static public func create() -> SortViewController {
        let viewController = SortViewController(nibName: String(describing: SortViewController.self), bundle: .module)
        return viewController
    }
}
