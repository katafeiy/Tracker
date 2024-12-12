import UIKit

final class CreateTrackerViewController: BaseModelViewController {
    
    weak var delegate: (ProtocolNewHabitViewControllerOutput & ProtocolNewIrregularEventViewControllerOutput)?
    
    private lazy var habitButton: UIButton = {
        let habitButton = madeButton(title: .habit,
                                titleColor: .ypWhiteDay,
                                backgroundColor: .ypBlackDay)
        habitButton.addTarget(self, action: #selector(didHabitButtonTap), for: .touchUpInside)
        return habitButton
    }()
    
    private lazy var irregularEventButton: UIButton = {
        let button = madeButton(title: .irregular,
                                titleColor: .ypWhiteDay,
                                backgroundColor: .ypBlackDay)
        button.addTarget(self, action: #selector(didIrregularEventButtonTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = madeStackView(view: [habitButton, irregularEventButton], axis: .vertical)
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        setupUI()
        configurationNavigationBar()
    }
    
    private func setupUI() {
        
        view.addSubviews(stackView)
        
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
        let irregularEventViewController = NewIrregularEventViewController(viewModel: NewIrregularEventViewModel())
        irregularEventViewController.delegate = delegate
        navigationController?.pushViewController(irregularEventViewController, animated: true)
    }
}
