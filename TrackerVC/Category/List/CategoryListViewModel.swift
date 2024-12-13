
final class CategoryListViewModel {
    
    private let categoryStore = TrackerCategoriesStore()
    private var selectedCategory: String? {
        didSet {
            guard let selectedCategory else { return }
            didUpdateSelectedCategory?(selectedCategory)
        }
    }
    
    var didUpdatesCategories: (() -> Void)?
    var didUpdateSelectedCategory: ((String) -> Void)?
    
    private(set) var categories: [String] = [] {
        didSet {
            didUpdatesCategories?()
        }
    }
    
    init(selectedCategory: String?) {
        self.selectedCategory = selectedCategory
    
    }
    
    func addNewCategory(_ category: String) {
        try? categoryStore.addCategoryName(category)
        categories.append(category)
    }
    
    func loadCategories() {
        categories = (try? categoryStore.getCategoryNames()) ?? []
    }
    
    func isSelectedCategory(_ category: String) -> Bool {
        selectedCategory == category
    }
    
    func didSelectCategory(_ category: String) {
        selectedCategory = category
    }
    
    func editCategory(oldNameCategory: String, newNameCategory: String) {
        
        do {
            try categoryStore.editCategoryName(oldNameCategory, newName: newNameCategory)
            categories = categories.map({$0 == oldNameCategory ? newNameCategory : $0})
        } catch {
            print("Error editing category: \(error.localizedDescription)")
            return
        }
    }
    
    func deleteCategory(_ category: String) {
        
        do {
            try categoryStore.deleteCategory(category)
            categories.removeAll { $0 == category }
        } catch {
            print("Error deleting category: \(error.localizedDescription)")
            return
        }
    }
}
