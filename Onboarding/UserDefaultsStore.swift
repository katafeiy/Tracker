import Foundation

final class UserDefaultsStore {
    
    private enum Keys: String {
        case isIndicatorSkipped
    }
    
    static var indicatorIsSkipped: Bool {
        get {
            UserDefaults.standard.bool(forKey: Keys.isIndicatorSkipped.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.isIndicatorSkipped.rawValue)
        }
    }
}
