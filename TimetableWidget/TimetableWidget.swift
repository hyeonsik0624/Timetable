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
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = TimetableEntry(date: Date())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct TimetableEntry: TimelineEntry {
    var date: Date
}

struct TimetableWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            TimetableWidgetView(period: 1, subject: "국어", classroom: "3-2")
            TimetableWidgetView(period: 2, subject: "영어", classroom: "3-1")
            TimetableWidgetView(period: 3, subject: "과학", classroom: "3-3")
            TimetableWidgetView(period: 4, subject: "체육", classroom: "체육관")
            TimetableWidgetView(period: 5, subject: "실용경제", classroom: "강의동 1층")
            TimetableWidgetView(period: 6, subject: "영독작", classroom: "3-4")
            TimetableWidgetView(period: 7, subject: "물2", classroom: "3-2")
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

struct TimetableWidgetView: View {
    let period: Int
    let subject: String
    let classroom: String
    
    var body: some View {
        HStack {
            VStack {
                Text("\(period):")
                    .fontWeight(.light)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            VStack {
                Text(subject)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            VStack {
                Text(classroom)
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}

#Preview(as: .systemSmall) {
    TimetableWidget()
} timeline: {
    TimetableEntry(date: .now)
}
