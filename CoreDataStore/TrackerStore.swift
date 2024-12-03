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
    
    
    func newTracker(tracker: Tracker, categoryName: String) throws {
        
        let trackerCategoryCoreData = try getOrCreateCategory(categoryName: categoryName)
        
        let trackerCoreData = TrackerCoreData(context: context)
    
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.color = tracker.color
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
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateData()
    }
}
