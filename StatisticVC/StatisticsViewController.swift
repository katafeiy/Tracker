import UIKit

protocol StatisticViewModel: AnyObject {
    var name: StatisticEnum { get }
    var value: Int { get }
}

final class BestPeriodViewModel: StatisticViewModel {
    let name: StatisticEnum = .bestPeriod
    var value: Int {
        get
        {
            UserDefaultsStore.bestPeriodCount
        }
        set
        {
            UserDefaultsStore.bestPeriodCount = newValue
        }
    }
}

final class IdealDaysViewModel: StatisticViewModel {
    let name: StatisticEnum = .idealDays
    var value: Int {
        get
        {
            UserDefaultsStore.idealDaysCount
        }
        set
        {
            UserDefaultsStore.idealDaysCount = newValue
        }
    }
}

final class TrackersCompletedViewModel: StatisticViewModel {
    let name: StatisticEnum = .trackersCompleted
    var value: Int {
        get
        {
            UserDefaultsStore.trackerCompletedCount
        }
        set {
            UserDefaultsStore.trackerCompletedCount = newValue
        }
    }
}

final class AverageValueViewModel: StatisticViewModel {
    let name: StatisticEnum = .averageValue
    var value: Int {
        get {
            UserDefaultsStore.averageValueCount
        }
        set {
            UserDefaultsStore.averageValueCount = newValue
        }
    }
}

final class StatisticsViewController: UIViewController {
    
    private var statisticsStackViewHeightConstraint: NSLayoutConstraint?
    
    private var statisticViewModels: [StatisticViewModel] = [BestPeriodViewModel(), IdealDaysViewModel(), TrackersCompletedViewModel(), AverageValueViewModel()]
    
    private lazy var emptyStatUIImageView: ImprovedUIImageView = {
        ImprovedUIImageView(image: .cryingFace)
    }()
    
    private lazy var nothingAnalyzeUILabel: ImprovedUILabel = {
        ImprovedUILabel(text: "Анализировать пока нечего",
                        fontSize: 12,
                        weight: .medium,
                        textColor: .ypBlack)
    }()
    
    private lazy var statisticsStackView: ImprovedUIStackView = {
        let views = statisticViewModels.map({ createStatisticsView(for: $0) })
        return ImprovedUIStackView(arrangedSubviews: views, axis: .vertical, spacing: 12, distribution: .fill, radius: 16)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupIU()
        updateUI()
        configurationNavigationBar()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleUserDefaultsChange(_:)),
                                               name: .userDefaultsDidChange,
                                               object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .userDefaultsDidChange, object: nil)
    }
    
    @objc private func handleUserDefaultsChange(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo,
              let key = userInfo["key"] as? String else { return }
        
        switch key {
        case "bestPeriodCount":
            statisticViewModels[0] = BestPeriodViewModel()
        case "idealDaysCount":
            statisticViewModels[1] = IdealDaysViewModel()
        case "trackerCompletedCount":
            statisticViewModels[2] = TrackersCompletedViewModel()
        case "averageValueCount":
            statisticViewModels[3] = AverageValueViewModel()
        default:
            break
        }
        updateUI()
    }
    
    private func updateUI() {
        let hasStatistic = statisticViewModels.contains(where: { $0.value != 0 })
        emptyStatUIImageView.isHidden = hasStatistic
        nothingAnalyzeUILabel.isHidden = hasStatistic
        statisticsStackView.isHidden = !hasStatistic
        
        statisticsStackView.arrangedSubviews.forEach {$0.removeFromSuperview()}
        
        var visibleViewCount: Int = 0
        for viewModel in statisticViewModels {
            let view = createStatisticsView(for: viewModel)
            if viewModel.value != 0 {
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
        navigationItem.title = "Статистика"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func createStatisticsView(for statistics: StatisticViewModel) -> UIView {
        
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

