import UIKit

final class CreateNewCategoryViewController: BaseModelViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        nameCategory.delegate = self
        setupUI()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Новая категория"
        navigationItem.hidesBackButton = true
    }
    
    func setupUI() {
        
        addViewToSubView(view: [nameCategory, createNewCategoryButton, subtitleNameCategory], subView: view)
        
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
        blockUpdateButton()
    }
    
    @objc func didCreateNewCategoryTap() {
        guard let categoryName = nameCategory.text else {return}
        didSelectNewCategory?(categoryName)
        navigationController?.popViewController(animated: true)
    }
    
    private func blockUpdateButton() {
        
        guard let textInput = nameCategory.text else { return }
        
        if
            textInput.isEmpty == true || textInput.count > 38 {
            
            createNewCategoryButton.isEnabled = false
            createNewCategoryButton.backgroundColor = .ypGray
        } else {
            createNewCategoryButton.isEnabled = true
            createNewCategoryButton.backgroundColor = .ypBlackDay
        }
    }
}

extension CreateNewCategoryViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text else { return true }
        
        let newText = (textFieldText as NSString).replacingCharacters(in: range, with: string)
        let count = newText.count < 38 ? newText.count : 38
        let remainingCharacters = 38 - count
        
        subtitleNameCategory.text = count < 38 ? ("Осталось \(remainingCharacters) символов") : ("Ограничение \(count) символов")
        subtitleNameCategory.textColor = count < 38 ? .ypLightGray : .ypRed
        
        return newText.count <= 38
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameCategory.resignFirstResponder()
        return true
    }
 }
