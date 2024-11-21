import UIKit

final class CreateTrackerViewController: UIViewController {
    
    weak var delegate: ProtocolNewHabitViewControllerOutput?
    
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
        
        [stackView].forEach{$0.translatesAutoresizingMaskIntoConstraints = false; view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            
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
        navigationController?.navigationBar.tintColor = .ypBlackDay
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor.ypBlackDay
        ]
    }
    
    @objc func didHabitButtonTap() {
        let habitViewController = NewHabitViewController()
        habitViewController.delegate = delegate
        navigationController?.pushViewController(habitViewController, animated: true)
    }
    
    @objc func didIrregularEventButtonTap() {
        // TODO: Функционал данной кнопки будет реализован в следующем спринте!
        let alert = UIAlertController(title: "Нерегулярное событие\n",
                                      message: "Уважаемый ревьювер)))\n" +
                                      "В задание 14-го спринта функционал данной кнопки не предполагает быть реализованным именно в 14-ом спринте," +
                                      " он будет реализован в 15-ом спринте!\n Честное слово!!!)))\n 😉",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
