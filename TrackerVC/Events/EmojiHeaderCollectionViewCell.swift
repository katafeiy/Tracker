import UIKit

final class EmojiHeaderCollectionViewCell: UICollectionViewCell {
    
    static let headerIdentifier: String = "emojiHeader"
    
    let emojiHeaderLabel: ImprovedUILabel = {
        ImprovedUILabel(fontSize: 19, weight: .bold, textColor: .ypBlack)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
     
        contentView.addSubviews(emojiHeaderLabel)
        
        NSLayoutConstraint.activate([
            emojiHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            emojiHeaderLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
