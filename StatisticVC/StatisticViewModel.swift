import Foundation

final class StatisticViewModel {
    
    private(set) var statistics: [StatisticViewControllerProtocol] = []
    
    var updateStatistics: (() -> Void)?
    
    init() {
        statistics = [
            UniversalStatisticViewControllerModel(name: .bestPeriod, valueProvider: { UserDefaultsStore.bestPeriodCount }),
            UniversalStatisticViewControllerModel(name: .idealDays, valueProvider: { UserDefaultsStore.idealDaysCount }),
            UniversalStatisticViewControllerModel(name: .trackersCompleted, valueProvider: { UserDefaultsStore.trackerCompletedCount }),
            UniversalStatisticViewControllerModel(name: .averageValue, valueProvider: { UserDefaultsStore.averageValueCount })
            
        ]
    }
    
    func handleUserDefaultsChange(key: String) {
        statistics = statistics.map { model in
                    if model.name.rawValue == key {
                        return UniversalStatisticViewControllerModel(name: model.name, valueProvider: { model.value })
                    }
                    return model
                }
        updateStatistics?()
    }
    
    func isStatisticsValue() -> Bool {
        return statistics.contains { $0.value != 0 }
    }
    
}
