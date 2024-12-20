final class EditCategoryViewModel {
    
    var didUpdateNameCategoryStatus: ((Bool) -> Void)?
    
    private var nameCategory: String? {
        didSet {
            validateNameCategory()
        }
    }
    
    init(nameCategory: String?) {
        self.nameCategory = nameCategory
    }
    
    func updateNameCategory(_ nameCategory: String?) {
        self.nameCategory = nameCategory
    }
    
    func getNameCategory() -> String? {
        nameCategory
    }
    
    private func validateNameCategory() {
        guard let nameCategory else { return }
        let status = !nameCategory.isEmpty && nameCategory.count <= 38
        didUpdateNameCategoryStatus?(status)
    }
}
