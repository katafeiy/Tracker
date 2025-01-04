import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier: String = "emojiCell"
    
    static let emojiCell: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱" , "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🏅", "🎸", "🏝️", "😪"]
    
    let emojiLabel: ImprovedUILabel = {
        ImprovedUILabel(fontSize: 32, weight: .bold, textColor: .ypWhite, cornerRadius: 16)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubviews(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emojiLabel.heightAnchor.constraint(equalToConstant: 52),
            emojiLabel.widthAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
