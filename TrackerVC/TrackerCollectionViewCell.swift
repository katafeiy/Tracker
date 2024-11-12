import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    private let viewCard: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.backgroundColor = .ypBlue
        return view
    }()
    
    private let labelEmoji: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.text = "😂"
        label.textColor = .ypBlackDay
        return label
    }()
    
    private let labelName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .ypBlackDay
        label.text = "Здесь будет ваше описание"
        return label
    }()
    
    private let labelCountDay: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .ypBlackDay
        label.text = "3 дня"
        return label
    }()
    
    private let viewEmoji: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.backgroundColor = .yellow
        return view
    }()
    
    private lazy var addButtonCompletion: UIButton = {
        let button = UIButton.systemButton(with: .plusButton,
                                           target: self,
                                           action: #selector(didAddButtonTap))
        button.backgroundColor = .green
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        button.tintColor = .ypBlackDay
        return button
    }()
    
    @objc func didAddButtonTap() {
        
    }
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        [viewCard, labelCountDay, addButtonCompletion].forEach{$0.translatesAutoresizingMaskIntoConstraints = false; contentView.addSubview($0)}
        [labelName, viewEmoji].forEach{$0.translatesAutoresizingMaskIntoConstraints = false; viewCard.addSubview($0)}
        [labelEmoji].forEach{$0.translatesAutoresizingMaskIntoConstraints = false; viewEmoji.addSubview($0)}
        
        NSLayoutConstraint.activate([
            
            viewCard.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            viewCard.heightAnchor.constraint(equalToConstant: 90),
            viewCard.widthAnchor.constraint(equalToConstant: 167),
    
            addButtonCompletion.topAnchor.constraint(equalTo: viewCard.bottomAnchor, constant: 8),
            addButtonCompletion.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            addButtonCompletion.widthAnchor.constraint(equalToConstant: 34),
            addButtonCompletion.heightAnchor.constraint(equalToConstant: 34),
            
            labelCountDay.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            labelCountDay.topAnchor.constraint(equalTo: viewCard.bottomAnchor, constant: 16),
            labelCountDay.trailingAnchor.constraint(equalTo: addButtonCompletion.leadingAnchor, constant: 8),
            
            labelName.leadingAnchor.constraint(equalTo: viewCard.leadingAnchor, constant: 12),
            labelName.trailingAnchor.constraint(equalTo: viewCard.trailingAnchor, constant: -12),
            labelName.bottomAnchor.constraint(equalTo: viewCard.bottomAnchor, constant: 12),
            
            viewEmoji.leadingAnchor.constraint(equalTo: viewCard.leadingAnchor, constant: 12),
            viewEmoji.topAnchor.constraint(equalTo: viewCard.topAnchor, constant: 12),
            viewEmoji.heightAnchor.constraint(equalToConstant: 24),
            viewEmoji.widthAnchor.constraint(equalToConstant: 24),
            
            labelEmoji.centerXAnchor.constraint(equalTo: viewEmoji.centerXAnchor),
            labelEmoji.centerYAnchor.constraint(equalTo: viewEmoji.centerYAnchor)
            
         ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
