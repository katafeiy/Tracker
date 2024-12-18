import UIKit

final class EditCategoryViewController: BaseModelViewController {
    
    private let viewModel: EditCategoryViewModel
    
    var didEditCategoryNameTap: ((String) -> Void)?
    
    private lazy var nameCategory: UpgradedTextField = {
        var nameCategory = UpgradedTextField(placeholder: .category)
        nameCategory.text = viewModel.getNameCategory()
        nameCategory.addTarget(self, action: #selector(didChangeName(_ :)), for: .editingChanged)
        return nameCategory
    }()
    
    private lazy var subtitleNameCategory: UILabel = {
        let subtitleNameCategory = madeSubtitleLabel()
        return subtitleNameCategory
    }()
    
    private lazy var limitedTextField: LimitedTextField = {
        let limitedTextField = LimitedTextField(characterLimit: 38,
                                                subtitleLabel: subtitleNameCategory)
        return limitedTextField
    }()
    
    private lazy var editedCategoryButton: UIButton = {
        let editedCategoryButton = madeButton(title: .ready,
                                              titleColor: .ypWhiteDay,
                                              backgroundColor: .ypBlackDay)
        editedCategoryButton.addTarget(self, action: #selector(didChangeNameCategoryTap), for: .touchUpInside)
        return editedCategoryButton
    }()
    
    init(viewModel: EditCategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        nameCategory.delegate = limitedTextField
        setupNavigationBar()
        setupUI()
        binding()
    }
    
    func binding() {
        viewModel.didUpdateNameCategoryStatus = { [weak self] status in
            guard let self else { return }
            editedCategoryButton.isEnabled = status
            editedCategoryButton.backgroundColor = status ? .ypBlackDay : .ypGray
        }
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Редактирование категории"
        navigationItem.hidesBackButton = true
    }
    
    func setupUI() {
        
        view.addSubviews(nameCategory, editedCategoryButton, subtitleNameCategory)
        
        NSLayoutConstraint.activate([
            
            nameCategory.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameCategory.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameCategory.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameCategory.heightAnchor.constraint(equalToConstant: 75),
            
            subtitleNameCategory.topAnchor.constraint(equalTo: nameCategory.bottomAnchor),
            subtitleNameCategory.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            subtitleNameCategory.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            subtitleNameCategory.heightAnchor.constraint(equalToConstant: 22),
            
            editedCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            editedCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            editedCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            editedCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc func didChangeName(_ sender: UITextField) {
        viewModel.updateNameCategory(sender.text)
    }
    
    @objc func didChangeNameCategoryTap() {
        guard let newName = viewModel.getNameCategory() else { return }
        didEditCategoryNameTap?(newName)
        navigationController?.popViewController(animated: true)
    }
}
