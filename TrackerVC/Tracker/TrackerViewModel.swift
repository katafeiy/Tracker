
import Foundation

final class TrackerViewModel {
    
    var didUpdateVisibleData: (() -> Void)?
    
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private(set) var visibleCategories: [TrackerCategory] = []
    private(set) var attachTracker: [Tracker] = []
    private let trackerStore = TrackerStore()
    private let trackerCategoriesStore = TrackerCategoriesStore()
    private let trackerRecordStore = TrackerRecordStore()
    
    private var currentDate: Date?
    
    init() {
        trackerStore.delegate = self
        updateCurrentDate(Date())
        updateAttachCategories()
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
    
    func updateAttachCategories(_ tracker: Tracker)  {
        
        if attachTracker.contains(where: { $0.id == tracker.id }) {
            attachTracker.removeAll { $0.id == tracker.id }
            try? trackerStore.updatePinnedTracker(tracker: tracker, isPinned: false)
        } else {
            attachTracker.append(tracker)
            try? trackerStore.updatePinnedTracker(tracker: tracker, isPinned: true)
        }
        updateArrayCategories()
    }
    
    func isPinned(_ tracker: Tracker) -> Bool {
        attachTracker.contains(where: { $0.id == tracker.id })
    }
    
    func updateAttachCategories() {
        attachTracker = (try? trackerStore.attachTrackers()) ?? []
    }
    
    func updateDeleteTracker(_ tracker: Tracker) {
        
        visibleCategories.removeAll{ $0.trackerArray.contains(where: { $0.id == tracker.id })}
        try? trackerStore.deleteTracker(tracker: tracker)
        
        updateArrayCategories()
    }
    
    func updateEditTracker(_ tracker: Tracker) {
//        let tracker = visibleCategories[indexPath.section].trackerArray[indexPath.row]
        
    }
    
    func updateCurrentDate(_ date: Date?) {
        guard let date else { return }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: date)
        self.currentDate = calendar.date(from: components) ?? date
        print(currentDate ?? Date())
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
