import UIKit

final class OnboardingViewController: UIPageViewController {
    
    var skipIndicator: Bool? {
        didSet {
            guard let skipIndicator else { return }
            UserDefaultsStore.indicatorIsSkipped = skipIndicator
        }
    }
    
    private lazy var controlPageIndicator: UIPageControl = {
        let pageIndicator = UIPageControl()
        pageIndicator.numberOfPages = pages.count
        pageIndicator.currentPage = 0
        pageIndicator.currentPageIndicatorTintColor = .ypBlack
        pageIndicator.pageIndicatorTintColor = UIColor.ypBlack.withAlphaComponent(0.3)
        return pageIndicator
    }()
    
    lazy var pages: [UIViewController] = {
        
        return [
            
            OnboardingPageViewController(page: .firstPage) { [weak self] in
                guard let self else { return }
                self.skipOnboarding()
            },
            
            OnboardingPageViewController(page: .secondPage) { [weak self] in
                guard let self else { return }
                self.skipOnboarding()
            }
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skipIndicator = true
        dataSource = self
        delegate = self
        setupUI()
        
        if let firstPages = pages.first {
            setViewControllers([firstPages], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func setupUI() {
        view.backgroundColor = .clear
        view.addSubviews(controlPageIndicator)
        
        NSLayoutConstraint.activate([
            controlPageIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            controlPageIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -168)
        ])
    }
    
    func skipOnboarding() {
        dismiss(animated: true)
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        
        return pages[(index - 1 + pages.count) % pages.count]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let index = pages.firstIndex(of: viewController) else { return nil }
    
        return pages[(index + 1) % pages.count]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?.first,
           
            let currentPageIndex = pages.firstIndex(of: currentViewController) {
            
            controlPageIndicator.currentPage = currentPageIndex
        }
    }
}

