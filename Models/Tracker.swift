import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: Set<DaysOfWeek>
}

enum DaysOfWeek: String, CaseIterable {
    case mon = "Пн"
    case tue = "Вт"
    case wen = "Ср"
    case thu = "Чт"
    case fri = "Пт"
    case sat = "Сб"
    case sun = "Вс"
    
    init?(date: Date) {
        
        var calendar = Calendar.current
        calendar.timeZone = .current
        
        switch calendar.component(.weekday, from: date) {
        case 2: self = .mon
        case 3: self = .tue
        case 4: self = .wen
        case 5: self = .thu
        case 6: self = .fri
        case 7: self = .sat
        case 1: self = .sun
        default: return nil
        }
    }
    
    var fullName: String {
        switch self {
        case .mon: return "Понедельник"
        case .tue: return "Вторник"
        case .wen: return "Среда"
        case .thu: return "Четверг"
        case .fri: return "Пятница"
        case .sat: return "Суббота"
        case .sun: return "Воскресенье"
        }
    }
}
