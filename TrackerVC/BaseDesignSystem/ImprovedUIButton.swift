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
        
        var text: String {
            return switch self {
            case .habit: "Привычка"
            case .irregular: "Нерегулярное событие"
            case .create: "Создать"
            case .ready: "Готово"
            case .cancel: "Отменить"
            case .add: "Добавить категорию"
            case .skip: "Вот это технологии"
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
