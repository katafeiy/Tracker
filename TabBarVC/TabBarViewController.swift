import UIKit

final class TabBarViewController: UITabBarController {
    
    private enum TabBarItem: Int, CaseIterable {
        
        case tracker
        case statistics
        
        var title: String? {
            
            switch self {
            case .tracker:
                return "Трекеры"
            case .statistics:
                return "Статистика"
            }
        }
        var iconName: UIImage? {
            
            switch self {
            case .tracker:
                return UIImage.recordCircleFill
            case .statistics:
                return UIImage.hareFill
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
                trackerViewController.tabBarItem = UITabBarItem(title: $0.title, image: $0.iconName, selectedImage: nil)
                return trackerViewController
                
            case .statistics:
                let statisticsViewController = UINavigationController(rootViewController: StatisticsViewController())
                statisticsViewController.tabBarItem = UITabBarItem(title: $0.title, image: $0.iconName, selectedImage: nil)
                return statisticsViewController
            }
        }
    }
}
