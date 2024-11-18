import UIKit

final class CreateNewCategoryViewController: UIViewController {
    
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
    
    private lazy var addNewCategory: UIButton = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupUI()
    }
    
    func setupUI() {
        
        [starImage, habitLabel, addNewCategory].forEach{$0.translatesAutoresizingMaskIntoConstraints = false; view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            
            starImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            starImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -20),
            starImage.heightAnchor.constraint(equalToConstant: 80),
            starImage.widthAnchor.constraint(equalToConstant: 80),
            
            habitLabel.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 8),
            habitLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            habitLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            habitLabel.heightAnchor.constraint(equalToConstant: 36),
            
            addNewCategory.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addNewCategory.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addNewCategory.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addNewCategory.heightAnchor.constraint(equalToConstant: 60)
            
        ])
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Категория"
    }
    
    @objc func didAddNewCategoryTap() {
        // TODO: - Добавить логику при нажатии на ячейку
    }
}


