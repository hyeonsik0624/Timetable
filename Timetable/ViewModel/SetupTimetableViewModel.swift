//
//  SetupTimetableViewModel.swift
//  Timetable
//
//  Created by 진현식 on 4/20/24.
//

import Foundation

class SetupTimetableViewModel {
    
    static let shared = SetupTimetableViewModel()
    
    private var day = Weekday.monday
    
    private var timetableData = [String]()
    
    var shouldShowBackButton: Bool {
        return day != .monday
    }
    
    func changeDay(toNextDay: Bool, completion: @escaping (Bool) -> Void) {
        var newDay: Weekday?
        
        if toNextDay {
            newDay = Weekday(rawValue: day.rawValue + 1)
        } else {
            newDay = Weekday(rawValue: day.rawValue - 1)
        }
        
        if let newDay = newDay {
            day = newDay
            completion(false)
        } else {
            completion(true)
        }
    }
    
    func getDayName() -> String {
        return self.day.name
    }
    
    func getGuideText() -> String {
        return "\(getDayName()) 시간표를 입력해 주세요"
    }
    
    func saveTimetableData(subjectsData: [String], classroomsData: [String], completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            UserDefaults.appGroupUserDefaults?.setValue(subjectsData, forKey: "subjects:\(self.day.rawValue)")
            UserDefaults.appGroupUserDefaults?.setValue(classroomsData, forKey: "classrooms:\(self.day.rawValue)")
            completion()
        }
    }
    
    func loadTimetableData(completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            var subjects = [String]()
            var classrooms = [String]()
            var results = [String]()

            let subjectsData = UserDefaults.appGroupUserDefaults?.array(forKey: "subjects:\(self.day.rawValue)") as? [String] ?? []
            let classroomsData = UserDefaults.appGroupUserDefaults?.array(forKey: "classrooms:\(self.day.rawValue)") as? [String] ?? []
            subjects.append(contentsOf: subjectsData)
            classrooms.append(contentsOf: classroomsData)
            
            guard !subjects.isEmpty else { return }
            for i in 0...subjects.count - 1 {
                results.append(subjects[i])
                
                if i < classrooms.count {
                    results.append(classrooms[i])
                }
            }
            
            self.timetableData = results
            completion()
        }
    }
    
    func getTimetableData() -> [String] {
        return timetableData
    }
}
