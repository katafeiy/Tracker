import UIKit

protocol StatisticViewControllerProtocol: AnyObject {
    var name: StatisticEnum { get }
    var value: Int { get }
}

final class UniversalStatisticViewControllerModel: StatisticViewControllerProtocol {
    let name: StatisticEnum
    private let valueProvider: () -> Int
    
    init(name: StatisticEnum, valueProvider: @escaping () -> Int) {
        self.name = name
        self.valueProvider = valueProvider
    }
    
    var value: Int {
        return valueProvider()
    }
}

final class StatisticsViewController: UIViewController {
    
    private var viewModel = StatisticViewModel()
    
    private var statisticsStackViewHeightConstraint: NSLayoutConstraint?
    
    private lazy var emptyStatUIImageView: ImprovedUIImageView = {
        ImprovedUIImageView(image: .cryingFace)
    }()
    
    private lazy var nothingAnalyzeUILabel: ImprovedUILabel = {
        ImprovedUILabel(text: nothingAnalyze,
                        fontSize: 12,
                        weight: .medium,
                        textColor: .ypBlack)
    }()
    
    private lazy var statisticsStackView: ImprovedUIStackView = {
        return ImprovedUIStackView(arrangedSubviews: [], axis: .vertical, spacing: 12, distribution: .fill, radius: 16)
    }()
    
    init(viewModel: StatisticViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupIU()
        binding()
        configurationNavigationBar()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userDefaultsDidChange(_:)),
                                               name: .userDefaultsDidChange,
                                               object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .userDefaultsDidChange, object: nil)
    }
    
    private func binding() {
        viewModel.updateStatistics = { [weak self] in
            guard let self else { return }
            self.updateUI()
        }
        updateUI()
    }
    
    @objc private func userDefaultsDidChange(_ notification: Notification) {
        guard let key = notification.userInfo?["key"] as? String else { return }
        viewModel.handleUserDefaultsChange(key: key)
    }

    private func updateUI() {
        let hasStatistic = viewModel.isStatisticsValue()
        emptyStatUIImageView.isHidden = hasStatistic
        nothingAnalyzeUILabel.isHidden = hasStatistic
        statisticsStackView.isHidden = !hasStatistic
        
        statisticsStackView.arrangedSubviews.forEach {$0.removeFromSuperview()}
        
        var visibleViewCount: Int = 0
        for model in viewModel.statistics {
            let view = createStatisticsView(for: model)
            if model.value != 0 {
                visibleViewCount += 1
                view.isHidden = false
                statisticsStackView.addArrangedSubview(view)
            }
        }
        
        let totalHeightConstraint = CGFloat(visibleViewCount * 90) + CGFloat(max(0, visibleViewCount - 1)) * statisticsStackView.spacing
        statisticsStackViewHeightConstraint?.constant = totalHeightConstraint
    }
    
    func setupIU() {
        
        view.addSubviews(emptyStatUIImageView, nothingAnalyzeUILabel, statisticsStackView)
        
        statisticsStackViewHeightConstraint = statisticsStackView.heightAnchor.constraint(equalToConstant: 0)
        statisticsStackViewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            emptyStatUIImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStatUIImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStatUIImageView.heightAnchor.constraint(equalToConstant: 80),
            emptyStatUIImageView.widthAnchor.constraint(equalToConstant: 80),
            
            nothingAnalyzeUILabel.heightAnchor.constraint(equalToConstant: 18),
            nothingAnalyzeUILabel.topAnchor.constraint(equalTo: emptyStatUIImageView.bottomAnchor, constant: 8),
            nothingAnalyzeUILabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nothingAnalyzeUILabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            statisticsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            statisticsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statisticsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func configurationNavigationBar() {
        navigationItem.title = navigationItemTitleStVC
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func createStatisticsView(for statistics: StatisticViewControllerProtocol) -> UIView {
        
        let gradientBorderView = GradientBorderView(
                frame: .zero,
                cornerRadius: 16,
                borderWidth: 1,
                colors: [.ypRedPlanet, .ypGreenWood, .ypBlueSky]
            )
        
        let countLabel = ImprovedUILabel(text: "\(statistics.value)",
                                         fontSize: 34,
                                         weight: .bold,
                                         textColor: .ypBlack,
                                         textAlignment: .left)
        
        
        let titleLabel = ImprovedUILabel(text: statistics.name.title,
                                         fontSize: 12,
                                         weight: .medium,
                                         textColor: .ypBlack,
                                         textAlignment: .left)
        
        let stackView = ImprovedUIStackView(arrangedSubviews: [countLabel, titleLabel],
                                            axis: .vertical,
                                            spacing: 7,
                                            distribution: .fill,
                                            radius: 16)
        
        gradientBorderView.addSubviews(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: gradientBorderView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: gradientBorderView.bottomAnchor, constant: -12),
            stackView.leadingAnchor.constraint(equalTo: gradientBorderView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: gradientBorderView.trailingAnchor, constant: -12)
        ])
        
        NSLayoutConstraint.activate([
            countLabel.heightAnchor.constraint(equalToConstant: 41),
            titleLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        return gradientBorderView
    }
}
