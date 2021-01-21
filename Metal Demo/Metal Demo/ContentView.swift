//
//  ContentView.swift
//  Metal Demo
//
//  Created by Joshua Fahey on 9/27/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack{
            JFFilterListView()
                .frame(maxWidth: 350)
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
