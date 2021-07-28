//
//  AppDelegate.swift
//  FinderExtra
//
//  Created by Stormacq, Sebastien on 31/08/2020.
//  Copyright © 2020 Stormacq, Sebastien. All rights reserved.
//

import Cocoa
import SwiftUI
import FinderSync

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var window: NSWindow!
    private let prefs   = UserPreferences.shared
    private let store   = StoreManager.shared
    
    //temp for testing
    private let a : AnalyticsManager = AnalyticsManager()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // Show extensions, if it is not enabled and at first launch only
        if !FIFinderSyncController.isExtensionEnabled && prefs.firstLaunch {
            FIFinderSyncController.showExtensionManagementInterface()
        }
        
        // register default values for preferences
        prefs.registerDefaults()
        
        // prepare the in app purchase
        store.register() { result in
            
            print("register \(result)")
            // this might trigger a UI refresh, to be executed on the main thread
            DispatchQueue.main.async() {
                self.prefs.payingCustomer = result
            }
        }

        // create and prepare the main window
        self.window = self.createWindow()

        //self.a.testS3()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        
        // Remove the in App Purchase observer.
        store.unregister()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return UserPreferences.shared.closeAutomatically
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if flag {
            self.window.orderFront(self)
        } else {
            self.window.makeKeyAndOrderFront(self)
        }
        return true
    }

    // Create the SwiftUI view that provides the window contents.
    @discardableResult
    func createWindow() -> NSWindow {

        let contentView = ContentView(preferences: prefs)
        
        // Create the window and set the content view.
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 580, height: 360),
            styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
            backing: .buffered, defer: false)

        window.center()
        window.setFrameAutosaveName(ProcessInfo.processInfo.processName)
        window.isReleasedWhenClosed = false // keep the window around to be able to shoz it again
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)

        return window
    }
}


struct AppDelegate_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
