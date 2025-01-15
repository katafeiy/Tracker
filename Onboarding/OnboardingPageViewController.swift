import UIKit

final class OnboardingPageViewController: UIViewController {
    
    private var skipAction: () -> Void
    
    static var didSkipActionButtonTap: (() -> Void)?
    
    private lazy var imageView: ImprovedUIImageView = {
        ImprovedUIImageView(contentMode: .scaleAspectFill)
    }()
    
    private lazy var messageView: ImprovedUILabel = {
        ImprovedUILabel(fontSize: 32, weight: .bold, textColor: .ypBlack, numberOfLines: 0)
    }()

    private lazy var skipButton: ImprovedUIButton = {
        let button = ImprovedUIButton(title: .skip,
                                      titleColor: .ypWhite,
                                      backgroundColor: .ypBlack,
                                      cornerRadius: 16,
                                      fontSize: 16,
                                      fontWeight: .medium)
        button.addTarget(self, action: #selector(skipActionButton), for: .touchUpInside)
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(page: OnboardingPage, skipAction: @escaping ()->()) {
        self.skipAction = skipAction
        
        super.init(nibName: nil, bundle: nil)
        self.imageView.image = page.image
        self.messageView.text = page.title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        
        view.backgroundColor = .clear
        view.addSubviews(imageView, messageView, skipButton)
        
        NSLayoutConstraint.activate([
            
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            messageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            messageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            messageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            skipButton.heightAnchor.constraint(equalToConstant: 60),
            skipButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84)
            
        ])
    }
    
    @objc func skipActionButton() {
        OnboardingPageViewController.didSkipActionButtonTap?()
    }
}
