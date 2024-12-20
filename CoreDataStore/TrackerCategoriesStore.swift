import UIKit
import CoreData

final class TrackerCategoriesStore: NSObject {
    
    private let context: NSManagedObjectContext
    
    override init() {
        self.context = CoreDataManager.shared.context
        super.init()
    }
    
    func getCategories() throws -> [TrackerCategory] {
        
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        let categories = try context.fetch(request)
        print(categories)
        
        var result = [TrackerCategory]()
        
        for category in categories {
            guard let name = category.name, let trackersCoreData = category.trackers as? Set<TrackerCoreData> else { continue }
            
            let trackers = trackersCoreData.compactMap({ (trackerCoreData: TrackerCoreData) -> Tracker? in
                guard
                    let id = trackerCoreData.id,
                    let name = trackerCoreData.name,
                    let emoji = trackerCoreData.emoji,
                    let color = trackerCoreData.color as? UIColor,
                    let modelColor = TrackerColors(color: color),
                    let schedule = trackerCoreData.schedule as? Set<DaysOfWeek>
                else { return nil }
                let isHabit = trackerCoreData.isHabit
                print(id, name, emoji, schedule, modelColor, isHabit)
                return Tracker(id: id, isHabit: isHabit, name: name, color: modelColor, emoji: emoji, schedule: schedule)
            })
            result.append(TrackerCategory(name: name, trackerArray: trackers))
        }
        return result
    }
    
    func addCategoryName(_ name: String) throws {
        let newCategory = TrackerCategoryCoreData(context: context)
        newCategory.name = name
        newCategory.trackers = []
        try context.save()
        print(name)
    }
    
    func getCategoryNames() throws -> [String] {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        let categories = try context.fetch(request)
        return categories.compactMap({ $0.name })
    }
    
    func deleteCategory(_ name: String) throws {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        let categories = try context.fetch(request)
        categories.forEach({ context.delete($0) })
        try context.save()
    }
    
    func editCategoryName(_ oldName: String, newName: String) throws {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", oldName)
        let categories = try context.fetch(request)
        categories.forEach({ $0.name = newName })
        try context.save()
    }
}
