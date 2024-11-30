import UIKit
import CoreData

final class TrackerStore: NSObject {
    
    private let context: NSManagedObjectContext
    
    override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not find AppDelegate")
        }
        self.context = appDelegate.persistentContainer.viewContext
        super.init()
    }
    
    
    func newTracker(tracker: Tracker, category: TrackerCategory) throws {
        
        let trackerCategoryCoreData = try getOrCreateCategory(category: category)
        
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
    
    private func getOrCreateCategory(category: TrackerCategory) throws -> TrackerCategoryCoreData  {
        
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", category.name)
        
        guard let trackerCategoryCoreData = try? context.fetch(request).first else {
            let categoryCoreData = TrackerCategoryCoreData(context: context)
            categoryCoreData.name = category.name
            return categoryCoreData
        }
        
        return trackerCategoryCoreData
    }
    
    func getAllTrackers() -> [Tracker] {
        
        
        
        return []
    }
}

