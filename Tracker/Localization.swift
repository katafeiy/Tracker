import Foundation
enum Localization {
    
    enum TrackerViewController {
        
        static let emptyStateText = NSLocalizedString("emptyState.title", comment: "Заглушка на главный экран")
        static let emptySearchText = NSLocalizedString("emptySearch.title", comment: "Заглушка на главный экран при неудачном поиске")
        static let placeholderForSearch = NSLocalizedString("placeholderForSearch", comment: "Плейсхолдер для поиска")
        static let navigationItemTitleTVC = NSLocalizedString("navigationItem.title.tvc", comment: "Название навигационного пункта")
        static let menuTitleUnPinnedTVC = NSLocalizedString("menuTitleUnPinned.tvc", comment: "Название меню при открепелении")
        static let menuTitleIsPinnedTVC = NSLocalizedString("menuTitleIsPinnet.tvc", comment: "Название меню при прикреплении")
        static let menuTitleEditedTVC = NSLocalizedString("menuTitleEdited.tvc", comment: "Название меню при изменении")
        static let menuTitleDeleteTVC = NSLocalizedString("menuTitleDelete.tvc", comment: "Название меню при удалении")
    }
    
    enum TrackerCollectionViewCell {
        
        static func countDays(days: Int) -> String {
            let keyForLocalizableDictionary = "currentNameDays"
            if #available(iOS 15.0, *) {
                return String(localized: "\(days) day", comment: "TrackerCollectionViewCell")
            } else {
                return NSLocalizedString(keyForLocalizableDictionary, tableName: "LocalizableDictionary", comment: "TrackerCollectionViewCell")
            }
        }
    }
    enum CreateTrackerViewController {
        
        static let navigationItemTitleCTVC = NSLocalizedString("navigationItem.title.ctvc", comment: "Название навигационного пункта")
    }
    
    enum ScheduleViewController {
        
        static let navigationItemTitleSVC = NSLocalizedString("navigationItem.title.svc", comment: "Название навигационного пункта")
    }
    
    enum NewTrackerEventViewController {
        
        static let category = NSLocalizedString("category", comment: "Категория")
        static let nameCategory = NSLocalizedString("name.category", comment: "Название категории")
        static let schedule = NSLocalizedString("schedule", comment: "Расписание")
        static let weekdays = NSLocalizedString("weekdays", comment: "Дни недели")
        static let newHabit = NSLocalizedString("new.habit", comment: "Новая привычка")
        static let newIrregularEvent = NSLocalizedString("new.irregular.event", comment: "Новое нерегулярный событие")
        static let emoji = NSLocalizedString("emoji", comment: "Эмоджи")
        static let color = NSLocalizedString("color", comment: "Цвет")
        static let everyDay = NSLocalizedString("every.day", comment: "Каждый день")
        static let editing = NSLocalizedString("edited.ntevc", comment: "Редактирование")
        static let aHabit = NSLocalizedString("a.habit.ntevc", comment: "Привычка")
        static let anIrregularEvent = NSLocalizedString("an.irregular.event.ntevc", comment: "Нерегулярное событие")
    }
    
    enum CategoryListViewController {
        
        static let emptyStateCategoryList = NSLocalizedString("emptyStateCategoryList.title", comment: "Заглушка на главный экран при отсутствии категорий")
        static let navigationItemTitleCLVC = NSLocalizedString("navigationItem.title.clvc", comment: "Название навигационного пункта")
        static let menuTitleEditedCLVC = NSLocalizedString("menuTitleEdited.clvc", comment: "Название пункта меню для редактирования категории")
        static let menuTitleDeleteCLVC = NSLocalizedString("menuTitleDelete.clvc", comment: "Название пункта меню для удаления категории")
        static let alertCLVC = NSLocalizedString("alert.clvc", comment: "Предупреждение при удалении категории")
        static let alertMenuDeleteCLVC = NSLocalizedString("alertMenuDelete.clvc", comment: "Удалении категории")
        static let alertMenuCancelCLVC = NSLocalizedString("alertMenuCancel.clvc", comment: "Отмена удаления категории")
    }
    enum EditCategoryViewController {
        
        static let navigationItemTitleECVC = NSLocalizedString("navigationItem.title.ecvc", comment: "Название навигационного пункта")
    }
    enum CreateNewCategoryViewController {
        
        static let navigationItemTitleCNCVC = NSLocalizedString("navigationItem.title.cncvc", comment: "Название навигационного пункта")
    }
    enum ImprovedUITextField {
        
        static let enterNameTracker = NSLocalizedString("enterNameTracker", comment: "Нужно ввести название трекера")
        static let enterNameCategory = NSLocalizedString("enterNameCategory", comment: "Нужно ввести название категории")
        
        static func updateCharactersLeft(characters: Int) -> String {
            
            let charactersLeft = NSLocalizedString("charactersLeft", comment: "Счетчик символов")
            let updatedCharactersLeft = String(format: charactersLeft, characters)
            return updatedCharactersLeft
        }
        
        static func updateCharactersLimit(limit: Int) -> String {
            let charactersLimit = NSLocalizedString("charactersLimit", comment: "Максимальное количество символов")
            let updatedCharactersLimit = String(format: charactersLimit, limit)
            return updatedCharactersLimit
        }
    }
    
    enum ImprovedUIButton {
        
        static let itsHabit = NSLocalizedString("habit", comment: "Привычка")
        static let aIrregularEvent = NSLocalizedString("anIrregularEvent", comment: "Нерегулярное событие")
        static let toCreate = NSLocalizedString("toCreate", comment: "Название кнопки для создания")
        static let itsReady = NSLocalizedString("ready", comment: "Название кнопки для подтверждения")
        static let itsCancel = NSLocalizedString("cancel", comment: "Название кнопки для отмены")
        static let addCategory = NSLocalizedString("addCategory", comment: "Название кнопки для добавления категории")
        static let skipToNextVC = NSLocalizedString("technologies", comment: "Название кнопки для перехода на следующий экран")
        static let itsFilter = NSLocalizedString("filter", comment: "Название кнопки для фильтрации")
    }
    enum TabBarViewController {
        
        static let trackersTitle = NSLocalizedString("trackers", comment: "Название вкладки со списком трекеров")
        static let statisticsTitle = NSLocalizedString("statistics", comment: "Название вкладки со статистикой")
    }
    enum DaysOfWeek {
        
        static let monday = NSLocalizedString("monday", comment: "Понедельник")
        static let tuesday = NSLocalizedString("tuesday", comment: "Вторник")
        static let wednesday = NSLocalizedString("wednesday", comment: "Среда")
        static let thursday = NSLocalizedString("thursday", comment: "Четверг")
        static let friday = NSLocalizedString("friday", comment: "Пятница")
        static let saturday = NSLocalizedString("saturday", comment: "Суббота")
        static let sunday = NSLocalizedString("sunday", comment: "Воскресенье")
        
        static let mon = NSLocalizedString("mon", comment: "Пн")
        static let tue = NSLocalizedString("tue", comment: "Вт")
        static let wed = NSLocalizedString("wed", comment: "Ср")
        static let thu = NSLocalizedString("thu", comment: "Чт")
        static let fri = NSLocalizedString("fri", comment: "Пт")
        static let sat = NSLocalizedString("sat", comment: "Сб")
        static let sun = NSLocalizedString("sun", comment: "Вс")
    }
    enum OnboardingPage {
        
        static let firstPageText = NSLocalizedString("firstPageText", comment: "Текст первой страницы")
        static let secondPageText = NSLocalizedString("secondPageText", comment: "Текст второй страницы")
    }
    enum PinnedCollectionView {
        
        static let pinnedCategory = NSLocalizedString("pinnedCategory", comment: "Закрепленная категория")
    }
    enum FilterViewController {
        
        static let navigationItemTitleFVC = NSLocalizedString("navigationItem.title.fvc", comment: "Название navigationItemTitleFVC")
        static let allTrackersFVC = NSLocalizedString("allTrackers", comment: "Все трекекы")
        static let trackersTodayFVC = NSLocalizedString("trackersToday", comment: "Трекеры за сегодня")
        static let itsCompletedFVC = NSLocalizedString("itsCompleted", comment: "Завершенные")
        static let itsUncompletedFVC = NSLocalizedString("itsUncompleted", comment: "Незавершенные")
    }
    enum StatisticsViewController {
        
        static let navigationItemTitleStVC = NSLocalizedString("navigationItem.title.stvc", comment: "Название navigationItemTitleStVC")
        static let nothingAnalyze = NSLocalizedString("nothingAnalyze", comment: "Ничего пока анализировать")
    }
    enum StatisticEnum {
        
        static let bestPeriod = NSLocalizedString("bestPeriodSE", comment: "Лучший период")
        static let idealsDays = NSLocalizedString("idealsDaysSE", comment: "Идеальные дни")
        static let trackersCompleted = NSLocalizedString("trackersCompletedSE", comment: "Трекеры завершенные")
        static let averageValue = NSLocalizedString("averageValueSE", comment: "Среднее значение")
    }
}
