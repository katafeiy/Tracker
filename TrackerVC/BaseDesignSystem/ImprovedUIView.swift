import UIKit

final class ImprovedUIView: UIView {
    
    init(backgroundColor: UIColor? = .clear,
         cornerRadius: CGFloat = 0,
         borderWidth: CGFloat = 0,
         borderColor: UIColor? = .none)
    {
        super.init(frame: .zero)
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        self.backgroundColor = backgroundColor
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
    }
}
