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
    private var isDummy = false
    
    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    // MARK: - Functions
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            UINib(nibName: TextCollectionViewCell.identifier, bundle: .module),
            forCellWithReuseIdentifier: TextCollectionViewCell.identifier)
        
        collectionView.register(
            UINib(nibName: RatingCollectionViewCell.identifier, bundle: .module),
            forCellWithReuseIdentifier: RatingCollectionViewCell.identifier)
        
        collectionView.register(
            UINib(nibName: FilterHeaderCollectionViewCell.identifier, bundle: .module),
            forSupplementaryViewOfKind: "header",
            withReuseIdentifier: FilterHeaderCollectionViewCell.identifier)
        
        collectionView.collectionViewLayout = layout.createLayout(sections: [])
    }
    
    func setupSections(filterModel: FilterUIModel, isDummy: Bool = false) {
        self.isDummy = isDummy
        manipulatedSections = filterModel.sections
        var list = filterModel
        sections = list.setUnselectedValues()
        reloadData()
    }
    
    func clearData() {
        manipulatedSections = sections
        reloadData()
    }
    
    private func reloadData() {
        guard !manipulatedSections.isEmpty, let _ = manipulatedSections.first?.isFirstSection else {
            return
        }
        manipulatedSections[0].isFirstSection = true
        collectionView.collectionViewLayout = layout.createLayout(sections: manipulatedSections)
        collectionView.reloadData()
    }
    
    private func configureShimmer(for cell: UIView) {
        if isDummy {
            cell.enableSkeleton()
            cell.showAnimatedSkeleton()
        } else {
            cell.hideSkeleton()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension SortViewController: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        manipulatedSections.count
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        manipulatedSections[safe: section]?.items.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = manipulatedSections[safe: indexPath.section] else {
            return UICollectionViewCell()
        }
        
        switch section.type {
        case .rating:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RatingCollectionViewCell.identifier, for: indexPath) as? RatingCollectionViewCell,
                    let item = section.items[safe: indexPath.row] else { return UICollectionViewCell() }
            configureShimmer(for: cell)
            cell.updateCell(with: item)
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionViewCell.identifier, for: indexPath) as? TextCollectionViewCell,
                    let item = section.items[safe: indexPath.row] else { return UICollectionViewCell() }
            configureShimmer(for: cell)
            cell.updateCell(with: item)
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: "header", withReuseIdentifier: FilterHeaderCollectionViewCell.identifier, for: indexPath) as? FilterHeaderCollectionViewCell else { return UICollectionReusableView() }
        let section = indexPath.section
        if let currentSection = manipulatedSections[safe: section] {
            currentSection.isFirstSection ? header.hideLineView() : header.showLineView()
            configureShimmer(for: header)
            header.setupHeader(with: currentSection.title)
        }
        return header
    }
}

extension SortViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isDummy {
            let section = indexPath.section
            guard let selectedSection = manipulatedSections[safe: section] else {
                return
            }
            
            if selectedSection.isMultipleSelection {
                setToToggleSelection(with: section, index: indexPath.row)
            } else {
                for i in 0..<selectedSection.items.count {
                    if i != indexPath.row {
                        manipulatedSections[section].items[i].setUnselected()
                    }
                }
                setToToggleSelection(with: section, index: indexPath.row)
            }
            selectedFilter.send(indexPath)
            DispatchQueue.main.async {
                collectionView.reloadSections(IndexSet(integer: section))
            }
        }
    }
    
    private func setToToggleSelection(with sectionIndex: Int, index: Int){
        if var section = manipulatedSections[safe: sectionIndex], var item = section.items[safe: index] {
            item.toggle()
            section.items[index] = item
            manipulatedSections[sectionIndex] = section
        }
    }
}

// MARK: - Create
extension SortViewController {
    static public func create() -> SortViewController {
        let viewController = SortViewController(nibName: String(describing: SortViewController.self), bundle: .module)
        return viewController
    }
}
