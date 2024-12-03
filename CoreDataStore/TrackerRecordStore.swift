import UIKit
import CoreData

final class TrackerRecordStore: NSObject {
    
    private let context: NSManagedObjectContext
    
    override init() {
        self.context = CoreDataManager.shared.context
        super.init()
    }
    
    func getRecords() throws -> [TrackerRecord] {
        let request = TrackerRecordCoreData.fetchRequest()
        let trackerRecordsCoreData = try context.fetch(request)
        
        return trackerRecordsCoreData.compactMap({
            
            guard let id = $0.id, let date = $0.date else { return nil }
            
            return TrackerRecord(id: id, date: date)
            
        })
    }
    
    func addRecord(_ record: TrackerRecord) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.id = record.id
        trackerRecordCoreData.date = record.date
        try context.save()
    }
    
    func deleteRecord(_ record: TrackerRecord) throws {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@ AND date == %@", record.id as CVarArg, record.date as CVarArg)
        guard let trackerRecordCoreData = try context.fetch(request).first else { return }
        context.delete(trackerRecordCoreData)
        try context.save()
    }
}

