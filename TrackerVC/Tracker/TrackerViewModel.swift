import Foundation

final class TrackerViewModel {
    
    var didUpdateVisibleData: (() -> Void)?
    var didUpdateTrackerStatus: (() -> Void)?
    
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = [] {
        didSet {
            UserDefaultsStore.bestPeriodCount = calculateBestPeriod()
            UserDefaultsStore.idealDaysCount = calculateIdealsDays()
            UserDefaultsStore.trackerCompletedCount = completedTrackers.count
            UserDefaultsStore.averageValueCount = calculateAverageValue()
        }
    }
    private(set) var visibleCategories: [TrackerCategory] = []
    private(set) var searchVisibleCategories: [TrackerCategory] = []
    private var attachTracker: [Tracker] = []
    private(set) var attachVisibleTracker: [Tracker] = []
    private let trackerStore = TrackerStore()
    private let trackerCategoriesStore = TrackerCategoriesStore()
    private let trackerRecordStore = TrackerRecordStore()
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
    
    func searchTracker(by searchText: String) {
        
        searchVisibleCategories = visibleCategories.map { category in
            
            let filteredTracker = category.trackerArray.filter { tracker in
                tracker.name.lowercased().contains(searchText.lowercased())
            }
            return TrackerCategory(name: category.name, trackerArray: filteredTracker)
            
        }.filter{!$0.trackerArray.isEmpty}
        didUpdateVisibleData?()
    }
    
    func resetSearch() {
        searchVisibleCategories = visibleCategories
        didUpdateVisibleData?()
    }
    
    func filterAllTracker() {
        guard let currentDate, let dayOfWeek = DaysOfWeek(date: currentDate) else {
            searchVisibleCategories = []
            return
        }
        searchVisibleCategories = visibleCategories.map { category in
            let filteredTracker = category.trackerArray.filter { tracker in
                tracker.schedule.contains(dayOfWeek)
            }
            return TrackerCategory(name: category.name, trackerArray: filteredTracker )
        }.filter{ !$0.trackerArray.isEmpty }
    }
    
    func filterTrackerToday() {
        guard let dayOfWeek = DaysOfWeek(date: Date()) else {
            searchVisibleCategories = []
            return
        }
        searchVisibleCategories = visibleCategories.map { category in
            let filteredTracker = category.trackerArray.filter { tracker in
                tracker.schedule.contains(dayOfWeek)
            }
            return TrackerCategory(name: category.name, trackerArray: filteredTracker )
        }.filter{ !$0.trackerArray.isEmpty }
    }
    
    func filterTrackerCompleted() {
        guard let currentDate else {
            searchVisibleCategories = []
            return
        }
        searchVisibleCategories = visibleCategories.map{ category in
            let filteredTracker = category.trackerArray.filter{ tracker in
                completedTrackers.contains(where:{$0.id == tracker.id && $0.date == currentDate})
            }
            return TrackerCategory(name: category.name, trackerArray: filteredTracker)
        }.filter{ !$0.trackerArray.isEmpty }
    }
    
    func filterTrackerNotCompleted() {
        guard let currentDate else {
            searchVisibleCategories = []
            return
        }
        searchVisibleCategories = visibleCategories.map{ category in
            let filteredTracker = category.trackerArray.filter{ tracker in
                !completedTrackers.contains(where:{$0.id == tracker.id && $0.date == currentDate})
            }
            return TrackerCategory(name: category.name, trackerArray: filteredTracker)
        }.filter{ !$0.trackerArray.isEmpty }
    }
    
    func calculateAverageValue() -> Int {
        let dates = completedTrackers.map{ $0.date }
        let uniqueDates = Set(dates)
        guard !uniqueDates.isEmpty else { return 0 }
        return completedTrackers.count / uniqueDates.count
    }
    
    func calculateBestPeriod() -> Int {
        
        let completedDates = Set(completedTrackers.map { $0.date }).sorted()
        
        guard !completedDates.isEmpty else { return 0 }
        
        var maxStreak = 0
        var currentStreak = 1
        let calendar = Calendar.current
        
        for i in 1..<completedDates.count {
            let previousDate = completedDates[i - 1]
            let currentDate = completedDates[i]
            
            if let difference = calendar.dateComponents([.day], from: previousDate, to: currentDate).day {
                if difference == 1 {
                    currentStreak += 1
                    maxStreak = max(maxStreak, currentStreak)
                } else if difference > 1 {
                    currentStreak = 1
                }
            }
        }
        return max(maxStreak, currentStreak)
    }
    
    func calculateIdealsDays() -> Int {
        
        let calendar = Calendar.current
        var completedDays: [Date: Set<UUID>] = [:]

        for record in completedTrackers {
            let date = calendar.startOfDay(for: record.date)
            if completedDays[date] == nil {
                completedDays[date] = []
            }
            completedDays[date]?.insert(record.id)
        }
        
        var daysWithAllCompleted = 0
        
        for (date, completedTrackerIds) in completedDays {
            let trackersForDate = categories.flatMap { $0.trackerArray }.filter { tracker in
                if tracker.isHabit, let dayOfWeek = DaysOfWeek(date: date) {
                    return tracker.schedule.contains(dayOfWeek)
                }
                return !tracker.isHabit
            }
            let trackerIdsForDate = Set(trackersForDate.map { $0.id })
            if trackerIdsForDate.isSubset(of: completedTrackerIds) {
                daysWithAllCompleted += 1
            }
        }
        return daysWithAllCompleted
    }
}

extension TrackerViewModel: TrackerStoreDelegate {
    func didUpdateData() {
        updateArrayCategories()
    }
}
