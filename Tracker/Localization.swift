import Foundation

// TrackerViewController

let emptyStateText = NSLocalizedString("emptyState.title", comment: "Заглушка на главный экран")
let placeholderForSearch = NSLocalizedString("placeholderForSearch", comment: "Плейсхолдер для поиска")
let navigationItemTitleTVC = NSLocalizedString("navigationItem.title.tvc", comment: "Название навигационного пункта")
let menuTitleUnPinnedTVC = NSLocalizedString("menuTitleUnPinned.tvc", comment: "Название меню при открепелении")
let menuTitleIsPinnedTVC = NSLocalizedString("menuTitleIsPinnet.tvc", comment: "Название меню при прикреплении")
let menuTitleEditedTVC = NSLocalizedString("menuTitleEdited.tvc", comment: "Название меню при изменении")
let menuTitleDeleteTVC = NSLocalizedString("menuTitleDelete.tvc", comment: "Название меню при удалении")

// TrackerCollectionViewCell

let keyForLocalizableDictionary = "currenNameDays"

func countDays(days: Int) -> String {
    if #available(iOS 15.0, *) {
        return String(localized: "\(days) day", comment: "TrackerCollectionViewCell")
    } else {
        return NSLocalizedString(keyForLocalizableDictionary, tableName: "LocalizableDictionary", comment: "TrackerCollectionViewCell")
    }
}

// CreateTrackerViewController

let navigationItemTitleCTVC = NSLocalizedString("navigationItem.title.ctvc", comment: "Название навигационного пункта")

// ScheduleViewController

let navigationItemTitleSVC = NSLocalizedString("navigationItem.title.svc", comment: "Название навигационного пункта")

// NewTrackerEventViewController

let category = NSLocalizedString("category", comment: "Категория")
let nameCategory = NSLocalizedString("name.category", comment: "Название категории")
let schedule = NSLocalizedString("schedule", comment: "Расписание")
let weekdays = NSLocalizedString("weekdays", comment: "Дни недели")
let newHabit = NSLocalizedString("new.habit", comment: "Новая привычка")
let newIrregularEvent = NSLocalizedString("new.irregular.event", comment: "Новое нерегулярный событие")
let emoji = NSLocalizedString("emoji", comment: "Эмоджи")
let color = NSLocalizedString("color", comment: "Цвет")
let everyDay = NSLocalizedString("every.day", comment: "Каждый день")

// CategoryListViewController

let emptyStateCategoryList = NSLocalizedString("emptyStateCategoryList.title", comment: "Заглушка на главный экран при отсутствии категорий")
let navigationItemTitleCLVC = NSLocalizedString("navigationItem.title.clvc", comment: "Название навигационного пункта")
let menuTitleEditedCLVC = NSLocalizedString("menuTitleEdited.clvc", comment: "Название пункта меню для редактирования категории")
let menuTitleDeleteCLVC = NSLocalizedString("menuTitleDelete.clvc", comment: "Название пункта меню для удаления категории")
let alertCLVC = NSLocalizedString("alert.clvc", comment: "Предупреждение при удалении категории")
let alertMenuDeleteCLVC = NSLocalizedString("alertMenuDelete.clvc", comment: "Удалении категории")
let alertMenuCancelCLVC = NSLocalizedString("alertMenuCancel.clvc", comment: "Отмена удаления категории")

// EditCategoryViewController

let navigationItemTitleECVC = NSLocalizedString("navigationItem.title.ecvc", comment: "Название навигационного пункта")

// CreateNewCategoryViewController

let navigationItemTitleCNCVC = NSLocalizedString("navigationItem.title.cncvc", comment: "Название навигационного пункта")

// ImprovedUITextField

let enterNameTracker = NSLocalizedString("enterNameTracker", comment: "Нужно ввести название трекера")
let enterNameCategory = NSLocalizedString("enterNameCategory", comment: "Нужно ввести название категории")

func updateCharactersLeft(characters: Int) -> String {
    let charactersLeft = NSLocalizedString("charactersLeft", comment: "Счетчик символов")
    let updatedCharactersLeft = String(format: charactersLeft, characters)
    return updatedCharactersLeft
}

func updateCharactersLimit(limit: Int) -> String {
    let charactersLimit = NSLocalizedString("charactersLimit", comment: "Максимальное количество символов")
    let updatedCharactersLimit = String(format: charactersLimit, limit)
    return updatedCharactersLimit
}

// ImprovedUIButton

let itsHabit = NSLocalizedString("habit", comment: "Привычка")
let anIrregularEvent = NSLocalizedString("anIrregularEvent", comment: "Нерегулярное событие")
let toCreate = NSLocalizedString("toCreate", comment: "Название кнопки для создания")
let itsReady = NSLocalizedString("ready", comment: "Название кнопки для подтверждения")
let itsCancel = NSLocalizedString("cancel", comment: "Название кнопки для отмены")
let addCategory = NSLocalizedString("addCategory", comment: "Название кнопки для добавления категории")
let skipToNextVC = NSLocalizedString("technologies", comment: "Название кнопки для перехода на следующий экран")
let itsFilter = NSLocalizedString("filter", comment: "Название кнопки для фильтрации")

// TabBarViewController

let trackersTBVC = NSLocalizedString("trackers", comment: "Название вкладки со списком трекеров")
let statisticsTBVC = NSLocalizedString("statistics", comment: "Название вкладки со статистикой")

// DaysOfWeek

let mondayDOW = NSLocalizedString("monday", comment: "Понедельник")
let tuesdayDOW = NSLocalizedString("tuesday", comment: "Вторник")
let wednesdayDOW = NSLocalizedString("wednesday", comment: "Среда")
let thursdayDOW = NSLocalizedString("thursday", comment: "Четверг")
let fridayDOW = NSLocalizedString("friday", comment: "Пятница")
let saturdayDOW = NSLocalizedString("saturday", comment: "Суббота")
let sundayDOW = NSLocalizedString("sunday", comment: "Воскресенье")

let monDOW = NSLocalizedString("mon", comment: "Пн")
let tueDOW = NSLocalizedString("tue", comment: "Вт")
let wedDOW = NSLocalizedString("wed", comment: "Ср")
let thuDOW = NSLocalizedString("thu", comment: "Чт")
let friDOW = NSLocalizedString("fri", comment: "Пт")
let satDOW = NSLocalizedString("sat", comment: "Сб")
let sunDOW = NSLocalizedString("sun", comment: "Вс")

// OnboardingPage

let firstPageText = NSLocalizedString("firstPageText", comment: "Текст первой страницы")
let secondPageText = NSLocalizedString("secondPageText", comment: "Текст второй страницы")

// PinnedCollectionView

let pinnedCategory = NSLocalizedString("pinnedCategory", comment: "Закрепленная категория")

// FilterViewController

let navigationItemTitleFVC = NSLocalizedString("navigationItem.title.fvc", comment: "Название navigationItemTitleFVC")
let allTrackersFVC = NSLocalizedString("allTrackers", comment: "Все трекекы")
let trackersTodayFVC = NSLocalizedString("trackersToday", comment: "Трекеры за сегодня")
let itsCompletedFVC = NSLocalizedString("itsCompleted", comment: "Завершенные")
let itsUncompletedFVC = NSLocalizedString("itsUncompleted", comment: "Незавершенные")

// StatisticsViewController

let navigationItemTitleStVC = NSLocalizedString("navigationItem.title.stvc", comment: "Название navigationItemTitleStVC")
let nothingAnalyze = NSLocalizedString("nothingAnalyze", comment: "Ничего пока анализировать")

// StatisticEnum

let bestPeriodSE = NSLocalizedString("bestPeriodSE", comment: "Лучший период")
let idealsDaysSE = NSLocalizedString("idealsDaysSE", comment: "Идеальные дни")
let trackersCompletedSE = NSLocalizedString("trackersCompletedSE", comment: "Трекеры завершенные")
let averageValueSE = NSLocalizedString("averageValueSE", comment: "Среднее значение")

