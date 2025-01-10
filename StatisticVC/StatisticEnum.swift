import Foundation

enum StatisticEnum: Int, CaseIterable {
   
    case bestPeriod
    case idealDays
    case trackersCompleted
    case averageValue
    
    var count: Int? {
        self.rawValue
    }
    
    var view: ImprovedUIView {
         ImprovedUIView(
            backgroundColor: .ypWhite,
            cornerRadius: 16,
            borderWidth: 1,
            borderColor: .ypRed
         )
    }
}
