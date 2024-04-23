//
//  TimetableWidget.swift
//  TimetableWidget
//
//  Created by 진현식 on 3/27/24.
//

import WidgetKit
import SwiftUI

let appGroupUserDefaults = UserDefaults(suiteName: "group.dev.hyeonsik.timetable")

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> TimetableEntry {
        let subjects = ["국", "영", "수", "사", "과", "국", "영"]
        let classrooms = ["1", "2", "3", "4", "5", "6", "7"]
        
        return TimetableEntry(date: Date(), subjects: subjects, classrooms: classrooms)
    }

    func getSnapshot(in context: Context, completion: @escaping (TimetableEntry) -> ()) {
        let subjects = ["국", "영", "수", "사", "과", "국", "영"]
        let classrooms = ["1", "2", "3", "4", "5", "6", "7"]
        
        let entry = TimetableEntry(date: Date(), subjects: subjects, classrooms: classrooms)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [TimetableEntry] = []

        let currentDate = Date()
        
        var weekDay = Calendar.current.component(.weekday, from: currentDate) - 1
        
        if weekDay == 6 || weekDay == 7 {
            weekDay = 1
        }
        
        let subjects = appGroupUserDefaults?.array(forKey: "subjects:\(weekDay)") as? [String] ?? []
        let classrooms = appGroupUserDefaults?.array(forKey: "classrooms:\(weekDay)") as? [String] ?? []
        
        entries.append(TimetableEntry(date: currentDate, subjects: subjects, classrooms: classrooms))
        
        var nextUpdateDate = Calendar.current.startOfDay(for: currentDate)
        nextUpdateDate = Calendar.current.date(bySettingHour: 3, minute: 0, second: 0, of: nextUpdateDate)!

        if nextUpdateDate <= currentDate {
            nextUpdateDate = Calendar.current.date(byAdding: .day, value: 1, to: nextUpdateDate)!
        }

        let timeline = Timeline(entries: entries, policy: .after(nextUpdateDate))
        completion(timeline)
    }
}

struct TimetableEntry: TimelineEntry {
    var date: Date
    var subjects: [String]
    var classrooms: [String]
}

struct TimetableWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(colorScheme == .dark ? Color(white: 0.1).gradient : Color.white.gradient)
                .padding(-20)
            
            TimetableGrid(subjects: entry.subjects, classrooms: entry.classrooms)
        }
    }
}

struct TimetableWidget: Widget {
    let kind: String = "TimetableWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                TimetableWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                TimetableWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("시간표")
        .description("위젯으로 시간표를 빠르게 확인해 보세요")
        .supportedFamilies([.systemSmall])
    }
}

struct PeriodTextView: View {
    let offset = 7
    
    var body: some View {
        VStack {
            ForEach(1...offset, id: \.self) { i in
                Text("\(i):")
                    .fontWeight(.light)
            }
        }
    }
}

struct SubjectTextView: View {
    let subjects: [String]
    
    var body: some View {
        VStack {
            ForEach(subjects, id: \.self) { subject in
                Text(subject)
                    .fontWeight(.heavy)
            }
        }
    }
}

struct ClassroomTextView: View {
    let classrooms: [String]
    
    var body: some View {
        VStack {
            ForEach(classrooms, id: \.self) { classroom in
                Text(classroom)
                    .fontWeight(.medium)
                    .fontDesign(.rounded)
                    .lineLimit(1)
            }
        }
    }
}

struct TimetableGrid: View {
    let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 3)
    
    var subjects: [String]
    var classrooms: [String]
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            PeriodGrid(numberOfPeriod: subjects.count)
            SubjectGrid(subjects: subjects)
            ClassroomGrid(classrooms: classrooms)
        }
    }
}

struct PeriodGrid: View {
    let rows: [GridItem] = Array(repeating: GridItem(.flexible()), count: 7)
    
    let numberOfPeriod: Int
    
    var body: some View {
        LazyHGrid(rows: rows, content: {
            ForEach(1...numberOfPeriod, id: \.self) { i in
                Text("\(i):")
                    .fontWeight(.light)
                    .font(.system(size: 16))
            }
        })
    }
}

struct SubjectGrid: View {
    let rows: [GridItem] = Array(repeating: GridItem(.flexible()), count: 7)
    
    let subjects: [String]
    
    var body: some View {
        LazyHGrid(rows: rows, content: {
            ForEach(1...subjects.count, id: \.self) { i in
                Text(subjects[i - 1])
                    .fontWeight(.heavy)
                    .font(.system(size: 17))
            }
        })
    }
}

struct ClassroomGrid: View {
    let rows: [GridItem] = Array(repeating: GridItem(.flexible()), count: 7)
    
    let classrooms: [String]
    
    var body: some View {
        LazyHGrid(rows: rows, content: {
            ForEach(1...classrooms.count, id: \.self) { i in
                Text(classrooms[i - 1])
                    .font(.system(size: 16))
                    .fontWeight(.regular)
                    .fontDesign(.rounded)
            }
        })
    }
}

#Preview(as: .systemSmall) {
    TimetableWidget()
} timeline: {
    let subjects = ["국", "영", "수", "사", "과", "국", "영"]
    let classrooms = ["1", "2", "3", "4", "5", "6", "7"]
    
    TimetableEntry(date: Date(), subjects: subjects, classrooms: classrooms)
}
