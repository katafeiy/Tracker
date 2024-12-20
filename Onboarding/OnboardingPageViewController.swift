import UIKit

final class OnboardingPageViewController: UIViewController {
    
    private let skipAction: () -> Void
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var messageView: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .ypBlackDay
        label.textAlignment = .center
        return label
    }()

    private lazy var buttonSkip: ImprovedUIButton = {
        let button = ImprovedUIButton(title: .skip,
                                      titleColor: .ypWhiteDay,
                                      backgroundColor: .ypBlackDay,
                                      cornerRadius: 16,
                                      fontSize: 16,
                                      fontWeight: .medium)
        button.addTarget(self, action: #selector(skipActionButton), for: .touchUpInside)
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(image: UIImage, title: String, skipAction: @escaping ()->()) {
        imageView = UIImageView(image: image)
        self.messageView.text = title
        self.skipAction = skipAction
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        
        view.backgroundColor = .clear
        view.addSubviews(imageView, messageView, buttonSkip)
        
        NSLayoutConstraint.activate([
            
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            messageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            messageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            messageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            buttonSkip.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonSkip.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonSkip.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonSkip.heightAnchor.constraint(equalToConstant: 60),
            buttonSkip.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84)
            
        ])
    }
    
    @objc func skipActionButton() {
        let tabBarController = TabBarViewController()
        let navigationController = UINavigationController(rootViewController: tabBarController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}
