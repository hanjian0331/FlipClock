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
    
    var body: some View {
        
        GeometryReader { geometry in
        
        ZStack {
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    Image("flip_"+h1+"_left_top")
                        .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                    Image("flip_"+h1+"_left_bottom")
                        .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                }
                VStack(spacing: 0) {
                    Image("flip_"+h2+"_right_top")
                        .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                    Image("flip_"+h2+"_right_bottom")
                        .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                }
            }
            
            
            VStack(spacing: 0) {
                Image("cover_top")
                    .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                Image("")
                    .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                    .hidden()
            }
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
            if let ampm = ampm {
                Text(ampm)
                    .font(.body)
                    .foregroundColor(.red)
                    .padding(ampm == "AM" ?
                        EdgeInsets(top: 0, leading: 0, bottom: geometry.size.height-35, trailing: geometry.size.width-35) :
                        EdgeInsets(top: geometry.size.height-35, leading: 0, bottom: 0, trailing: geometry.size.width-35)
                    )
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


final class OrientationInfo: ObservableObject {
    enum Orientation {
        case portrait
        case landscape
        case flat
    }
    
    @Published var orientation: Orientation
    
    private var _observer: NSObjectProtocol?
    
    init() {
        // fairly arbitrary starting value for 'flat' orientations
        if UIDevice.current.orientation.isLandscape {
            self.orientation = .landscape
        }
        else {
            self.orientation = .portrait
        }
        
        // unowned self because we unregister before self becomes invalid
        _observer = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: nil) { [unowned self] note in
            guard let device = note.object as? UIDevice else {
                return
            }
            if device.orientation.isPortrait {
                self.orientation = .portrait
            }
            else if device.orientation.isLandscape {
                self.orientation = .landscape
            }
        }
    }
    
    deinit {
        if let observer = _observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

struct ClockWidgetView: View {
    let dateFormatHHMMA: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "hhmma"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter
    }()
    var date: Date

    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        let text = dateFormatHHMMA.string(from: date)
        let h1 = String(text.prefix(1))
        let h2 = String(text[text.index(text.startIndex, offsetBy: 1)...text.index(text.startIndex, offsetBy: 1)])
        let m1 = String(text[text.index(text.startIndex, offsetBy: 2)...text.index(text.startIndex, offsetBy: 2)])
        let m2 = String(text[text.index(text.startIndex, offsetBy: 3)...text.index(text.startIndex, offsetBy: 3)])
        let ampm = String(text.suffix(2))
        
        
        HStack(spacing: 2) {
            Card(h1: h1, h2: h2, ampm: ampm)
            Card(h1: m1, h2: m2)
        }.padding(.all, 8.0)

    }
}

struct ClockView: View {
    let dateFormatHHMMA: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "hhmma"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter
    }()
    var date: Date
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @EnvironmentObject var orientationInfo: OrientationInfo
    
    var body: some View {
        let text = dateFormatHHMMA.string(from: Date())
        let h1 = String(text.prefix(1))
        let h2 = String(text[text.index(text.startIndex, offsetBy: 1)...text.index(text.startIndex, offsetBy: 1)])
        let m1 = String(text[text.index(text.startIndex, offsetBy: 2)...text.index(text.startIndex, offsetBy: 2)])
        let m2 = String(text[text.index(text.startIndex, offsetBy: 3)...text.index(text.startIndex, offsetBy: 3)])
        let ampm = String(text.suffix(2))
    
        
        if horizontalSizeClass == .compact && verticalSizeClass == .compact {
            HStack(spacing: 6) {
                Card(h1: h1, h2: h2, ampm: ampm)
                Card(h1: m1, h2: m2)
            }
        } else if horizontalSizeClass == .regular {
            HStack(spacing: 6) {
                Card(h1: h1, h2: h2, ampm: ampm)
                Card(h1: m1, h2: m2)
            }
        } else {
            VStack {
                Card(h1: h1, h2: h2, ampm: ampm)
                Card(h1: m1, h2: m2)
            }
        }


    }
}


struct clockView_Previews: PreviewProvider {
    static var previews: some View {
        ClockView(date: Date())
    }
}

