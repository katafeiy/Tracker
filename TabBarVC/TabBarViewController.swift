import UIKit

final class TabBarViewController: UITabBarController {
    
    private enum TabBarItem: Int, CaseIterable {
        
        case tracker
        case statistics
        
        var title: String? {
            
            return switch self {
            case .tracker: "Трекеры"
            case .statistics: "Статистика"
            }
        }
        var image: UIImage? {
            
            return switch self {
            case .tracker: UIImage.recordCircleFill
            case .statistics: UIImage.hareFill
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBar()
    }
    
    private func setupTabBar() {
        
        let dataSource: [TabBarItem] = [.tracker, .statistics]
        
        self.viewControllers = dataSource.map {
            switch $0 {
            case .tracker:
                let trackerViewController = UINavigationController(rootViewController: TrackerViewController())
                trackerViewController.tabBarItem = UITabBarItem(title: $0.title, image: $0.image, selectedImage: nil)
                return trackerViewController
                
            case .statistics:
                let statisticsViewController = UINavigationController(rootViewController: StatisticsViewController())
                statisticsViewController.tabBarItem = UITabBarItem(title: $0.title, image: $0.image, selectedImage: nil)
                return statisticsViewController
            }
        }
    }
}
