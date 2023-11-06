//
//  File.swift
//
//
//  Created by Ahmed Naguib on 30/10/2023.
//

import UIKit

final class FilterLayout {
    
    func createLayout(sections: [FilterSectionUIModel]) -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout{ [weak self] (index, _) -> NSCollectionLayoutSection? in
            return self?.createSections(index: index, sections: sections)
        }
        return layout
    }
    
    private func createSections(index: Int, sections: [FilterSectionUIModel]) -> NSCollectionLayoutSection? {
        let isFistSection = sections[index].isFirstSection
        return configLayoutSection(isFirstSection: isFistSection)
    }
    
    private func configLayoutSection(isFirstSection: Bool) -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .absolute(40)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: layoutSize.heightDimension
            ),
            subitems: [.init(layoutSize: layoutSize)]
        )
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
//      section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0) // 8 8
        section.interGroupSpacing = 14
        
        let headerHeight: CGFloat = isFirstSection ? 40 : 90
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(headerHeight))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
        section.boundarySupplementaryItems = [header]
        return section
    }
}
