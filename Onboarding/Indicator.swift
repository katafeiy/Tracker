import Foundation

final class Indicator {
    
    private enum Keys: String {
        case isSkipped
    }
    
    static var indicatorIsSkipped: Bool {
        get {
            UserDefaults.standard.bool(forKey: Keys.isSkipped.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.isSkipped.rawValue)
        }
    }
}
