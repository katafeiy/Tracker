import UIKit

final class StatisticsViewController: UIViewController {
    
    private var bestPeriod: Int?
    private var idealDays: Int?
    private var trackersCompleted: Int?
    private var averageValue: Int?
    
    private lazy var emptyStatUIImageView: ImprovedUIImageView = {
        ImprovedUIImageView(image: .cryingFace)
    }()
    
    private lazy var nothingAnalyzeUILabel: ImprovedUILabel = {
        ImprovedUILabel(text: "Анализировать пока нечего",
                        fontSize: 12,
                        weight: .medium,
                        textColor: .ypBlack)
    }()
    
    private lazy var bestPeriodUIView: ImprovedUIView = {
        StatisticEnum.bestPeriod.view
    }()
    private lazy var idealDaysUIView: ImprovedUIView = {
        StatisticEnum.idealDays.view
    }()
    private lazy var trackersCompletedUIView: ImprovedUIView = {
        StatisticEnum.trackersCompleted.view
    }()
    private lazy var averageValueUIView: ImprovedUIView = {
        StatisticEnum.averageValue.view
    }()
    
    private lazy var statisticStackView: ImprovedUIStackView = {
        ImprovedUIStackView(arrangedSubviews: [bestPeriodUIView, idealDaysUIView, trackersCompletedUIView, averageValueUIView],
                            axis: .vertical,
                            spacing: 12)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupIU()
        configurationNavigationBar()
    }
    
    func setupIU() {
        
        view.addSubviews(emptyStatUIImageView, nothingAnalyzeUILabel, statisticStackView)
        
        NSLayoutConstraint.activate([
            emptyStatUIImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStatUIImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStatUIImageView.heightAnchor.constraint(equalToConstant: 80),
            emptyStatUIImageView.widthAnchor.constraint(equalToConstant: 80),
            
            nothingAnalyzeUILabel.heightAnchor.constraint(equalToConstant: 18),
            nothingAnalyzeUILabel.topAnchor.constraint(equalTo: emptyStatUIImageView.bottomAnchor, constant: 8),
            nothingAnalyzeUILabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nothingAnalyzeUILabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            statisticStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            statisticStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statisticStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            statisticStackView.heightAnchor.constraint(equalToConstant: ((90 * 4) + 36))
            
        ])
    }
    
    private func configurationNavigationBar() {
        navigationItem.title = "Статистика"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
