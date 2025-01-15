
enum AnalyticsEvent: String, CaseIterable {
    
    case click
    case open
    case close
    
    var event: String {
        return switch self {
        case .click: "click"
        case .open: "open"
        case .close: "close"
        }
    }
    
    var screen: String {
        return "Main"
    }
}

enum ClickAnalyticsEvent: String, CaseIterable {
    
    case addTrack
    case track
    case filter
    case edit
    case delete
    
    var item: String {
        return switch self {
        case .addTrack: "add_track"
        case .track: "track"
        case .filter: "filter"
        case .edit: "edit"
        case .delete: "delete"
        }
    }
}
