import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier: String = "trackerCell"
    
    private var didPlusTap: (() -> Void)?
    
    private let viewCard: ImprovedUIView = {
        ImprovedUIView(cornerRadius: 10)
    }()
    
    private let labelEmoji: ImprovedUILabel = {
        ImprovedUILabel(fontSize: 12, weight: .medium, textColor: .ypBlackDay)
    }()
    
    private let labelName: ImprovedUILabel = {
        ImprovedUILabel(fontSize: 12,
                        weight: .medium,
                        textColor: .ypWhiteDay,
                        numberOfLines: 2,
                        textAlignment: .left)
    }()
    
    private let labelCountDay: ImprovedUILabel = {
        ImprovedUILabel(fontSize: 12, weight: .medium, textColor: .ypBlackDay)
    }()
    
    private let viewEmoji: UIView = {
        ImprovedUIView(backgroundColor: .ypWhiteDay.withAlphaComponent(0.3), cornerRadius: 12)
    }()
    
    private lazy var addButtonCompletion: UIButton = {
        let button = UIButton.systemButton(with: .plusTracker,
                                           target: self,
                                           action: #selector(didAddButtonTap))
        button.backgroundColor = .clear
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        button.tintColor = .ypWhiteDay
        button.imageView?.image = .plusTracker
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
        viewCard.backgroundColor = tracker.color.color
        labelCountDay.text =  "0 дней"
        addButtonCompletion.setImage(UIImage.plusButton, for: .normal)
        addButtonCompletion.backgroundColor = tracker.color.color
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
        
        contentView.addSubviews(viewCard, labelCountDay, addButtonCompletion)
        
        viewCard.addSubviews(labelName, viewEmoji)
        
        viewEmoji.addSubviews(labelEmoji)
        
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
