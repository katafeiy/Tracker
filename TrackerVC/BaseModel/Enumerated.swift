enum placeholderText {
    case tracker
    case category
    
    var text: String {
        return switch self {
        case .tracker: "Введите название трекера"
        case .category: "Введите название категории"
        }
    }
}

enum buttonName {
    case habit
    case irregular
    case create
    case ready
    case cancel
    case add
    case skip
    
    var text: String {
        return switch self {
        case .habit: "Привычка"
        case .irregular: "Нерегулярное событие"
        case .create: "Создать"
        case .ready: "Готово"
        case .cancel: "Отменить"
        case .add: "Добавить категорию"
        case .skip: "Вот это технологии"
        }
    }
}
