import UIKit
import CoreData

final class TrackerCategorysStore: NSObject {
    
    private let context: NSManagedObjectContext
    
    override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not find AppDelegate")
        }
        self.context = appDelegate.persistentContainer.viewContext
        super.init()
    }
    
    func getCategories() throws -> [TrackerCategory] {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        let categories = try context.fetch(request)
        
        var result = [TrackerCategory]()
        
        for category in categories {
           
        }
        
        return result
    }
    
    private func getTrackersForCategories(_ categories: [TrackerCategory]) -> [Tracker] {
        
        return []
    }
}
