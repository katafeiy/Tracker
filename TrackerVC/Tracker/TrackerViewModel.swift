import Foundation

final class TrackerViewModel {
    
    var didUpdateVisibleData: (() -> Void)?
    var didUpdateTrackerStatus: (() -> Void)?
    var didUpdateSearching: (() -> Void)?
    
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = [] {
        didSet {
            UserDefaultsStore.trackerCompletedCount = completedTrackers.count
        }
    }
    private(set) var visibleCategories: [TrackerCategory] = []
    private var attachTracker: [Tracker] = []
    private(set) var attachVisibleTracker: [Tracker] = []
    private let trackerStore = TrackerStore()
    private let trackerCategoriesStore = TrackerCategoriesStore()
    private let trackerRecordStore = TrackerRecordStore()
    private(set) var searchVisibleCategories: [TrackerCategory] = []
    private(set) var filterType: FilterType = .allTrackers
    
    private var currentDate: Date?
    
    init() {
        trackerStore.delegate = self
        updateCurrentDate(Date())
        loadAttachCategories()
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
        
        attachVisibleTracker = []
        
        visibleCategories.forEach {
            
            let trackers = $0.trackerArray.compactMap({ tracker in
                
                if attachTracker.contains(where: { $0.id == tracker.id }) {
                    return tracker
                } else {
                    return nil
                }
            })
            attachVisibleTracker.append(contentsOf: trackers)
        }
        switch filterType {
        case .allTrackers: filterAllTracker()
        case .trackersToday: filterTrackerToday()
        case .itsCompleted: filterTrackerCompleted()
        case .itsUncompleted: filterTrackerNotCompleted()
        }
        didUpdateVisibleData?()
    }
    
    func updateFilterType(_ type: FilterType) {
        filterType = type
        updateVisibleData()
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
    
    private func loadAttachCategories() {
        attachTracker = (try? trackerStore.attachTrackers()) ?? []
    }
    
    func updateDeleteTracker(_ tracker: Tracker) {
        
        categories.removeAll{ $0.trackerArray.contains(where: { $0.id == tracker.id })}
        attachTracker.removeAll { $0.id == tracker.id }
        
        try? trackerStore.deleteTracker(tracker: tracker)
        
        updateArrayCategories()
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
        searchVisibleCategories = visibleCategories
    }
    
    func searchTracker(by searchText: String) {
        
        searchVisibleCategories = visibleCategories.map { category in
            let filteredTracker = category.trackerArray.filter { tracker in
                tracker.name.lowercased().contains(searchText.lowercased())
            }
            return TrackerCategory(name: category.name, trackerArray: filteredTracker)
            
        }.filter( { !$0.trackerArray.isEmpty })
        didUpdateSearching?()
    }
    
    func resetSearch() {
        searchVisibleCategories = visibleCategories
        didUpdateSearching?()
    }
    
    func isEnabledDate() -> Bool {
        (self.currentDate ?? Date()) <= Date()
    }
    
    func toggleTracker(_ tracker: Tracker) -> Bool {
        defer { didUpdateTrackerStatus?() }
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
    
    func didUpdateTracker(updatedTracker: Tracker, forCategory: String) {
        try? trackerStore.updateTracker(tracker: updatedTracker, category: forCategory)
    }
    
    func filterAllTracker() {
        
        guard let currentDate, let dayOfWeek = DaysOfWeek(date: currentDate) else {
            searchVisibleCategories = []
//            didUpdateSearching?()
            return
        }
        searchVisibleCategories = visibleCategories.map { category in
            let filteredTracker = category.trackerArray.filter { tracker in
                tracker.schedule.contains(dayOfWeek)
            }
            return TrackerCategory(name: category.name, trackerArray: filteredTracker )
        }.filter( { !$0.trackerArray.isEmpty })
//        didUpdateSearching?()
    }
    
    func filterTrackerToday() {
        
        guard let dayOfWeek = DaysOfWeek(date: Date()) else {
            searchVisibleCategories = []
//            didUpdateSearching?()
            return
        }
        searchVisibleCategories = visibleCategories.map { category in
            let filteredTracker = category.trackerArray.filter { tracker in
                tracker.schedule.contains(dayOfWeek)
            }
            return TrackerCategory(name: category.name, trackerArray: filteredTracker )
        }.filter( { !$0.trackerArray.isEmpty })
//        didUpdateSearching?()
    }
    
    func filterTrackerCompleted() {
        
        guard let currentDate else {
            searchVisibleCategories = []
//            didUpdateSearching?()
            return
        }
        searchVisibleCategories = visibleCategories.map{ category in
            let filteredTracker = category.trackerArray.filter{ tracker in
                completedTrackers.contains(where:{$0.id == tracker.id && $0.date == currentDate})
            }
            return TrackerCategory(name: category.name, trackerArray: filteredTracker)
            
        }.filter({ !$0.trackerArray.isEmpty })
//        didUpdateSearching?()
    }
    
    func filterTrackerNotCompleted() {
        guard let currentDate else {
            searchVisibleCategories = []
//            didUpdateSearching?()
            return}
        
        searchVisibleCategories = visibleCategories.map{ category in
            let filteredTracker = category.trackerArray.filter{ tracker in
                !completedTrackers.contains(where:{$0.id == tracker.id && $0.date == currentDate})
            }
            return TrackerCategory(name: category.name, trackerArray: filteredTracker)
        }.filter({ !$0.trackerArray.isEmpty })
//        didUpdateSearching?()
    }
}

extension TrackerViewModel: TrackerStoreDelegate {
    func didUpdateData() {
        updateArrayCategories()
    }
}
