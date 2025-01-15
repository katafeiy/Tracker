import UIKit

final class ImprovedUICollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 52, height: 52)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 18)
        
        super.init(frame: frame, collectionViewLayout: layout)
       
        backgroundColor = .clear
        isScrollEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
