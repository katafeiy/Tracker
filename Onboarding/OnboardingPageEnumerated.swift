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
        case .firstPage: "Отслеживайте только то, что хотите"
        case .secondPage: "Даже если это не литры воды и йога"
        }
    }
}