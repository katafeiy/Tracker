import UIKit
import CoreData

protocol TrackerStoreDelegate: AnyObject {
    func didUpdateData()
}

final class TrackerStore: NSObject {
    
    weak var delegate: TrackerStoreDelegate?
    
    private let context: NSManagedObjectContext
    private let fetchResultController: NSFetchedResultsController<TrackerCoreData>
    
    override init() {
        
        self.context = CoreDataManager.shared.context
        
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)]
        self.fetchResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
        
        fetchResultController.delegate = self
        try? fetchResultController.performFetch()
    }
    
    static func mapToTracker(trackerCoreData: TrackerCoreData) -> Tracker? {
        guard
            let id = trackerCoreData.id,
            let name = trackerCoreData.name,
            let emoji = trackerCoreData.emoji,
            let color = trackerCoreData.color as? UIColor,
            let modelColor = TrackerColors(color: color),
            let schedule = trackerCoreData.schedule as? Set<DaysOfWeek>
        else { return nil }
        let isHabit = trackerCoreData.isHabit
        return Tracker(id: id, isHabit: isHabit, name: name, color: modelColor, emoji: emoji, schedule: schedule)
    }
    
    func newTracker(tracker: Tracker, categoryName: String) throws {
        
        let trackerCategoryCoreData = try getOrCreateCategory(categoryName: categoryName)
        let trackerCoreData = TrackerCoreData(context: context)
        
        trackerCoreData.id = tracker.id
        trackerCoreData.isHabit = tracker.isHabit
        trackerCoreData.isPinned = false
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.color = tracker.color.color
        trackerCoreData.schedule = tracker.schedule as NSObject
        
        trackerCoreData.category = trackerCategoryCoreData
        trackerCategoryCoreData.addToTrackers(trackerCoreData)
        
        try context.save()
    }
    
    private func getOrCreateCategory(categoryName: String) throws -> TrackerCategoryCoreData  {
        
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", categoryName)
        
        guard let trackerCategoryCoreData = try? context.fetch(request).first else {
            let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
            trackerCategoryCoreData.name = categoryName
            return trackerCategoryCoreData
        }
        return trackerCategoryCoreData
    }
    
    func getAllTrackers() -> [Tracker] {
        return []
    }
    
    func toAttachCategory(categoryName: String) throws -> TrackerCategoryCoreData {
        let trackerCategoryCoreData = try getOrCreateCategory(categoryName: categoryName)
        trackerCategoryCoreData.name = "Закрепленные"
        return trackerCategoryCoreData
    }
    
    func updatePinnedTracker(tracker: Tracker, isPinned: Bool) throws {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        guard let trackerCoreData = try? context.fetch(request).first else { return }
        trackerCoreData.isPinned = isPinned
        try context.save()
    }
    
    func deleteTracker(tracker: Tracker) throws {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        guard let trackerCoreData = try? context.fetch(request).first else { return }
        context.delete(trackerCoreData)
        try context.save()
    }
    
    func attachTrackers() throws -> [Tracker]  {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "isPinned == true")
        let trackerCoreData = try context.fetch(request)
        return trackerCoreData.compactMap( { TrackerStore.mapToTracker(trackerCoreData: $0) } )
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateData()
    }
}
