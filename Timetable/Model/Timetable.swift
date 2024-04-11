//
//  Timetable.swift
//  Timetable
//
//  Created by 진현식 on 3/23/24.
//

import Foundation

enum Weekday: Int, CaseIterable {
    case monday = 1, tuesday, wednesday, thursday, friday
    
    var name: String {
        switch self {
        case .monday:
            return "월요일"
        case .tuesday:
            return "화요일"
        case .wednesday:
            return "수요일"
        case .thursday:
            return "목요일"
        case .friday:
            return "금요일"
        }
    }
    
    var range: ClosedRange<Int> {
        switch self {
        case .monday:
            return 0...6
        case .tuesday:
            return 7...13
        case .wednesday:
            return 14...20
        case .thursday:
            return 21...27
        case .friday:
            return 28...34
        }
    }
}
