import UIKit

final class ImprovedUIImageView: UIImageView {
    init(image: UIImage) {
        super.init(frame: .zero)
        self.image = image
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
