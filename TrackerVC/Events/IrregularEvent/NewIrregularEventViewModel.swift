import Foundation

final class NewIrregularEventViewModel {
    
    var updatedCreatedTrackerStatus: ((Bool) -> Void)?
    
    private var nameCategory: String?
    private var nameTracker: String?
    private var trackerColor: TrackerColors?
    private var trackerEmoji: String?
    
    enum Errors: Error {
        case noRequiredData
    }
    
    func createNewIrregularEvent() throws -> Tracker  {
        
        guard let nameTracker, let trackerColor, let trackerEmoji else {
            throw Errors.noRequiredData
        }
        
        let newTracker = Tracker(id: UUID(),
                                 name: nameTracker,
                                 color: trackerColor,
                                 emoji: trackerEmoji,
                                 schedule: Set(DaysOfWeek.allCases))
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
    
    private func isCreatedTrackerValid() -> Bool {
        
        guard let nameTracker else { return false }
        
        return !nameTracker.isEmpty &&
        nameTracker.count <= 38 &&
        trackerColor != nil &&
        trackerEmoji != nil &&
        nameCategory != nil
    }
}

