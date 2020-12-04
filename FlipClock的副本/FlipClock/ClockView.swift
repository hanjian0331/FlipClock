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
                let isWidget = geometry.size.width < 300
                let offset: CGFloat = isWidget ? 35 : 70
                
                Text(ampm)
                    .font(isWidget ? .body : .title)
                    .foregroundColor(.red)
                    .padding(ampm == "AM" ?
                        EdgeInsets(top: 0, leading: 0, bottom: geometry.size.height-offset, trailing: geometry.size.width-offset) :
                        EdgeInsets(top: geometry.size.height-offset, leading: 0, bottom: 0, trailing: geometry.size.width-offset)
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

    
    @Published var angel: Double = 0
    
    private var _observer: NSObjectProtocol?
    
    init() {
        switch UIDevice.current.orientation {
            case .landscapeLeft:
                angel = 90
            case .landscapeRight:
                angel = -90
            case .portraitUpsideDown:
                angel = 180
            default:
                angel = 0
        }
        
        // unowned self because we unregister before self becomes invalid
        _observer = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: nil) { [unowned self] note in
            guard let device = note.object as? UIDevice else {
                return
            }
            
            switch device.orientation {
                case .landscapeLeft:
                    angel = 90
                case .landscapeRight:
                    angel = -90
                case .portraitUpsideDown:
                    angel = 180
                default:
                    angel = 0
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
    
    @EnvironmentObject var orientationInfo: OrientationInfo
    
    var body: some View {
        let text = dateFormatHHMMA.string(from: Date())
        let h1 = String(text.prefix(1))
        let h2 = String(text[text.index(text.startIndex, offsetBy: 1)...text.index(text.startIndex, offsetBy: 1)])
        let m1 = String(text[text.index(text.startIndex, offsetBy: 2)...text.index(text.startIndex, offsetBy: 2)])
        let m2 = String(text[text.index(text.startIndex, offsetBy: 3)...text.index(text.startIndex, offsetBy: 3)])
        let ampm = String(text.suffix(2))
    
        VStack {
            let revert = orientationInfo.angel == -90 || orientationInfo.angel == 180

            Card(h1: revert ? m1 : h1, h2: revert ? m2 : h2, ampm: revert ? nil : ampm)
//                .rotationEffect(Angle(degrees: orientationInfo.angel))
                .animation(.linear)
            Card(h1: revert ? h1 : m1, h2: revert ? h2 : m2, ampm: revert ? ampm : nil)
//                .rotationEffect(Angle(degrees: orientationInfo.angel))
                .animation(.linear)
        }
    }
}


struct clockView_Previews: PreviewProvider {
    static var previews: some View {
        ClockView(date: Date())
    }
}

