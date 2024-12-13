import UIKit

final class CategoryListViewController: BaseModelViewController {
    
    var didSelectCategory: ((String) -> Void)?
    private let viewModel: CategoryListViewModel
    
    private lazy var starImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.star
        return imageView
    }()
    
    private lazy var habitLabel: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно\n" + "объединить по смыслу"
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlackDay
        label.textAlignment = .center
        return label
    }()
    
    private lazy var addNewCategoryButton: UIButton = {
        let button = madeButton(title: .add, titleColor: .ypWhiteDay, backgroundColor: .ypBlackDay)
        button.addTarget(self, action: #selector(didAddNewCategoryTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = madeTableView()
        tableView.register(CategoryListCell.self, forCellReuseIdentifier: CategoryListCell.identifier)
        return tableView
    }()
    
    init(viewModel: CategoryListViewModel) {
        self.viewModel = viewModel
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
        setupBinding()
        viewModel.loadCategories()
        setupNavigationBar()
        setupUI()
        
    }
    
    func setupUI() {
        
        view.addSubviews(starImage, habitLabel, addNewCategoryButton, tableView)
        
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
    
    func setupBinding() {
        viewModel.didUpdatesCategories = { [weak self] in
            guard let self else { return }
            starImage.isHidden = !viewModel.categories.isEmpty
            habitLabel.isHidden = !viewModel.categories.isEmpty
            tableView.reloadData()
        }
        
        viewModel.didUpdateSelectedCategory = { [weak self] selectedCategory in
            guard let self else { return }
            tableView.visibleCells.enumerated().forEach { index, cell in
                if self.viewModel.isSelectedCategory(self.viewModel.categories[index]) {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            }
            DispatchQueue.main.async {
                self.didSelectCategory?(selectedCategory)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Категория"
        navigationItem.hidesBackButton = true
    }
    
    @objc func didAddNewCategoryTap() {
        
        let createNewCategoryViewController = CreateNewCategoryViewController(viewModel: CreateNewCategoryViewModel())
        
        createNewCategoryViewController.didSelectNewCategory = { [weak self] category in
            guard let self else  { return }
            self.viewModel.addNewCategory(category)
        }
        navigationController?.pushViewController(createNewCategoryViewController, animated: true)
    }
}

extension CategoryListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryListCell.identifier, for: indexPath) as? CategoryListCell else { fatalError() }
        
        cell.textLabel?.text = viewModel.categories[indexPath.row]
        
        cell.backgroundColor = .ypBackgroundDay
        if viewModel.isSelectedCategory(viewModel.categories[indexPath.row]) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            viewModel.didSelectCategory(viewModel.categories[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        guard indexPath.row != 0 else { return nil }
        
        let configContextMenu = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { action in
            
            return UIMenu(children: [
                UIAction(title: "Редактировать" ,
                         image: .pencilAndListClipboard.withTintColor(.ypBlackDay)) { action in
                    self.editCategory(indexPath: indexPath)
                },
                UIAction(title: "Удалить", image:
                        .trash.withTintColor(.ypRed),
                         attributes: .destructive) { action in
                    self.deleteCategory(indexPath: indexPath)
                }
            ])
        }
        return configContextMenu
    }
     
    private func editCategory(indexPath: IndexPath) {
        
        let editCategoryViewController = EditCategoryViewController()
        let category = self.viewModel.categories[indexPath.row]
        
        editCategoryViewController.currentCategoryName = category
        
        editCategoryViewController.didEditCategoryNameTap = { [weak self] newName in
            guard let self else { return }
            
            viewModel.editCategory(oldNameCategory: category, newNameCategory: newName)
        }
        navigationController?.pushViewController(editCategoryViewController, animated: true)
    }
    
    private func deleteCategory(indexPath: IndexPath) {
        
        let category = self.viewModel.categories[indexPath.row]
        let alert = UIAlertController(title: "Эта категория точне не нужна?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Удалить",
                                      style: .destructive,
                                      handler: { [weak self] _ in
            
            guard let self else { return }
            self.viewModel.deleteCategory(category)
            
        }))
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
