import UIKit

final class ImprovedUIScrollView: UIScrollView {
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        alwaysBounceVertical = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
