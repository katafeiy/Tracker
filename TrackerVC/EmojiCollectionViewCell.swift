import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    
    let emojiLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypWhiteDay
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 16
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(emojiLabel)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false

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
