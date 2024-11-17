import  UIKit


final class CategoryNameCell: UICollectionViewCell {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .ypBlackDay
        return label
    }()

    override init (frame: CGRect) {
        super.init(frame: frame)
        
        [nameLabel].forEach{$0.translatesAutoresizingMaskIntoConstraints = false; contentView.addSubview($0)}
        
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

