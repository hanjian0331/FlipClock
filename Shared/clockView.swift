//
//  clockView.swift
//  Flip Clock
//
//  Created by hanjian on 2020/9/21.
//

import SwiftUI

struct Card: View {
    var h1: String
    var h2: String
    let aspectRatio: CGFloat = 454.0 / 468.0

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
                Image("cover_bottom_shadow")
                    .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                    .hidden()
                    .background(
                                    GeometryReader { proxy in
                                        Color.clear
                                        .preference(key: SizePreferenceKey.self, value: proxy.size)
                                    }
                                )
            }
            let w = geometry.size.width * 12.0 / 394.0
            let h = w * 120.0 / 24.0
            Image("flip_axle")
                .resizable()
                .frame(width: w, height: h, alignment: .leading)
                .padding(.trailing, geometry.size.width)
            Image("flip_axle")
                .resizable()
                .frame(width: w, height: h, alignment: .leading)
                .padding(.leading, geometry.size.width)

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


struct clockView: View {
    
    var text: String

    
    var body: some View {
        let h1 = String(text.prefix(1))
        let h2 = String(text[text.index(text.startIndex, offsetBy: 1)...text.index(text.startIndex, offsetBy: 1)])
        let m1 = String(text[text.index(text.startIndex, offsetBy: 2)...text.index(text.startIndex, offsetBy: 2)])
        let m2 = String(text[text.index(text.startIndex, offsetBy: 3)...text.index(text.startIndex, offsetBy: 3)])
        let ampm = String(text.suffix(2))
        
        HStack(alignment: ampm == "AM" ? .customTop : .customBottom) {
            
            Card(h1: h1, h2: h2)
            Card(h1: m1, h2: m2)
            
            Text(ampm)
                .foregroundColor(.red)
    
        }.padding(.all, 8.0)
    }
}

struct clockView_Previews: PreviewProvider {
    static var previews: some View {
        clockView(text: "1234PM")
//        ContentView1()
    }
}
