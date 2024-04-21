//
//  TimetableViewModel.swift
//  Timetable
//
//  Created by 진현식 on 4/20/24.
//

import Foundation

class TimetableViewModel {
    
    static let shared = TimetableViewModel()
    
    private var subjects = [String]()
    
    private var classrooms = [String]()
    
    func getSubjects() -> [String] {
        return subjects
    }
    
    func getClassrooms() -> [String] {
        return classrooms
    }
    
    func loadTimetableData() {
        DispatchQueue.global().async {
            var newSubjects = [String]()
            var newClassrooms = [String]()
            
            for i in 1...5 {
                newSubjects.append(contentsOf: UserDefaults.appGroupUserDefaults?.array(forKey: "subjects:\(i)") as? [String] ?? [])
                newClassrooms.append(contentsOf: UserDefaults.appGroupUserDefaults?.array(forKey: "classrooms:\(i)") as? [String] ?? [])
            }
            
            self.subjects = newSubjects
            self.classrooms = newClassrooms
        }
    }
}
