import Foundation

enum StatisticEnum: String, CaseIterable {
    
    case bestPeriod
    case idealDays
    case trackersCompleted
    case averageValue
    
    var title: String {
        return switch self {
        case .bestPeriod: Localization.StatisticEnum.bestPeriod
        case .idealDays: Localization.StatisticEnum.idealsDays
        case .trackersCompleted: Localization.StatisticEnum.trackersCompleted
        case .averageValue: Localization.StatisticEnum.averageValue
        }
    }
}
