import Foundation
import YandexMobileMetrica

final class AnalyticsService {
    
    static func activate() {
        
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "7fcac901-df31-474c-804b-8b4d1f6d297d") else { return }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func report(event: String, parameters: [AnyHashable: Any]) {
        
        YMMYandexMetrica.reportEvent(event, parameters: parameters, onFailure: { error in
            print("Report event error: %@, \(error.localizedDescription)")
        })
    }
}

