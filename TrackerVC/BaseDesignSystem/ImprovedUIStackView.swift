import UIKit

final class ImprovedUIStackView: UIStackView {
    
    init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis) {
        super.init(frame: .zero)
        self.axis = axis
        distribution = .fillEqually
        spacing = 16
        arrangedSubviews.forEach { self.addArrangedSubview($0) }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
