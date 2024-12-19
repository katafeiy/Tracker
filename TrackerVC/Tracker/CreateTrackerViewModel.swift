
final class CreateTrackerViewModel {
    
    weak var delegate: ProtocolNewTrackerEventViewControllerOutput?
    
    var isOpenNewTrackerEvent: ((Bool) -> Void)?
    
    func didOpenNewCreateTrackerTap(_ status: Bool) {
        isOpenNewTrackerEvent?(status)
    }
}
