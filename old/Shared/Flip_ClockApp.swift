//
//  Flip_ClockApp.swift
//  Shared
//
//  Created by hanjian on 2020/8/30.
//

import SwiftUI


@main
struct Flip_ClockApp: App {


    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var date = Date()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                ClockView(date: date)
            }
            .onReceive(timer) { time in
                date = Date()
            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(Color.black)
            .statusBar(hidden: true)
            .environmentObject(OrientationInfo())
            .supportedOrientations(.portrait)
        }
    }
}


