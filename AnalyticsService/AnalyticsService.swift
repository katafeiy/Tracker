import Foundation
import YandexMobileMetrica

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
        case .edit: "adit"
        case .delete: "delete"
        }
    }
}

final class AnalyticsService {
    
    static func activate() {
        
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "7fcac901-df31-474c-804b-8b4d1f6d297d") else { return }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func report(event: AnalyticsEvent, parameters: [AnyHashable: Any]) {
        
        YMMYandexMetrica.reportEvent(event.event, parameters: parameters, onFailure: { error in
            print("Report event error: %@, \(error.localizedDescription)")
        })
    }
    
    func sendEvent(event: AnalyticsEvent, screen: AnalyticsEvent, item: ClickAnalyticsEvent? = nil) {
        var parameters: [String: Any] = [
            "event": event.event,
            "screen": screen.screen
        ]
        
        if let item = item {
            parameters["item"] = item.item
        }
        YMMYandexMetrica.reportEvent("custom_event", parameters: parameters, onFailure: { error in
            print("Report event error: %@, \(error.localizedDescription)")
        })
    }
}

