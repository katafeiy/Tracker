import UIKit

final class ImprovedUIImageView: UIImageView {
    init(image: UIImage? = nil, contentMode: UIView.ContentMode = .scaleToFill) {
        super.init(frame: .zero)
        self.image = image
        self.contentMode = contentMode
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
