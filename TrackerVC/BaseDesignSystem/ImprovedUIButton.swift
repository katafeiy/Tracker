import UIKit

final class ImprovedUIButton: UIButton {
    
    enum buttonName {
        case habit
        case irregular
        case create
        case ready
        case cancel
        case add
        case skip
        case filter
        
        var text: String {
            return switch self {
            case .habit: Localization.ImprovedUIButton.itsHabit
            case .irregular: Localization.ImprovedUIButton.aIrregularEvent
            case .create: Localization.ImprovedUIButton.toCreate
            case .ready: Localization.ImprovedUIButton.itsReady
            case .cancel: Localization.ImprovedUIButton.itsCancel
            case .add: Localization.ImprovedUIButton.addCategory
            case .skip: Localization.ImprovedUIButton.skipToNextVC
            case .filter: Localization.ImprovedUIButton.itsFilter
            }
        }
    }
    
    init(title: buttonName,
         titleColor: UIColor,
         backgroundColor: UIColor = .clear,
         cornerRadius: CGFloat,
         fontSize: CGFloat,
         fontWeight: UIFont.Weight) {
        
        super.init(frame: .zero)
        setTitle(title.text, for: .normal)
        setTitleColor(titleColor, for: .normal)
        titleLabel?.font = .systemFont(ofSize: fontSize, weight: fontWeight)
        self.backgroundColor = backgroundColor
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
