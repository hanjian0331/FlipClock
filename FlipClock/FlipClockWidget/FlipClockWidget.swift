//
//  FlipClockWidget.swift
//  FlipClockWidget
//
//  Created by hanjian on 2020/10/11.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let oneMinute: TimeInterval = 60
        let currentDate = Date()
        
        let dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: currentDate)
        guard var date = Calendar.current.date(from: dateComponents) else { return }
        
        let totalTime = 15
        for _ in 0 ..< totalTime * 2 {
            let entry = SimpleEntry(date: date, configuration: configuration)
            
            date += oneMinute
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .after(currentDate + Double(totalTime) * oneMinute))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}



struct FlipClockWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            DateWidgetView(date: entry.date)
        case .systemLarge:
            DateWidgetView(date: entry.date)
        default:
            ClockWidgetView(date: entry.date)
        }
    }
}

@main
struct FlipClockWidget: Widget {
    let kind: String = "FlipClockWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            FlipClockWidgetEntryView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
        }
        .configurationDisplayName("Flip Clock Widget")
        .description("This is an flip clock widget.")
//        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct FlipClockWidget_Previews: PreviewProvider {
    static var previews: some View {
        FlipClockWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
