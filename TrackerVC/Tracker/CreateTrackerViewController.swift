import UIKit

final class CreateTrackerViewController: UIViewController {
    
    weak var delegate: ProtocolNewTrackerEventViewControllerOutput?
    
    private let viewModel: CreateTrackerViewModel
    
    private lazy var habitButton: ImprovedUIButton = {
        let habitButton = ImprovedUIButton(title: .habit,
                                titleColor: .ypWhiteDay,
                                backgroundColor: .ypBlackDay)
        habitButton.addTarget(self, action: #selector(didHabitButtonTap), for: .touchUpInside)
        return habitButton
    }()
    
    private lazy var irregularEventButton: ImprovedUIButton = {
        let button = ImprovedUIButton(title: .irregular,
                                titleColor: .ypWhiteDay,
                                backgroundColor: .ypBlackDay)
        button.addTarget(self, action: #selector(didIrregularEventButtonTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: ImprovedUIStackView = {
        return ImprovedUIStackView(arrangedSubviews: [habitButton, irregularEventButton], axis: .vertical)
    }()
    
    init(viewModel: CreateTrackerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        viewModel.didOpenNewCreateTrackerTap(true)
    }
    @objc func didIrregularEventButtonTap() {
        viewModel.didOpenNewCreateTrackerTap(false)
    }
    
    func openNewTrackerEvent(_ status: Bool) {
        let newTrackerEventViewController = NewTrackerEventViewController(viewModel: NewTrackerEventViewModel(withSchedule: status))
        newTrackerEventViewController.delegate = delegate
        navigationController?.pushViewController(newTrackerEventViewController, animated: true)
    }
}
