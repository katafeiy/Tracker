import UIKit

struct Tracker {
    
    let id: UUID
    let name: String
    let color: TrackerColors
    let emoji: String
    let schedule: Set<DaysOfWeek>
}


