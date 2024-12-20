
import Foundation

final class TrackerViewModel {
    
    var didUpdateVisibleData: (() -> Void)?
    
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private(set) var visibleCategories: [TrackerCategory] = []
    
    private let trackerStore = TrackerStore()
    private let trackerCategoriesStore = TrackerCategoriesStore()
    private let trackerRecordStore = TrackerRecordStore()
    
    private var currentDate: Date?
    
    init() {
        trackerStore.delegate = self
        updateCurrentDate(Date())
    }
    
    private func updateVisibleData() {
        
        guard let currentDate, let dayOfWeek = DaysOfWeek(date: currentDate) else { return }
        
        visibleCategories = []
        
        categories.forEach {
            let trackers = $0.trackerArray.filter({ tracker in
                
                let isHabit = tracker.isHabit
                let showIfIsHabit = isHabit && tracker.schedule.contains(dayOfWeek)
                let completedRecord = completedTrackers.first(where: {$0.id == tracker.id})
                let completedInCurrentDay: Bool
                let notCompleted: Bool
                if let completedRecord {
                    notCompleted = false
                    completedInCurrentDay = completedRecord.date == currentDate
                } else {
                    notCompleted = true
                    completedInCurrentDay = false
                }
                
                let showIfIsIrregularEven = !isHabit && (completedInCurrentDay || notCompleted)
                
                return showIfIsHabit || showIfIsIrregularEven
            })
            
            if !trackers.isEmpty {
                visibleCategories.append(.init(name: $0.name, trackerArray: trackers))
            }
        }
        didUpdateVisibleData?()
    }
    
    func updateCurrentDate(_ date: Date?) {
        guard let date else { return }
        var calendar = Calendar.current
        calendar.timeZone = (TimeZone.init(secondsFromGMT: 0) ?? .current)
        let components = calendar.dateComponents([.day, .month, .year], from: date)
        self.currentDate = calendar.date(from: components) ?? Date()
        updateVisibleData()
    }
    
    private func updateArrayCategories() {
        categories = (try? trackerCategoriesStore.getCategories()) ?? []
        updateVisibleData()
    }
    
    private func updateArrayCompletedTrackers() {
        completedTrackers = (try? trackerRecordStore.getRecords()) ?? []
    }
    
    func viewDidLoad() {
        updateArrayCompletedTrackers()
        updateArrayCategories()
    }
    
    func isEnabledDate() -> Bool {
        (self.currentDate ?? Date()) <= Date()
    }
    
    func toggleTracker(_ tracker: Tracker) -> Bool {
        
        if
            let record = completedTrackers.first(where:{ $0.id == tracker.id && $0.date == self.currentDate }) {
            completedTrackers.removeAll(where:{ $0.id == tracker.id && $0.date == self.currentDate })
            try? self.trackerRecordStore.deleteRecord(record)
            return false
            
        } else {
            
            let record = TrackerRecord(id: tracker.id , date: currentDate ?? Date())
            completedTrackers.append(record)
            
            try? self.trackerRecordStore.addRecord(record)
            return true
        }
    }
    
    func isTrackerExecuted(_ tracker: Tracker) -> Bool {
        let completed = completedTrackers.first(where:{$0.id == tracker.id && $0.date == self.currentDate}) != nil
        return completed
    }
    
    func countTrackerExecution(_ tracker: Tracker) -> Int {
        completedTrackers.filter({$0.id == tracker.id}).count
    }
    
    func didCreateTracker(newTracker: Tracker, forCategory: String) {
        try? trackerStore.newTracker(tracker: newTracker, categoryName: forCategory)
    }
}

extension TrackerViewModel: TrackerStoreDelegate {
    func didUpdateData() {
        updateArrayCategories()
    }
}
