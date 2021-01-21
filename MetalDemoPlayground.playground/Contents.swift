//: A Cocoa based Playground to present user interface

import SwiftUI
import PlaygroundSupport


//let content = ContentView()

let group = JFFilterItemGroup()

// Present the view in Playground
PlaygroundPage.current.setLiveView(
    ContentView()
        .environmentObject(group)
        .frame(width: 700, height: 450, alignment: .center)
)

