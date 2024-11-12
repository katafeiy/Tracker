import UIKit

final class CreateTrackerViewController: UIViewController {
    
//    let nameLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Создание трекера"
//        label.font = .systemFont(ofSize: 16, weight: .medium)
//        label.textColor = .ypBlackDay
//        label.textAlignment = .center
//        return label
//    }()
    
    private lazy var habitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Привычка", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = .ypBlackDay
        button.titleLabel?.textColor = .ypWhiteDay
        button.addTarget(self, action: #selector(didHabitButtonTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var irregularEventButton: UIButton = {
        let button = UIButton()
        button.setTitle("Нерегулярное событие", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = .ypBlackDay
        button.titleLabel?.textColor = .ypWhiteDay
        button.addTarget(self, action: #selector(didIrregularEventButtonTap), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        setupUI()
        configurationNavigationBar()
    }
    
    private func setupUI() {
        
        let stackView = UIStackView(arrangedSubviews: [habitButton, irregularEventButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        
        [ stackView].forEach{$0.translatesAutoresizingMaskIntoConstraints = false; view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            
//            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 78),
//            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 114),
//            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -112),
//            nameLabel.heightAnchor.constraint(equalToConstant: 22),
//            nameLabel.widthAnchor.constraint(equalToConstant: 149),
            
            irregularEventButton.heightAnchor.constraint(equalToConstant: 60),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
            
        ])
    }
    
    func configurationNavigationBar() {
        
        navigationItem.title = "Создание трекера"
        
    }
    
    @objc func didHabitButtonTap() {
        
    }
    
    @objc func didIrregularEventButtonTap() {
        
    }
    
    
}
