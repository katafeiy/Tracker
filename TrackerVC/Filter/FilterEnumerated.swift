import Foundation

enum FilterType: String, CaseIterable {
    
    case allTrackers
    case trackersToday
    case itsCompleted
    case itsUncompleted
    
    var title: String {
        return switch self {
        case .allTrackers: allTrackersFVC
        case .trackersToday: trackersTodayFVC
        case .itsCompleted: itsCompletedFVC
        case .itsUncompleted: itsUncompletedFVC
        }
    }
}

