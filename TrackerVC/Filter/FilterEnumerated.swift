import Foundation

enum FilterType: String, CaseIterable {
    
    case allTrackers
    case trackersToday
    case itsCompleted
    case itsUncompleted
    
    var title: String {
        return switch self {
        case .allTrackers: Localization.FilterViewController.allTrackersFVC
        case .trackersToday: Localization.FilterViewController.trackersTodayFVC
        case .itsCompleted: Localization.FilterViewController.itsCompletedFVC
        case .itsUncompleted: Localization.FilterViewController.itsUncompletedFVC
        }
    }
}

