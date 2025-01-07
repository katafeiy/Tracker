import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testViewControllerSnapshot() {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
        
        assertSnapshot(of: vc, as: .image, record: true)
    }
}
