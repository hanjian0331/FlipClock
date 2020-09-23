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
        formatter.dateFormat = "hhmm"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter
    }()
    
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            let num = FlipClockWidgetEntryView.dateFormatHH.string(from: entry.date.addingTimeInterval(1.0))
            Card(text: num)
        case .systemMedium:
            let hhmm = FlipClockWidgetEntryView.dateFormatHHMM.string(from: entry.date)
            if hhmm.count != 4 {
                
            } else {
                clockView(text: hhmm)
            }
//            ZStack {
//                HStack {
//                    Spacer(minLength: 0)
//
//                    ZStack {
//                        if hhmm.hasPrefix("0") {
//                            let h = String(hhmm[hhmm.index(hhmm.startIndex, offsetBy: 1)...hhmm.index(hhmm.startIndex, offsetBy: 1)])
//                            Card(text: h)
//                        } else {
//                            let hh = String(hhmm.prefix(2))
//                            Card(text: hh)
//                        }
//
//                        let ampm = String(hhmm.suffix(2))
//
//                        Text(ampm)
//                            .font(.custom("Helvetica Neue", size: 15))
//                            .fontWeight(.medium)
//                            .padding(.top, ampm == "AM" ? -59 : 99)
//                            .padding(.leading, -55.0)
//                    }
//
//
//
//                    Spacer(minLength: 0)
//
//                    Group {
//                        Color("LightGray")
//                            .edgesIgnoringSafeArea(.all)
//                    }.frame(minWidth: 16, maxWidth: 16, minHeight: 0, maxHeight: .infinity, alignment: .center)
//                    Spacer(minLength: 0)
//
//                    let mm = String(hhmm[hhmm.index(hhmm.startIndex, offsetBy: 2)...hhmm.index(hhmm.startIndex, offsetBy: 3)])
//                    Card(text: mm)
//
//                    Spacer(minLength: 0)
//                }
//
//            }
        case .systemLarge:
            let hhmm = FlipClockWidgetEntryView.dateFormatMMDDHHMMSS.string(from: entry.date)
            VStack {
                Spacer(minLength: 0)
                HStack {
                    Spacer(minLength: 0)
                    if hhmm.hasPrefix("0") {
                        let m = String(hhmm[hhmm.index(hhmm.startIndex, offsetBy: 1)...hhmm.index(hhmm.startIndex, offsetBy: 1)])
                        Card(text: m)
                    } else {
                        let mm = String(hhmm.prefix(2))
                        Card(text: mm)
                    }
                    Spacer(minLength: 0)
                    
                    if String(hhmm[hhmm.index(hhmm.startIndex, offsetBy: 2)...hhmm.index(hhmm.startIndex, offsetBy: 2)]) == "0" {
                        let h = String(hhmm[hhmm.index(hhmm.startIndex, offsetBy: 3)...hhmm.index(hhmm.startIndex, offsetBy: 3)])
                        Card(text: h)
                    } else {
                        let dd = String(hhmm[hhmm.index(hhmm.startIndex, offsetBy: 2)...hhmm.index(hhmm.startIndex, offsetBy: 3)])
                        Card(text: dd)
                    }
                    

                    
                    Spacer(minLength: 0)
                }
                
                Spacer(minLength: 0)
                Spacer(minLength: 0)
        
                HStack {
                    Spacer(minLength: 0)
                    
                    ZStack {

                        if String(hhmm[hhmm.index(hhmm.startIndex, offsetBy: 4)...hhmm.index(hhmm.startIndex, offsetBy: 4)]) == "0" {
                            let h = String(hhmm[hhmm.index(hhmm.startIndex, offsetBy: 5)...hhmm.index(hhmm.startIndex, offsetBy: 5)])
                            Card(text: h)
                        } else {
                            let hh = String(hhmm[hhmm.index(hhmm.startIndex, offsetBy: 4)...hhmm.index(hhmm.startIndex, offsetBy: 5)])
                            Card(text: hh)
                        }
                        
                        let ampm = String(hhmm.suffix(2))
                        
                        Text(ampm)
                            .font(.custom("Helvetica Neue", size: 15))
                            .fontWeight(.medium)
                            .padding(.top, ampm == "AM" ? -59 : 99)
                            .padding(.leading, -55.0)
                    }
                    
      
                    
                    Spacer(minLength: 0)

                    let mm = String(hhmm[hhmm.index(hhmm.startIndex, offsetBy: 6)...hhmm.index(hhmm.startIndex, offsetBy: 7)])
                    Card(text: mm)
                    
                    Spacer(minLength: 0)
                }
                Spacer(minLength: 0)
            }
        default:
            Text("韩")
                .font(.custom("Helvetica Neu Bold", size: 100))
            
        }
        
    }
}

struct Card: View {
    
    var text: String
    
    var body: some View {
        ZStack {
            ZStack {
                Color("LightGray")
                    .edgesIgnoringSafeArea(.all)
            }.frame(width: 140, height: 140).cornerRadius(15)
            

            Text(text)
                .font(.custom("Helvetica Neue", size: 100))
                .fontWeight(.medium)
            
            Group {
                Color("Background")
                    .edgesIgnoringSafeArea(.all)
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 3, maxHeight: 3, alignment: .center)
        }
            
    }
    
}


@main
struct FlipClockWidget: Widget {
    let kind: String = "FlipClockWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            FlipClockWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct FlipClockWidget_Previews: PreviewProvider {
    static var previews: some View {
//        FlipClockWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
        FlipClockWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
//        FlipClockWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
