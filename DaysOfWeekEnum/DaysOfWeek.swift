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
        case .mon: mondayDOW
        case .tue: tuesdayDOW
        case .wed: wednesdayDOW
        case .thu: thursdayDOW
        case .fri: fridayDOW
        case .sat: saturdayDOW
        case .sun: sundayDOW
        }
    }
    
    var shortName: String {
        
        return switch self {
        case .mon: monDOW
        case .tue: tueDOW
        case .wed: wedDOW
        case .thu: thuDOW
        case .fri: friDOW
        case .sat: satDOW
        case .sun: sunDOW
        }
    }
}


