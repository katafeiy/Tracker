import UIKit

final class CreateNewCategoryViewController: BaseModelViewController {
    
    private let viewModel: CreateNewCategoryViewModel
    
    var didSelectNewCategory: ((String) -> Void)?
    
    private lazy var nameCategory: UITextField = {
        var nameCategory = madeTextField(placeholder: .category)
        nameCategory.addTarget(self, action: #selector(didChangeName(_ :)), for: .editingChanged)
        return nameCategory
    }()
    
    private lazy var createNewCategoryButton: UIButton = {
        let button = madeButton(title: .ready,
                                titleColor: .ypWhiteDay,
                                backgroundColor: .ypGray)
        button.addTarget(self, action: #selector(didCreateNewCategoryTap), for: .touchUpInside)
        return button
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
    
    init(viewModel: CreateNewCategoryViewModel) {
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
        binding()
        setupUI()
        setupNavigationBar()
    }
    
    func binding() {
        viewModel.updateCreateNewCategoryStatus = { [weak self] status in
            guard let self else { return }
            createNewCategoryButton.isEnabled = status
            createNewCategoryButton.backgroundColor = status ? .ypBlackDay : .ypGray
        }
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Новая категория"
        navigationItem.hidesBackButton = true
    }
    
    func setupUI() {
        
        view.addSubviews(nameCategory, createNewCategoryButton, subtitleNameCategory)
        
        NSLayoutConstraint.activate([
            
            nameCategory.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameCategory.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameCategory.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameCategory.heightAnchor.constraint(equalToConstant: 75),
            
            subtitleNameCategory.topAnchor.constraint(equalTo: nameCategory.bottomAnchor),
            subtitleNameCategory.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            subtitleNameCategory.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            subtitleNameCategory.heightAnchor.constraint(equalToConstant: 22),
            
            createNewCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createNewCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            createNewCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            createNewCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc func didChangeName(_ sender: UITextField) {
        viewModel.updateNameCategory(sender.text)
    }
    
    @objc func didCreateNewCategoryTap() {
        guard let nameCategory = viewModel.getNameCategory() else { return }
        didSelectNewCategory?(nameCategory)
        navigationController?.popViewController(animated: true)
    }
}
