//
//  TimetableWidget.swift
//  TimetableWidget
//
//  Created by 진현식 on 3/27/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> TimetableEntry {
        TimetableEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (TimetableEntry) -> ()) {
        let entry = TimetableEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [TimetableEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        entries.append(TimetableEntry(date: currentDate))

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct TimetableEntry: TimelineEntry {
    var date: Date
}

struct TimetableWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(colorScheme == .dark ? Color(white: 0.1).gradient : Color.white.gradient)
                .padding(-20)
            
            TimetableGrid()
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
    
    let subjects = ["사문탐", "실용경제", "동사", "확통", "동아리", "동아리", "물II"]
    let classrooms = ["3-3", "강1층", "3-3", "3-2", "컴실", "강3층", "3-4"]
    
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
    TimetableEntry(date: .now)
}
