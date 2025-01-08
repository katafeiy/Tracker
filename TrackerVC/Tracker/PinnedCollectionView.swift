import UIKit

final class PinnedCollectionView: UICollectionView {
    
    init() {
        
        let layout = UICollectionViewCompositionalLayout { _, _ in
            
//            let itemWidth = (UIScreen.main.bounds.width - 16 * 2 - 9) / 2
            
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(148)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 9)
            
            // group
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.95),
                    heightDimension: .absolute(148)
                ),
                subitem: item,
                count: 2
            )
            
            group.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)
            
            // section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: -12, leading: 16, bottom: 0, trailing: 16)
            
            // header
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                    heightDimension: .absolute(30))
            
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                     elementKind: UICollectionView.elementKindSectionHeader,
                                                                     alignment: .topLeading)
            section.boundarySupplementaryItems = [header]
            
            // return
            return section
        }
        super.init(frame: .zero, collectionViewLayout: layout)
        
        register(
            TrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackerCollectionViewCell.cellIdentifier
        )
        register(
            TrackerCategoryNameCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader ,
            withReuseIdentifier: TrackerCategoryNameCell.headerIdentifier
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
