import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func didFilterAllTrackerTap()
    func didFilterTrackerTodayTap()
    func didFilterTrackerCompletedTap()
    func didFilterTrackerNotCompletedTap()
}

final class FilterViewController: UIViewController {
    
    weak var delegate: FilterViewControllerDelegate?
    
    private let viewModel: FilterViewModel
    
    let nameCellFilter = ["Все трекеры", "Трекеры на сегодня", "Завершенные", "Не завершенные"]
    
    private lazy var filterTableView: ImprovedUITableView = {
        ImprovedUITableView(frame: view.bounds, style: .insetGrouped)
    }()
    
    init(viewModel: FilterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        filterTableView.delegate = self
        filterTableView.dataSource = self
    }
    
    func setupUI() {
        
        view.backgroundColor = .ypWhite
        view.addSubviews(filterTableView)
        
        NSLayoutConstraint.activate([
            
            filterTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filterTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
    
    private  func setupNavigationBar() {
        navigationItem.title = "Фильтр"
        navigationItem.hidesBackButton = true
    }
}

extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nameCellFilter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = .ypBackground
        cell.textLabel?.text = nameCellFilter[indexPath.row]
        cell.accessoryType = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            delegate?.didFilterAllTrackerTap()
        case 1:
            delegate?.didFilterTrackerTodayTap()
        case 2:
            delegate?.didFilterTrackerCompletedTap()
        case 3:
            delegate?.didFilterTrackerNotCompletedTap()
        default:
            break
        }
        dismiss(animated: true)
    }
}
