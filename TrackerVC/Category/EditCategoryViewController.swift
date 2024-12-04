import UIKit

final class EditCategoryViewController: UIViewController {
    
    var currentCategoryName: String? {
        didSet { nameCategory.text = currentCategoryName }
    }
    
    var didEditCategoryNameTap: ((String) -> Void)?
    
    private lazy var nameCategory: UITextField = {
        var nameTracker = UITextField()
        nameTracker.placeholder = "Введите название категории"
        nameTracker.backgroundColor = .ypBackgroundDay
        nameTracker.font = .systemFont(ofSize: 17, weight: .regular)
        nameTracker.textColor = .ypBlackDay
        nameTracker.layer.masksToBounds = true
        nameTracker.layer.cornerRadius = 16
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        nameTracker.leftView = paddingView
        nameTracker.leftViewMode = .always
        nameTracker.clearButtonMode = .whileEditing
        nameTracker.addTarget(self, action: #selector(didChangeName(_ :)), for: .editingChanged)
        nameTracker.delegate = self
        return nameTracker
    }()
    
    private lazy var createNewCategoryButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = .ypGray
        button.titleLabel?.textColor = .ypWhiteDay
        button.addTarget(self, action: #selector(didChangeNameCategoryTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var subtitleNameCategory: UILabel = {
        let subtitle = UILabel()
        subtitle.font = .systemFont(ofSize: 17, weight: .regular)
        subtitle.textColor = .ypLightGray
        subtitle.textAlignment = .center
        return subtitle
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Редактррование категории"
        navigationItem.hidesBackButton = true
    }
    
    func setupUI() {
        
        [nameCategory, createNewCategoryButton, subtitleNameCategory].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
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
    
    @objc func didChangeNameCategoryTap() {
        let newName = nameCategory.text!
        didEditCategoryNameTap?(newName)
        navigationController?.popViewController(animated: true)
    }
    
    func changeNameCategory(_ newName: String) {
        nameCategory.text = newName
        blockUpdateButton()
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

extension EditCategoryViewController: UITextFieldDelegate {
    
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
