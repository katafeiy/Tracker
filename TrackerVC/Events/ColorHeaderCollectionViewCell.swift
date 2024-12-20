import UIKit

final class ColorHeaderCollectionViewCell: UICollectionViewCell {
    
    static let headerIdentifier: String = "colorHeader"
    
    let colorHeaderLabel: ImprovedUILabel = {
        ImprovedUILabel(fontSize: 19, weight: .bold, textColor: .ypBlackDay)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubviews(colorHeaderLabel)
        
        NSLayoutConstraint.activate([
            colorHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            colorHeaderLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
