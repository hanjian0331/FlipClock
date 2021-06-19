//
//  ClockView.swift
//  Flip Clock
//
//  Created by hanjian on 2020/9/21.
//

import SwiftUI

struct Card: View {
    var h1: String
    var h2: String
    let aspectRatio: CGFloat = 454.0 / 468.0
    var ampm: String?
    var week: String?
    
    var body: some View {
        
        GeometryReader { geometry in
        
        ZStack {
            
            VStack(spacing: 0) {
                Image("cover_top_bg")
                    .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                Image("cover_bottom_bg")
                    .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
            }
            
            HStack(spacing: 0) {
                
                let fontSize = min(geometry.size.width, geometry.size.height) / 1.5;
                Text(h1)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .font(.custom("Helvetica Neue", size: fontSize))
                Text(h2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .font(.custom("Helvetica Neue", size: fontSize))
            }
            
            Image("cover_top1")
                    .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
        
            let w = geometry.size.width * 12.0 / 394.0
            let h = w * 120.0 / 24.0
            Image("flip_axle")
                .resizable()
                .frame(width: w, height: h, alignment: .leading)
                .padding(.trailing, geometry.size.width-w)
            Image("flip_axle")
                .resizable()
                .frame(width: w, height: h, alignment: .trailing)
                .padding(.leading, geometry.size.width-w)
            
            let magicNumer: CGFloat = 0.72
            if let ampm = ampm {
                let offset = geometry.size.height / 4
                Text(ampm)
                    .font(.system(size: geometry.size.width*0.191/2))
                    .foregroundColor(.white)
                    .padding(ampm == "AM" ?
                             EdgeInsets(top: 0, leading: 0, bottom: geometry.size.height-offset, trailing: geometry.size.width-offset*1.191) :
                        EdgeInsets(top: geometry.size.height-offset, leading: 0, bottom: 0, trailing: geometry.size.width-offset*1.191)
                    )
            }
            
            if let week = week {
                Text(week)
                    .font(.system(size: geometry.size.width*0.191/2))
                    .foregroundColor(.red)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: geometry.size.height*magicNumer, trailing: 0))
            }

        }
        }.aspectRatio(aspectRatio, contentMode: .fit)
        
    }
}

struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: Value = .zero

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

extension VerticalAlignment {
    struct CustomAlignmentTop: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[VerticalAlignment.top]
        }
    }

    static let customTop = VerticalAlignment(CustomAlignmentTop.self)
    
    struct CustomAlignmentBottom: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[VerticalAlignment.bottom]
        }
    }

    static let customBottom = VerticalAlignment(CustomAlignmentBottom.self)
}

extension Locale {
    var is12HourTimeFormat: Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        dateFormatter.locale = self
        let dateString = dateFormatter.string(from: Date())
        return dateString.contains(dateFormatter.amSymbol) || dateString.contains(dateFormatter.pmSymbol)
    }
}

struct DateWidgetView: View {
    let dateFormatDD: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddEEEE"
        if let language = Locale.preferredLanguages.first {
            formatter.locale = Locale(identifier: language)
        }
//        if let local = UserDefaults(suiteName: "group.com.hj.FlipClock")?.object(forKey: "local") as? String {
//            formatter.locale = Locale(identifier: local)
//        }
        return formatter
    }()
    var date: Date
    var body: some View {
        let text = dateFormatDD.string(from: date).uppercased()
        let d1 = String(text.prefix(1))
        let d2 = String(text[text.index(text.startIndex, offsetBy: 1)...text.index(text.startIndex, offsetBy: 1)])
        let E = String(text[text.index(text.startIndex, offsetBy: 2)...])
        Card(h1: d1, h2: d2, week: E)
    }
}

struct ClockWidgetView: View {
    let dateFormatHHMMA: DateFormatter = {
        let formatter = DateFormatter()
        if formatter.locale.is12HourTimeFormat {
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "hhmma"
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
        } else {
            formatter.dateFormat = "HHmm"
        }
        return formatter
    }()
    
    var date: Date

    var body: some View {
        let text = dateFormatHHMMA.string(from: date)
        let h1 = String(text.prefix(1))
        let h2 = String(text[text.index(text.startIndex, offsetBy: 1)...text.index(text.startIndex, offsetBy: 1)])
        let m1 = String(text[text.index(text.startIndex, offsetBy: 2)...text.index(text.startIndex, offsetBy: 2)])
        let m2 = String(text[text.index(text.startIndex, offsetBy: 3)...text.index(text.startIndex, offsetBy: 3)])
        let ampm = text.count == 4 ? nil : String(text.suffix(2))
        
        
        HStack(spacing: 2) {
            Card(h1: h1, h2: h2, ampm: ampm)
            Card(h1: m1, h2: m2)
        }.padding(.all, 8.0)

    }
}

struct ClockView: View {
    let dateFormatHHMMA: DateFormatter = {
        let formatter = DateFormatter()
        if formatter.locale.is12HourTimeFormat {
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "hhmma"
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
        } else {
            formatter.dateFormat = "HHmm"
        }
        return formatter
    }()
    
    var date: Date
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        let text = dateFormatHHMMA.string(from: Date())
        let h1 = String(text.prefix(1))
        let h2 = String(text[text.index(text.startIndex, offsetBy: 1)...text.index(text.startIndex, offsetBy: 1)])
        let m1 = String(text[text.index(text.startIndex, offsetBy: 2)...text.index(text.startIndex, offsetBy: 2)])
        let m2 = String(text[text.index(text.startIndex, offsetBy: 3)...text.index(text.startIndex, offsetBy: 3)])
        let ampm = text.count == 4 ? nil : String(text.suffix(2))
    
        

        VStack {
            if horizontalSizeClass == .compact && verticalSizeClass == .regular {
                VStack {
                    Card(h1: h1, h2: h2, ampm: ampm)
                    Card(h1: m1, h2: m2, ampm: nil)
                }
            } else {
                HStack {
                    Card(h1: h1, h2: h2, ampm: ampm)
                    Card(h1: m1, h2: m2, ampm: nil)
                }
            }
        }.animation(.linear)
    }
}


struct ClockView_Previews: PreviewProvider {
    struct ContentView: View {
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        @State private var date = Date()
        
        var body: some View {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                ClockView(date: date)
            }
            .onReceive(timer) { time in
                date = Date()
            }
            .statusBar(hidden: true)
        }
    }
    
    static var previews: some View {
        Group {
            ContentView()
//            Card(h1:"1", h2:"3", week:"PM")
        }
    }
}
