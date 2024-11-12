import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: Set<DaysOfWeek>
    
}

enum DaysOfWeek: String {
    case mon
    case thu
    case wen
    case ths
    case fri
    case sat
    case sun
    
    init?(date: Date) {
        
        var calendar = Calendar.current
        calendar.timeZone = .current
        
        switch calendar.component(.weekday, from: date) {
        case 2: self = .mon
        case 3: self = .thu
        case 4: self = .wen
        case 5: self = .ths
        case 6: self = .fri
        case 7: self = .sat
        case 1: self = .sun
        default:
            return nil
        }
    }
}
