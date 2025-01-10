import UIKit

final class ImprovedUIStackView: UIStackView {
    
    init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat = 16) {
        super.init(frame: .zero)
        self.axis = axis
        distribution = .fillEqually
        self.spacing = spacing
        arrangedSubviews.forEach { self.addArrangedSubview($0) }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
