//
//  clockView.swift
//  Flip Clock
//
//  Created by hanjian on 2020/9/21.
//

import SwiftUI

struct clockView: View {
    
    var text: String
    
    var body: some View {
        HStack {
            let h1 = String(text.prefix(1))
            let h2 = String(text[text.index(text.startIndex, offsetBy: 1)...text.index(text.startIndex, offsetBy: 1)])
            let m1 = String(text[text.index(text.startIndex, offsetBy: 2)...text.index(text.startIndex, offsetBy: 2)])
            let m2 = String(text.suffix(1))
            let aspectRatio: CGFloat = 454.0 / 468.0
            
            ZStack {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Image("flip_"+h1+"_left_top")
                            .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                            .aspectRatio(aspectRatio, contentMode: .fit)
                        Image("flip_"+h2+"_right_top")
                            .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                            .aspectRatio(aspectRatio, contentMode: .fit)
                    }
 
                    HStack(spacing: 0) {
                        Image("flip_"+h1+"_left_bottom")
                            .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                            .aspectRatio(aspectRatio, contentMode: .fit)
                        Image("flip_"+h2+"_right_bottom")
                            .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                            .aspectRatio(aspectRatio, contentMode: .fit)
                    }
                }
                VStack(spacing: 0) {
                    Image("cover_top")
                        .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                        .aspectRatio(aspectRatio*2, contentMode: .fit)
                    Image("cover_bottom_shadow")
                        .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                        .aspectRatio(aspectRatio*2, contentMode: .fit)
                        .hidden()
                }
                .overlay(
                    GeometryReader { geometry in
                        let w = geometry.size.width * 12.0 / 394.0
                        let h = w * 120.0 / 24.0;
                        
                        HStack(spacing: 0) {
                            Image("flip_axle")
                                .resizable()
                                .frame(width: w, height: h, alignment: .leading)
                        }.frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
                        HStack {
                            Image("flip_axle")
                                .resizable()
                                .frame(width: w, height: h, alignment: .trailing)
                        }.frame(width: geometry.size.width, height: geometry.size.height, alignment: .trailing)
                    }
                )

            }
            ZStack {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Image("flip_"+m1+"_left_top")
                            .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                            .aspectRatio(aspectRatio, contentMode: .fit)
                        Image("flip_"+m2+"_right_top")
                            .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                            .aspectRatio(aspectRatio, contentMode: .fit)
                    }
 
                    HStack(spacing: 0) {
                        Image("flip_"+m1+"_left_bottom")
                            .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                            .aspectRatio(aspectRatio, contentMode: .fit)
                        Image("flip_"+m2+"_right_bottom")
                            .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                            .aspectRatio(aspectRatio, contentMode: .fit)
                    }
                }
                VStack(spacing: 0) {
                    Image("cover_top")
                        .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                        .aspectRatio(aspectRatio*2, contentMode: .fit)
                    Image("cover_bottom_shadow")
                        .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                        .aspectRatio(aspectRatio*2, contentMode: .fit)
                        .hidden()

                }
                .overlay(
                    GeometryReader { geometry in
                        let w = geometry.size.width * 12.0 / 394.0
                        let h = w * 120.0 / 24.0;
                        
                        HStack(spacing: 0) {
                            Image("flip_axle")
                                .resizable()
                                .frame(width: w, height: h, alignment: .leading)
                        }.frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
                        HStack {
                            Image("flip_axle")
                                .resizable()
                                .frame(width: w, height: h, alignment: .trailing)
                        }.frame(width: geometry.size.width, height: geometry.size.height, alignment: .trailing)
                    }
                )
            }
        }.padding(.all, 8)
    }
}

struct clockView_Previews: PreviewProvider {
    static var previews: some View {
        clockView(text: "1234")
    }
}
