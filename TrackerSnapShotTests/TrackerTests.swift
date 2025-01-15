import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    
    func testViewController() {
        let vc = TrackerViewController(viewModel: TrackerViewModel())
        assertSnapshot(of: vc, as: .image)
    }
    
    func testViewControllerLight() {
        let vc = TrackerViewController(viewModel: TrackerViewModel())
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testViewControllerDark() {
        let vc = TrackerViewController(viewModel: TrackerViewModel())
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
}

