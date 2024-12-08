import UIKit

final class OnboardingViewController: UIPageViewController {
    
    lazy var pages: [UIViewController] = {
        
        return [
            
            OnboardingPageViewController(image: UIImage(), title: "Привет", skipAction: { [weak self] in
                self?.skipOnboarding()
            }),
            
            OnboardingPageViewController(image: UIImage(), title: "Привет", skipAction: { [weak self] in
                self?.skipOnboarding()
            })
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        setViewControllers(pages, direction: .forward, animated: false)
    }
    
    
    func skipOnboarding() {
        dismiss(animated: true)
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        
        return pages[(index - 1 + pages.count) % pages.count ]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let index = pages.firstIndex(of: viewController) else { return nil }
    
        return pages[(index + 1) % pages.count ]
    }
}

