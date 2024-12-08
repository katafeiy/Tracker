import UIKit

final class OnboardingPageViewController: UIViewController {
    
    private let imageView: UIImageView
    private let messageView: UILabel
    private let skipAction: () -> Void
    
    // TODO: Добавить кнопку пропуска
    // Расставить все картинки, короче сверстать!!!
    
    init(image: UIImage, title: String, skipAction: @escaping ()->()) {
        imageView = UIImageView(image: image)
        self.messageView = UILabel()
        self.messageView.text = title
        self.skipAction = skipAction
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
