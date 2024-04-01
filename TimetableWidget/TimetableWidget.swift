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
        entries.append(TimetableEntry(date: Date()))

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
            
            HStack(alignment: .center, content: {
                PeriodTextView()
                SubjectTextView(subjects: ["국어", "영어", "수학", "과학", "체육", "경제", "사회"])
                ClassroomTextView(classrooms: ["3-1", "3-2", "3-3", "3-4", "체육관", "2-3", "1-1"])
            })
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
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
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

#Preview(as: .systemSmall) {
    TimetableWidget()
} timeline: {
    TimetableEntry(date: .now)
}
