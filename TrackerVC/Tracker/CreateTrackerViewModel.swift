
final class CreateTrackerViewModel {
    
    var isOpenNewTrackerEvent: ((Bool) -> Void)?
    
    func didOpenNewCreateTrackerTap(_ status: Bool) {
        isOpenNewTrackerEvent?(status)
    }
}
