import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier: String = "colorCell"
    
    let colorLabel: ImprovedUILabel = {
        ImprovedUILabel(fontSize: 32, weight: .bold, textColor: .ypWhiteDay, cornerRadius: 8)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubviews(colorLabel)
        
        NSLayoutConstraint.activate([
            colorLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorLabel.heightAnchor.constraint(equalToConstant: 40),
            colorLabel.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
