
final class CreateNewCategoryViewModel  {
    
    private var nameCategory: String?
    
    var updateCreateNewCategoryStatus: ((Bool) -> Void)?
    
    func updateNameCategory(_ nameCategory: String?) {
        self.nameCategory = nameCategory
        updateCreateNewCategoryStatus?(isCreateNewCategoryValid())
    }
    
    private func isCreateNewCategoryValid() -> Bool {
        guard let nameCategory else { return false }
        return !nameCategory.isEmpty &&
        nameCategory.count <= 38
    }
    
    func getNameCategory() -> String? {
        return nameCategory
    }
}
