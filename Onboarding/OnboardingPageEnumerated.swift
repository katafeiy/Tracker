import UIKit

enum OnboardingPage {
    
    case firstPage
    case secondPage
    
    var image: UIImage {
        return switch self {
        case .firstPage: .blueOnboarding
        case .secondPage: .redOnboarding
        }
    }
    var title: String {
        return switch self {
        case .firstPage: Localization.OnboardingPage.firstPageText
        case .secondPage: Localization.OnboardingPage.secondPageText
        }
    }
}
