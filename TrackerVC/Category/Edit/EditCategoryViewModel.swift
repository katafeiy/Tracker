final class EditCategoryViewModel {
    
    var didUpdateNameCategoryStatus: ((Bool) -> Void)?
    
    private var сategoryName: String? {
        didSet {
            validateNameCategory()
        }
    }
    
    init(nameCategory: String?) {
        self.сategoryName = nameCategory
    }
    
    func updateNameCategory(_ nameCategory: String?) {
        self.сategoryName = nameCategory
    }
    
    func getNameCategory() -> String? {
        сategoryName
    }
    
    private func validateNameCategory() {
        guard let сategoryName else { return }
        let status = !сategoryName.isEmpty && сategoryName.count <= 38
        didUpdateNameCategoryStatus?(status)
    }
}
