import Foundation

enum StatisticEnum: String, CaseIterable {
    
    case bestPeriod
    case idealDays
    case trackersCompleted
    case averageValue
    
    var title: String {
        return switch self {
        case .bestPeriod: bestPeriodSE
        case .idealDays: idealsDaysSE
        case .trackersCompleted: trackersCompletedSE
        case .averageValue: averageValueSE
        }
    }
}
