final class ScheduleViewModel {
    
    private(set) var selectedDays: Set<DaysOfWeek> = []
    
    var daysOfWeek: [DaysOfWeek] {
        DaysOfWeek.allCases
    }
    
    init(selectedDays: Set<DaysOfWeek>) {
        self.selectedDays = selectedDays
    }
    
    func toggleDay(_ day: DaysOfWeek, isSelected: Bool) {
        
        if isSelected {
            selectedDays.insert(day)
        } else {
            selectedDays.remove(day)
        }
    }
    
    func isSelectedDay(_ day: DaysOfWeek) -> Bool {
        selectedDays.contains(day)
    }
}
