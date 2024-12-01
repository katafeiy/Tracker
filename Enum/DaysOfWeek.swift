import UIKit

enum DaysOfWeek: Int, CaseIterable, Codable {
    
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
        
        return switch self {
        case .mon: "Понедельник"
        case .tue: "Вторник"
        case .wen: "Среда"
        case .thu: "Четверг"
        case .fri: "Пятница"
        case .sat: "Суббота"
        case .sun: "Воскресенье"
        }
    }
    
    var shortName: String {
        
        return switch self {
        case .mon: "Пн"
        case .tue: "Вт"
        case .wen: "Ср"
        case .thu: "Чт"
        case .fri: "Пт"
        case .sat: "Сб"
        case .sun: "Вс"
        }
    }
}


