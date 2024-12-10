import UIKit

final class EditCategoryViewController: BaseModelViewController {
    
    var currentCategoryName: String? {
        didSet { nameCategory.text = currentCategoryName }
    }
    
    var didEditCategoryNameTap: ((String) -> Void)?
    
    private lazy var nameCategory: UITextField = {
        var nameCategory = madeTextField(placeholder: .category)
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
                                backgroundColor: .ypGray)
        editedCategoryButton.isEnabled = false
        editedCategoryButton.addTarget(self, action: #selector(didChangeNameCategoryTap), for: .touchUpInside)
        return editedCategoryButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        nameCategory.delegate = limitedTextField
        setupUI()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Редактирование категории"
        navigationItem.hidesBackButton = true
    }
    
    func setupUI() {
        
        addViewToSubView(view: [nameCategory, editedCategoryButton, subtitleNameCategory], subView: view)
        
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
        blockUpdateButton()
    }
    
    @objc func didChangeNameCategoryTap() {
        guard let newName = nameCategory.text else { return }
        didEditCategoryNameTap?(newName)
        navigationController?.popViewController(animated: true)
    }
    
    private func blockUpdateButton() {
        
        guard let textInput = nameCategory.text else { return }
        
        if
            textInput.isEmpty == true || textInput.count > 38 {
            
            editedCategoryButton.isEnabled = false
            editedCategoryButton.backgroundColor = .ypGray
        } else {
            editedCategoryButton.isEnabled = true
            editedCategoryButton.backgroundColor = .ypBlackDay
        }
    }
}
