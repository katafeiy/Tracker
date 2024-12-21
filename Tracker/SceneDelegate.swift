import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let tabBarViewController = TabBarViewController()
    let onboardingViewController = OnboardingViewController()
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        OnboardingPageViewController.didSkipActionButtonTap = { [weak self] in
            guard let self else { return }
            
            let navigationController = UINavigationController(rootViewController: self.tabBarViewController)
            navigationController.modalPresentationStyle = .fullScreen
            self.window?.rootViewController = navigationController
        }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UserDefaultsStore.indicatorIsSkipped ? tabBarViewController : onboardingViewController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

