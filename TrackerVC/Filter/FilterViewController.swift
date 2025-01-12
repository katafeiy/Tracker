import UIKit

final class FilterViewController: UIViewController {
    
    private let viewModel: FilterViewModel
    
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
        navigationItem.title = navigationItemTitleFVC
        navigationItem.hidesBackButton = true
    }
}

extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = .ypBackground
        cell.textLabel?.text = viewModel.filters[indexPath.row].title
        cell.accessoryType = viewModel.initialFilterType == viewModel.filters[indexPath.row] ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel.selectFilter(at: indexPath.row)
        dismiss(animated: true)
    }
}
