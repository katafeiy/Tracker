import Foundation

final class UserDefaultsStore {
    
    private enum Keys: String {
        case isIndicatorSkipped
        case bestPeriodCount
        case idealDaysCount
        case trackerCompletedCount
        case averageValueCount
        
    }
    
    static var indicatorIsSkipped: Bool {
        get {
            UserDefaults.standard.bool(forKey: Keys.isIndicatorSkipped.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.isIndicatorSkipped.rawValue)
        }
    }
    
    static var bestPeriodCount: Int {
        get {
            UserDefaults.standard.integer(forKey: Keys.bestPeriodCount.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.bestPeriodCount.rawValue)
        }
    }
    
    static var idealDaysCount: Int {
        get {
            UserDefaults.standard.integer(forKey: Keys.idealDaysCount.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.idealDaysCount.rawValue)
        }
    }
    
    static var trackerCompletedCount: Int {
        get {
            UserDefaults.standard.integer(forKey: Keys.trackerCompletedCount.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.trackerCompletedCount.rawValue)
            NotificationCenter.default.post(name: .userDefaultsDidChange, object: nil, userInfo: ["key": Keys.trackerCompletedCount.rawValue])
        }
    }
    
    static var averageValueCount: Int {
        get {
            UserDefaults.standard.integer(forKey: Keys.averageValueCount.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.averageValueCount.rawValue)
        }
    }
}

extension Notification.Name {
    static let userDefaultsDidChange = Notification.Name("userDefaultsDidChange")
}
