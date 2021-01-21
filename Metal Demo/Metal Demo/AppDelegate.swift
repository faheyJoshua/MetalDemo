//
//  AppDelegate.swift
//  Metal Demo
//
//  Created by Joshua Fahey on 9/27/20.
//
//  Dedicated to Our Lady, Seat of Wisdom

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!
    
    var group = JFFilterItemGroup()

    var saveMenu = SaveMenu()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        
        let contentView = ContentView()
            .environmentObject(group)
            .environmentObject(saveMenu)
            .frame(minWidth: 500, minHeight:500)

        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }
    
    @IBAction func saveImage(_ sender: Any){
        saveMenu.isSaving = true
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

