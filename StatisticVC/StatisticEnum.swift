import Foundation

enum StatisticEnum: Int, CaseIterable {
    
    case bestPeriod
    case idealDays
    case trackersCompleted
    case averageValue
    
    static var count: [StatisticEnum: Int] = [:]
    
    var count: Int {
        get {
            StatisticEnum.count[self] ?? 0
        } set {
            StatisticEnum.count[self] = newValue
        }
    }
    
    var title: String {
        return switch self {
        case .bestPeriod: "Лучший период"
        case .idealDays: "Идиальные дни"
        case .trackersCompleted: "Трекеров завершено"
        case .averageValue: "Среднее значение"
        }
    }
    
    var view: ImprovedUIView {
        ImprovedUIView(
            backgroundColor: .ypWhite,
            cornerRadius: 16,
            borderWidth: 1,
            borderColor: .ypRed
        )
    }
    
    var countLabel: ImprovedUILabel {
        ImprovedUILabel(text: "\(count)",
                        fontSize: 34,
                        weight: .bold,
                        textColor: .ypBlack,
                        textAlignment: .left)
        
    }
    
    var titleLabel: ImprovedUILabel {
        ImprovedUILabel(text: title,
                        fontSize: 12,
                        weight: .medium,
                        textColor: .ypBlack,
                        textAlignment: .left)
        
    }
}
