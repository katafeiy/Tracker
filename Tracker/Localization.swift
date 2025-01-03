import Foundation

// TrackerViewController

let emptyStateText = NSLocalizedString("emptyState.title", comment: "Заглушка на главный экран")
let placeholderForSearch = NSLocalizedString("placeholderForSearch", comment: "Плейсхолдер для поиска")
let navigationItemTitleTVC = NSLocalizedString("navigationItem.title.tvc", comment: "Название навигационного пункта")
let menuTitleUnPinnedTVC = NSLocalizedString("menuTitleUnPinned.tvc", comment: "Название меню при открепелении")
let menuTitleIsPinnetTVC = NSLocalizedString("menuTitleIsPinnet.tvc", comment: "Название меню при прикреплении")
let menuTitleEditedTVC = NSLocalizedString("menuTitleEdited.tvc", comment: "Название меню при изменении")
let menuTitleDeleteTVC = NSLocalizedString("menuTitleDelete.tvc", comment: "Название меню при удалении")

// TrackerCollectionViewCell

//let correctLabelCountDay = String.localizedStringWithFormat(
//    NSLocalizedString("countDay.correct", comment: "крректное отображение количества дней"), countDay)

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



