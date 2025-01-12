import Foundation

final class NewTrackerEventViewModel {
    
    enum Errors: Error {
        case noRequiredData
    }
    
    var updatedCreatedTrackerStatus: ((Bool) -> Void)?
    
    private(set) var nameCategory: String?
    private(set) var nameTracker: String?
    private(set) var trackerColor: TrackerColors?
    private(set) var trackerEmoji: String?
    private(set) var selectedDays: Set<DaysOfWeek> = []
    private var editedTracker: Tracker?
    let countDay: Int
    let isEditing: Bool
    var isHabit: Bool
    
    
    init(isHabit: Bool, editedTracker: Tracker?, countDay: Int = 0) {
        self.isHabit = isHabit
        self.editedTracker = editedTracker
        selectedDays = isHabit ? [] : Set(DaysOfWeek.allCases)
        
        self.nameCategory = editedTracker?.name
        self.nameTracker = editedTracker?.name
        self.trackerColor = editedTracker?.color
        self.trackerEmoji = editedTracker?.emoji
        self.selectedDays = editedTracker?.schedule ?? []
        self.isEditing = editedTracker != nil
        self.countDay = countDay
    }
    
    func getEvent() throws -> Tracker  {
        
        guard let nameTracker, let trackerColor, let trackerEmoji else {
            throw Errors.noRequiredData
        }
        
        return Tracker(id: editedTracker?.id ?? UUID() ,
                       isHabit: isHabit,
                       name: nameTracker,
                       color: trackerColor,
                       emoji: trackerEmoji,
                       schedule: selectedDays)
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
        selectedDays
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
    
    func viewDidLoad() {
        updatedCreatedTrackerStatus?(isCreatedTrackerValid())
    }
}

