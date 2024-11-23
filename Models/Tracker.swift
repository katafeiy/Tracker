import UIKit

struct Tracker {
    
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: Set<DaysOfWeek>
}

enum DaysOfWeek: Int, CaseIterable {
    
    case mon
    case tue
    case wen
    case thu
    case fri
    case sat
    case sun
    
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
    
    var shortName: String {
        
        switch self {
        case .mon: return "Пн"
        case .tue: return "Вт"
        case .wen: return "Ср"
        case .thu: return "Чт"
        case .fri: return "Пт"
        case .sat: return "Сб"
        case .sun: return "Вс"
        }
    }
}

