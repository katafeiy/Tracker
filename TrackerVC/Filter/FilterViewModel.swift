import Foundation

final class FilterViewModel {
    
    private(set) var filters: [FilterType] = FilterType.allCases
    
    var didSelectFilter: ((FilterType) -> Void)?
    
    func selectFilter(at index: Int) {
        guard index < filters.count else { return }
        didSelectFilter?(filters[index])
    }
    
}
