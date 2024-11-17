//import  UIKit
//
//final class HabitViewCell: UITableViewCell {
//    
//    private let nameLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 17, weight: .regular)
//        label.textColor = .ypBlackDay
//        return label
//    }()
//    
//    private let subtitleLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 17, weight: .regular)
//        label.textColor = .ypGray
//        return label
//    }()
//    
//    private lazy var stackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [nameLabel, subtitleLabel])
//        stackView.axis = .vertical
//        stackView.spacing = 1
//        return stackView
//    }()
//    
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        [stackView].forEach{$0.translatesAutoresizingMaskIntoConstraints = false; contentView.addSubview($0)}
//        
//        NSLayoutConstraint.activate([
//            
//            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
//            
//        ])
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func configure(title: String, subtitle: String?) {
//        nameLabel.text = title
//        subtitleLabel.text = subtitle
//        if subtitleLabel.text != nil {
//            stackView.addArrangedSubview(subtitleLabel)
//        } else {
//            stackView.removeArrangedSubview(subtitleLabel)
//        }
//    }
//}
