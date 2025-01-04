import UIKit

final class PinnedView: UICollectionView {
    
    init() {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(167),
                    heightDimension: .absolute(148)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 9)
            
            // group
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(148)
                ),
                subitem: item,
                count: 2
            )
            group.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)
            group.interItemSpacing = .fixed(10)
            
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

extension PinnedView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:TrackerCollectionViewCell.cellIdentifier,
                                                            for: indexPath) as? TrackerCollectionViewCell else { return UICollectionViewCell() }
        
        
        cell.configureCell(tracker: .init(id: .init(), isHabit: true, name: "hcdsjbvfj", color: .azure, emoji: "😇", schedule: []), didPlusTap: {})
        return cell
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerCategoryNameCell.headerIdentifier,
            for: indexPath
        ) as?  TrackerCategoryNameCell else { return UICollectionReusableView() }
        
        let title = "Закрепленные"
        headerView.configure(with: title)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: collectionView.frame.width, height: 30)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
}
