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
    case wed = "Ср"
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
        case 4: self = .wed
        case 5: self = .thu
        case 6: self = .fri
        case 7: self = .sat
        case 1: self = .sun
        default: return nil
        }
    }
    
    var fullName: String {
        
        return switch self {
        case .mon: "Понедельник"
        case .tue: "Вторник"
        case .wed: "Среда"
        case .thu: "Четверг"
        case .fri: "Пятница"
        case .sat: "Суббота"
        case .sun: "Воскресенье"
        }
    }
}
