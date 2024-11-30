import UIKit

final class DaysOfWeekTransformer: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
       NSData.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        
        guard let value = value as? Set<DaysOfWeek> else { return nil }
        do {
            return try JSONEncoder().encode(value)
        } catch {
            print("Error encoding DaysOfWeek: \(error)")
            return nil
        }
        
    }
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        
        guard let value = value as? Data else { return nil }
        
        return try? JSONDecoder().decode(Set<DaysOfWeek>.self, from: value)
    }
    
    static func register() {
        ValueTransformer.setValueTransformer(DaysOfWeekTransformer(), forName: NSValueTransformerName(rawValue: String(describing: DaysOfWeekTransformer.self)))
    }
}
