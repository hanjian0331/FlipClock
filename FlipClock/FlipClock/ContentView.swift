//
//  ContentView.swift
//  FlipClock
//
//  Created by hanjian on 2020/10/11.
//

import SwiftUI

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
//        .environmentObject(OrientationInfo())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
