//
//  FlipClockWidget.swift
//  FlipClockWidget
//
//  Created by hanjian on 2020/8/30.
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
        let currentDate = Date()
        
        let dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: currentDate)
        guard let date = Calendar.current.date(from: dateComponents) else { return }
        
        for hourOffset in 0 ..< 10 {
            
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: date)!
            
//            let entryDate = currentDate.addingTimeInterval(TimeInterval(hourOffset)/10)
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct FlipClockWidgetEntryView : View {
    var entry: Provider.Entry
    static let dateFormatHH: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH"
            return formatter }()
    static let dateFormatMMDDHHMMSS: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMddhhmma"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter
    }()
    static let dateFormatHHMM: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "hhmma"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter
    }()
    
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemMedium:
            let hhmm = FlipClockWidgetEntryView.dateFormatHHMM.string(from: entry.date)
            clockView(text: hhmm)
        default:
            Text("韩")
                .font(.custom("Helvetica Neu Bold", size: 100))
            
        }
        
    }
}

//struct Card: View {
//    
//    var text: String
//    
//    var body: some View {
//        ZStack {
//            ZStack {
//                Color("LightGray")
//                    .edgesIgnoringSafeArea(.all)
//            }.frame(width: 140, height: 140).cornerRadius(15)
//            
//
//            Text(text)
//                .font(.custom("Helvetica Neue", size: 100))
//                .fontWeight(.medium)
//            
//            Group {
//                Color("Background")
//                    .edgesIgnoringSafeArea(.all)
//            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 3, maxHeight: 3, alignment: .center)
//        }
//            
//    }
//    
//}


@main
struct FlipClockWidget: Widget {
    let kind: String = "FlipClockWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            FlipClockWidgetEntryView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
    }
}

struct FlipClockWidget_Previews: PreviewProvider {
    static var previews: some View {
//        FlipClockWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
        FlipClockWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
//        FlipClockWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
