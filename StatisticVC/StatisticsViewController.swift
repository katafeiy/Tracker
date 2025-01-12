import UIKit

final class StatisticsViewController: UIViewController {
    
    private var statistics:  [StatisticEnum] = [.bestPeriod, .idealDays, .trackersCompleted, .averageValue]
    
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
        let views = statistics.map({ createStatisticsView(for: $0) })
        return ImprovedUIStackView(arrangedSubviews: views, axis: .vertical, spacing: 12)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupIU()
        configurationNavigationBar()
    }
    
    func setupIU() {
        
        view.addSubviews(emptyStatUIImageView, nothingAnalyzeUILabel, statisticsStackView)
        
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
            statisticsStackView.heightAnchor.constraint(equalToConstant: ((90 * 4) + 36))
        ])
    }
    
    private func configurationNavigationBar() {
        navigationItem.title = "Статистика"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func createStatisticsView(for statistics: StatisticEnum) -> UIView {
        
        let view = statistics.view
        let countLabel = statistics.countLabel
        let titleLabel = statistics.titleLabel
        
        let stackView = ImprovedUIStackView(arrangedSubviews: [countLabel, titleLabel],
                                            axis: .vertical,
                                            spacing: 7,
                                            distribution: .fill)
        view.addSubviews(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])
        
        NSLayoutConstraint.activate([
            countLabel.heightAnchor.constraint(equalToConstant: 41),
            titleLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        return view
    }
}
