//
//  ContentView.swift
//  Metal Demo
//
//  Created by Joshua Fahey on 9/27/20.
//
//  Dedicated to Our Lady, Seat of Wisdom

import SwiftUI

public struct ContentView: View {
    
    public init(){}
    
    public var body: some View {
        HStack{
            JFFilterListView()
            Spacer()
            JFSourceView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
