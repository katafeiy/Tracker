import Foundation

final class FilterViewModel {
    
    private(set) var filters: [FilterType] = FilterType.allCases
    
    private(set) var initialFilterType: FilterType
    
    var didSelectFilter: ((FilterType) -> Void)?
    
    
    init(initialFilterType: FilterType) {
        self.initialFilterType = initialFilterType
    }
    
    func selectFilter(at index: Int) {
        guard index < filters.count else { return }
        didSelectFilter?(filters[index])
    }
    
}
