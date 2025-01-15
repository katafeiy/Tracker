import UIKit

enum DaysOfWeek: Int, CaseIterable, Codable {
    
    case mon
    case tue
    case wed
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
        case .mon: Localization.DaysOfWeek.monday
        case .tue: Localization.DaysOfWeek.tuesday
        case .wed: Localization.DaysOfWeek.wednesday
        case .thu: Localization.DaysOfWeek.thursday
        case .fri: Localization.DaysOfWeek.friday
        case .sat: Localization.DaysOfWeek.saturday
        case .sun: Localization.DaysOfWeek.sunday
        }
    }
    
    var shortName: String {
        
        return switch self {
        case .mon: Localization.DaysOfWeek.mon
        case .tue: Localization.DaysOfWeek.tue
        case .wed: Localization.DaysOfWeek.wed
        case .thu: Localization.DaysOfWeek.thu
        case .fri: Localization.DaysOfWeek.fri
        case .sat: Localization.DaysOfWeek.sat
        case .sun: Localization.DaysOfWeek.sun
        }
    }
}


