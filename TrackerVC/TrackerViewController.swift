import UIKit
import SwiftUI

final class TrackerViewController: UIViewController {
    
    private lazy var newTrackButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage.addTracker,
            target: self,
            action: #selector(setNewTracker))
        button.tintColor = .ypBlackDay
        return button
    }()
    
    private lazy var dateFiled: UITextField = {
        let field = UITextField()
        field.placeholder = dateString(Date())
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 8
        field.backgroundColor = .ypBackgroundDay
        return field
    }()
    
    private lazy var dateTracker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.tintColor = .ypBlackDay
        datePicker.addTarget(self, action: #selector(setDateTracker), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var calendarButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage.calendar,
            target: self,
            action: #selector(setCalendarTracker))
        button.tintColor = .ypBlackDay
        return button
    }()
    
    let nameTrackers: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .ypBlackDay
        return label
    }()
    
    let starImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.star
        return imageView
    }()
    
    let searchFiled: UITextField = {
        let searchFiled = UITextField()
        searchFiled.placeholder = "Поиск"
        searchFiled.layer.masksToBounds = true
        searchFiled.layer.cornerRadius = 8
        searchFiled.backgroundColor = .ypBackgroundDay
        return searchFiled
    }()
    
    let whatSearch: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlackDay
        return label
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configurationView()
        configurationNavigationBar()
    }
    
    func configurationNavigationBar() {
        
        let leftButton = UIBarButtonItem()
        leftButton.customView = newTrackButton
        self.navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem()
        rightButton.customView = dateFiled
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    func configurationView() {
         
        view.backgroundColor = .ypWhiteDay
        dateFiled.inputView = dateTracker
//        calendarButton.inputView = dateTracker
        dateTracker.center = view.center
        
        [dateFiled, newTrackButton, nameTrackers, starImage, searchFiled, whatSearch, calendarButton].forEach{$0.translatesAutoresizingMaskIntoConstraints = false; view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            
            newTrackButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            newTrackButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6),
            newTrackButton.heightAnchor.constraint(equalToConstant: 42),
            newTrackButton.widthAnchor.constraint(equalToConstant: 42),
            
            dateFiled.centerYAnchor.constraint(equalTo: newTrackButton.centerYAnchor),
            dateFiled.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            dateFiled.heightAnchor.constraint(equalToConstant: 33),
            dateFiled.widthAnchor.constraint(equalToConstant: 90),
            
            nameTrackers.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            nameTrackers.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameTrackers.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -105),
            nameTrackers.heightAnchor.constraint(equalToConstant: 41),
//            nameTrackers.widthAnchor.constraint(equalToConstant: 254),
            
            calendarButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            calendarButton.centerYAnchor.constraint(equalTo: nameTrackers.centerYAnchor),
            calendarButton.heightAnchor.constraint(equalToConstant: 42),
            calendarButton.widthAnchor.constraint(equalToConstant: 42),
            
            searchFiled.heightAnchor.constraint(equalToConstant: 36),
//            searchFiled.widthAnchor.constraint(equalToConstant: 343),
            searchFiled.topAnchor.constraint(equalTo: nameTrackers.bottomAnchor, constant: 7),
            searchFiled.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchFiled.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            starImage.heightAnchor.constraint(equalToConstant: 80),
            starImage.widthAnchor.constraint(equalToConstant: 80),
            starImage.topAnchor.constraint(equalTo: searchFiled.bottomAnchor, constant: 230),
            starImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            whatSearch.heightAnchor.constraint(equalToConstant: 18),
//            whatSearch.widthAnchor.constraint(equalToConstant: 343),
            whatSearch.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 8),
            whatSearch.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            whatSearch.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
            
        ])
        
    }
    
    @objc func setCalendarTracker() {
        dateFiled.text = dateString(dateTracker.date)
        view.endEditing(true)
    }
    
    @objc func setDateTracker() {
        dateFiled.text = dateString(dateTracker.date)
        view.endEditing(true)
    }

    @objc func setNewTracker() {
        
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    public func dateString(_ date: Date) -> String {
        dateFormatter.string(from: date)
    }
    
}

