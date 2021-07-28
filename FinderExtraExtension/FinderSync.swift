//
//  FinderSync.swift
//  FinderExtraExtension
//
//  Created by Stormacq, Sebastien on 31/08/2020.
//  Copyright © 2020 Stormacq, Sebastien. All rights reserved.
//

import AppKit
import Cocoa
import FinderSync


enum MenuItemTags : Int {
    case createFile   = 1
    case openTerminal = 2
    case copyPath     = 3
}

class FinderSync: FIFinderSync {

    let prefs : UserPreferences = .shared

    let foldersToMonitor = URL(fileURLWithPath: "/")
    
    override init() {
        
        NSLog("FinderSync() launched from \(Bundle.main.bundlePath as NSString)")
        
        // Set up the directory we are syncing.
        FIFinderSyncController.default().directoryURLs = [self.foldersToMonitor]
        
        super.init()

    }
    
    // MARK: - Primary Finder Sync protocol methods
    
    override func beginObservingDirectory(at url: URL) {
        // The user is now seeing the container's contents.
        // If they see it in more than one view at a time, we're only told once.
        NSLog("beginObservingDirectoryAtURL: \(url.path)")
    }
    
    override func endObservingDirectory(at url: URL) {
        // The user is no longer seeing the container's contents.
        NSLog("endObservingDirectoryAtURL: \(url.path)")
    }
    
    // MARK: - Menu and toolbar item support
    
    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        
        NSLog("menu for menuKind")

        let showTerminal = prefs.displayTerminal
        let showNewFile  = prefs.displayNewFile
        let showCopyPath = prefs.displayCopyPaths
        

        // Produce a menu for the extension.
        let menu = NSMenu(title: "")
        
        if showTerminal {
            let menuItem = NSMenuItem(title: "Open a Terminal", action: #selector(handleContextualMenu(_:)), keyEquivalent: "")
            if prefs.useMenuIcons {
                menuItem.image = NSImage(named: NSImage.Name("shell"))
            }
            menuItem.tag   = MenuItemTags.openTerminal.rawValue
            menu.addItem(menuItem)
        }
        if showNewFile {
            let menuItem = NSMenuItem(title: "Create new text file", action: #selector(handleContextualMenu(_:)), keyEquivalent: "")
            if prefs.useMenuIcons {
                menuItem.image = NSImage(named: NSImage.Name("doc"))
            }
            menuItem.tag   = MenuItemTags.createFile.rawValue
            menu.addItem(menuItem)
        }
        if showCopyPath {
            let menuItem = NSMenuItem(title: "Copy paths", action: #selector(handleContextualMenu(_:)), keyEquivalent: "")
            if prefs.useMenuIcons {
                menuItem.image = NSImage(named: NSImage.Name("copy"))
            menuItem.tag   = MenuItemTags.copyPath.rawValue
            }
            menu.addItem(menuItem)
        }

        return menu
    }
    
    @IBAction func handleContextualMenu(_ sender: AnyObject?) {
        NSLog("Handle Contextual Menu")
        let target          = FIFinderSyncController.default().targetedURL()
        let targetSelection = FIFinderSyncController.default().selectedItemURLs()

        let item = sender as! NSMenuItem
        NSLog("Received menu click for menu item \(item) with tag \(item.tag)")
        
        guard let destinationURL = target  else {
            NSLog("Target URL is nil, can not handle it")
            return
        }
        guard let selectedURLs = targetSelection else {
            NSLog("Selection Target URLs is nil, can not handle it")
            return
        }

        switch item.tag {
            case MenuItemTags.createFile.rawValue:
                let fc = FileCreator(targetUrl: destinationURL, filename: prefs.defaultFilename, fileExtension: prefs.defaultFileExt)
                fc.createFile()
            case MenuItemTags.openTerminal.rawValue:
                let al = AppLauncher(targetUrl: destinationURL, application: "terminal")
                al.launch()
            case MenuItemTags.copyPath.rawValue:
                let cc = ClipboardCopier(selectedUrls: selectedURLs)
                cc.copy()
            default:
                NSLog("Unknown menu option : \(item.tag)")
        }
    }

}

