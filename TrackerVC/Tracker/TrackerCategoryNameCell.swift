import  UIKit


final class TrackerCategoryNameCell: UICollectionViewCell {
    
    static let headerIdentifier: String = "header"
    
    private let nameLabel: ImprovedUILabel = {
        ImprovedUILabel(fontSize: 19, weight: .bold, textColor: .ypBlackDay)
    }()
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubviews(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with name: String) {
        nameLabel.text = name
    }
}

