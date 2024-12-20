import Foundation

final class NewTrackerEventViewModel {
    
    enum Errors: Error {
        case noRequiredData
    }

    var updatedCreatedTrackerStatus: ((Bool) -> Void)?
    
    private var nameCategory: String?
    private var nameTracker: String?
    private var trackerColor: TrackerColors?
    private var trackerEmoji: String?
    var isHabit: Bool
    
    
    private var selectedDays: Set<DaysOfWeek> = []
    
    init(isHabit: Bool) {
        self.isHabit = isHabit
        selectedDays = isHabit ? [] : Set(DaysOfWeek.allCases)
    }
    
    func createNewEvent() throws -> Tracker  {
        
        guard let nameTracker, let trackerColor, let trackerEmoji else {
            throw Errors.noRequiredData
        }
        
        let newTracker = Tracker(id: UUID(),
                                 isHabit: isHabit,
                                 name: nameTracker,
                                 color: trackerColor,
                                 emoji: trackerEmoji,
                                 schedule: selectedDays)
        return newTracker
    }
    
    func updateNameCategory(_ nameCategory: String) {
        self.nameCategory = nameCategory
        updatedCreatedTrackerStatus?(isCreatedTrackerValid())
    }
    
    func updateNameTracker(_ nameTracker: String?) {
        self.nameTracker = nameTracker
        updatedCreatedTrackerStatus?(isCreatedTrackerValid())
    }
    
    func updateTrackerColor(_ trackerColor: TrackerColors?) {
        self.trackerColor = trackerColor
        updatedCreatedTrackerStatus?(isCreatedTrackerValid())
    }
    
    func updateTrackerEmoji(_ emoji: String?) {
        self.trackerEmoji = emoji
        updatedCreatedTrackerStatus?(isCreatedTrackerValid())
    }

    func getNameCategory() throws -> String {
        guard let nameCategory else {
            throw Errors.noRequiredData
        }
        return nameCategory
    }
    
    func getSelectedDays() -> Set<DaysOfWeek> {
        return selectedDays
    }
    
    func updateSelectedDays(_ selectedDays: Set<DaysOfWeek>) {
        self.selectedDays = selectedDays
        updatedCreatedTrackerStatus?(isCreatedTrackerValid())
    }
    
    private func isCreatedTrackerValid() -> Bool {
        
        guard let nameTracker else { return false }
        
        return !nameTracker.isEmpty &&
        nameTracker.count <= 38 &&
        trackerColor != nil &&
        trackerEmoji != nil &&
        nameCategory != nil &&
        !selectedDays.isEmpty
    }
}

