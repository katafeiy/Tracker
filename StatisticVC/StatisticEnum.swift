import Foundation

enum StatisticEnum: String, CaseIterable {
    
    case bestPeriod
    case idealDays
    case trackersCompleted
    case averageValue
    
    var title: String {
        return switch self {
        case .bestPeriod: "Лучший период"
        case .idealDays: "Идиальные дни"
        case .trackersCompleted: "Трекеров завершено"
        case .averageValue: "Среднее значение"
        }
    }
}
