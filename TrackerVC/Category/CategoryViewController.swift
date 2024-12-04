import UIKit

final class CategoryViewController: UIViewController {
    
    private let categoryStore = TrackerCategoriesStore()
    private let selectedCategory: String?
    var didSelectCategory: ((String) -> Void)?
    var categories: [String] = [] {
        didSet {
            starImage.isHidden = !categories.isEmpty
            habitLabel.isHidden = !categories.isEmpty
        }
    }
    
    
    private lazy var starImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.star
        return imageView
    }()
    
    private lazy var habitLabel: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно\n" + "объединить по смыслу"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlackDay
        return label
    }()
    
    private lazy var addNewCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить категорию", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = .ypBlackDay
        button.titleLabel?.textColor = .ypWhiteDay
        button.addTarget(self, action: #selector(didAddNewCategoryTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .singleLine
        tableView.separatorInset.left = 15.95
        tableView.separatorInset.right = 15.95
        tableView.separatorColor = .ypBlackDay
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    init(selectedCategory: String?) {
        self.selectedCategory = selectedCategory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        updateArrayCategories()
        setupNavigationBar()
        setupUI()
        
    }
    
    func setupUI() {
        
        [starImage, habitLabel, addNewCategoryButton, tableView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addNewCategoryButton.topAnchor, constant: -16),
            
            starImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            starImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -20),
            starImage.heightAnchor.constraint(equalToConstant: 80),
            starImage.widthAnchor.constraint(equalToConstant: 80),
            
            habitLabel.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 8),
            habitLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            habitLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            habitLabel.heightAnchor.constraint(equalToConstant: 36),
            
            addNewCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addNewCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addNewCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addNewCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Категория"
        navigationItem.hidesBackButton = true
    }
    
    @objc func didAddNewCategoryTap() {
        
        let createNewCategoryViewController = CreateNewCategoryViewController()
        
        createNewCategoryViewController.didSelectNewCategory = { [weak self] category in
            guard let self else  { return }
            self.categories.append(category)
            try? self.categoryStore.addCategoryName(category)
            self.tableView.reloadData()
        }
        navigationController?.pushViewController(createNewCategoryViewController, animated: true)
    }
    
    func updateArrayCategories() {
        categories = (try? categoryStore.getCategoryNames()) ?? []
    }
}

extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row]
        
        cell.backgroundColor = .ypBackgroundDay
        if categories[indexPath.row] == selectedCategory {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        tableView.visibleCells.forEach { $0.accessoryType = .none }
        
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
        } else {
            cell?.accessoryType = .checkmark
        }
        DispatchQueue.main.async {
            self.didSelectCategory?(self.categories[indexPath.row])
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        guard indexPath.row != 0 else { return nil }
        
        let configContextMenu = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { action in
            
            return UIMenu(children: [
                UIAction(title: "Редактировать") { action in
                    self.editCategory(indexPath: indexPath)
                },
                UIAction(title: "Удалить", attributes: .destructive) { action in
                    self.deleteCategory(indexPath: indexPath)
                }
            ])
        }
        return configContextMenu
    }
    
    private func editCategory(indexPath: IndexPath) {
        
        let editCategoryViewController = EditCategoryViewController()
        let category = self.categories[indexPath.row]
        
        editCategoryViewController.currentCategoryName = category
        
        editCategoryViewController.didEditCategoryNameTap = { [weak self] newName in
            guard let self else { return }
            
            do {
                try self.categoryStore.editCategoryName(category, newName: newName)
                self.categories[indexPath.row] = newName
            } catch {
                print("Error editing category: \(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                self.tableView.performBatchUpdates({
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }, completion: nil)
            }
        }
        navigationController?.pushViewController(editCategoryViewController, animated: true)
    }
    
    private func deleteCategory(indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Эта категория точне не нужна?", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Удалить",
                                          style: .destructive,
                                          handler: {_ in
                
                let category = self.categories[indexPath.row]
                self.categories.remove(at: indexPath.row)
                
                do {
                    try self.categoryStore.deleteCategory(category)
                } catch {
                    print("Error deleting category: \(error.localizedDescription)")
                    return
                }
                self.tableView.performBatchUpdates({
                    self.tableView.deleteRows(at: [indexPath], with: .left)
                }, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
