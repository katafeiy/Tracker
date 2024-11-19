import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    private var didPlusTap: (() -> Void)?
    
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
        label.textColor = .ypWhiteDay
        label.text = "Здесь будет ваше описание"
        label.numberOfLines = 2
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
        let button = UIButton.systemButton(with: .plusTracker,
                                           target: self,
                                           action: #selector(didAddButtonTap))
        button.backgroundColor = .colorSelection1
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        button.tintColor = .ypWhiteDay
        return button
    }()
    
    func blockTap(isEnabled: Bool) {
        addButtonCompletion.isEnabled = isEnabled
    }
    
    @objc func didAddButtonTap() {
        didPlusTap?()
    }
    
    func configureCell(tracker: Tracker, didPlusTap: @escaping () -> Void) {
        self.didPlusTap = didPlusTap
        labelEmoji.text = tracker.emoji
        labelName.text = tracker.name
        viewCard.backgroundColor = tracker.color
        labelCountDay.text =  "0 дней"
        addButtonCompletion.setImage(UIImage.plusButton, for: .normal)
        
    }
    
    func configCompletion(counter: Int, isCompleted: Bool) {
        
        labelCountDay.text = correctLabelCountDayText(for: counter)
        addButtonCompletion.setImage(isCompleted ? UIImage.done : UIImage.plusButton, for: .normal)
    }
    
    func correctLabelCountDayText(for number: Int) -> String {
        
        let lastDigit = number.remainderReportingOverflow(dividingBy: 10).partialValue
        let lastTowDigit = number.remainderReportingOverflow(dividingBy: 100).partialValue
        
        if lastTowDigit >= 11 && lastTowDigit <= 19 {
            return "\(number) дней"
        }
        return switch lastDigit {
        case 1: "\(number) день"
        case 2...4: "\(number) дня"
        default: "\(number) дней"
        }
    }
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = .clear
        
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
            labelName.bottomAnchor.constraint(equalTo: viewCard.bottomAnchor, constant: -12),
            
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
