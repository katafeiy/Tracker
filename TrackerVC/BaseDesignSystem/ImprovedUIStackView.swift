import UIKit

final class ImprovedUIStackView: UIStackView {
    
    init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat = 16, distribution: UIStackView.Distribution = .fillEqually, radius: CGFloat = 0) {
        super.init(frame: .zero)
        self.axis = axis
        self.distribution = distribution
        self.spacing = spacing
        self.layer.cornerRadius = radius
        arrangedSubviews.forEach { self.addArrangedSubview($0) }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
