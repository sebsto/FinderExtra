//
//  UserPreferences.swift
//  FinderExtra
//
//  Created by Stormacq, Sebastien on 07/09/2020.
//  Copyright © 2020 Stormacq, Sebastien. All rights reserved.
//

import Foundation


enum PreferenceKeys : String {
    case showTerminal
    case showNewFile
    case showCopyPaths
    case startAtLogin
    case closeAutomatically
    case payingCustomer
    case defaultFilename
    case defaultFileExt
    case isFirstLaunch
    case useMenuIcons
}

class UserPreferences : ObservableObject {
    
    @Published var purchased = false
    
    private let defaults   = UserDefaults.init(suiteName: "56U756R2L2.com.stormacq.mac.FinderExtra")!

    private init() {

    }
    static let shared = UserPreferences()
    
    func registerDefaults() {
        defaults.register(defaults: [
            "showCopyPaths": false,
            "showNewFile"  : true,
            "showTerminal" : false,
            "startAtLogin" : false,
            "closeAutomatically" : false,
            "payingCustomer"     : false,
            "useMenuIcons"       : true,
            "defaultFilename"    : "file name",
            "defaultFileExt"     : "txt"
            ])
    }
    
    var displayTerminal    : Bool {
        get { defaults.bool(forKey: PreferenceKeys.showTerminal.rawValue) }
        set { defaults.set(newValue, forKey: PreferenceKeys.showTerminal.rawValue)}
    }
    
    var displayNewFile     : Bool {
        get { defaults.bool(forKey: PreferenceKeys.showNewFile.rawValue) }
        set { defaults.set(newValue, forKey: PreferenceKeys.showNewFile.rawValue)}
    }
    
    var displayCopyPaths   : Bool {
        get { defaults.bool(forKey: PreferenceKeys.showCopyPaths.rawValue) }
        set { defaults.set(newValue, forKey: PreferenceKeys.showCopyPaths.rawValue)}
    }
    
    var startAtLogin       : Bool {
        get { defaults.bool(forKey: PreferenceKeys.startAtLogin.rawValue) }
        set { defaults.set(newValue, forKey: PreferenceKeys.startAtLogin.rawValue)}
    }
    
    var closeAutomatically : Bool {
        get { defaults.bool(forKey: PreferenceKeys.closeAutomatically.rawValue) }
        set { defaults.set(newValue, forKey: PreferenceKeys.closeAutomatically.rawValue)}
    }

    var payingCustomer : Bool {
        get { defaults.bool(forKey: PreferenceKeys.payingCustomer.rawValue) }
        set {
            defaults.set(newValue, forKey: PreferenceKeys.payingCustomer.rawValue)
            // this might trigger a UI refresh, to be executed on the main thread
            DispatchQueue.main.async() {
                self.purchased = newValue
            }
        }
    }
    
    var defaultFilename : String {
        get { defaults.string(forKey: PreferenceKeys.defaultFilename.rawValue) ?? "new file" }
        set { defaults.set(newValue, forKey: PreferenceKeys.defaultFilename.rawValue)}
    }

    var defaultFileExt : String {
        get { defaults.string(forKey: PreferenceKeys.defaultFileExt.rawValue) ?? "txt" }
        set { defaults.set(newValue, forKey: PreferenceKeys.defaultFileExt.rawValue)}
    }
    
    var useMenuIcons : Bool {
        get { defaults.bool(forKey: PreferenceKeys.useMenuIcons.rawValue) }
        set { defaults.set(newValue, forKey: PreferenceKeys.useMenuIcons.rawValue)}
    }
    
    var firstLaunch : Bool {
        get {
            if !defaults.bool(forKey: PreferenceKeys.isFirstLaunch.rawValue) {
                defaults.set(true, forKey: PreferenceKeys.isFirstLaunch.rawValue)
                return true
            } else {
                return false
            }
        }
    }
}
