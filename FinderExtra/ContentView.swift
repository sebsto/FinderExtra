//
//  ContentView.swift
//  FinderExtra
//
//  Created by Stormacq, Sebastien on 31/08/2020.
//  Copyright © 2020 Stormacq, Sebastien. All rights reserved.
//

import SwiftUI
import LaunchAtLogin

struct ContentView: View {
    
    
    @State private var showTerminal       : Bool
    @State private var showNewFile        : Bool
    @State private var showCopyPaths      : Bool
    
    @State private var useMenuIcons       : Bool
    @State private var startAtLogin       : Bool
    @State private var closeAutomatically : Bool
    
    // in app purchases relates structures
    @State private var showAlertCanNotMakePurchase : Bool
    private let store    : StoreManager       = .shared
    
    // user preferences
    @ObservedObject private var prefs    : UserPreferences    = .shared
    
    //    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    //    let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    
    init(preferences : UserPreferences) {
        
        _showTerminal  = State(initialValue: preferences.displayTerminal)
        _showNewFile   = State(initialValue: preferences.displayNewFile)
        _showCopyPaths = State(initialValue: preferences.displayCopyPaths)
        _startAtLogin  = State(initialValue: preferences.startAtLogin)
        _useMenuIcons  = State(initialValue: preferences.useMenuIcons)
        _closeAutomatically = State(initialValue: preferences.closeAutomatically)
        //        _payingCustomer     = State(initialValue: preferences.payingCustomer)
        
        _showAlertCanNotMakePurchase = State(initialValue: !store.isAuthorizedForPayments)
        
    }
    
    var body: some View {
        ZStack {
            // add a wait screen when purchasing
            // https://stackoverflow.com/questions/56496638/activity-indicator-in-swiftui
            
            
            VStack(alignment: .leading, spacing: 10) {
                HStack() {
                    Image("mouse")
                        .resizable()
                        .scaledToFit()
                    VStack(alignment: .leading, spacing: 10) {
                        Text("This app adds contextual menu entries to the Finder")
                            .font(.headline)
                            .fixedSize(horizontal: true, vertical: false)
                        Text("Choose the menu items you want using the selection below")
                            .font(.subheadline)
                    }
                    .padding(10)
                }
                .padding(.vertical, 20)
                
                Divider()
                
                Section {
                    
                    HStack(alignment: .top, spacing: 40) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Control the menu items:")
                                .bold()
                            Toggle("Open terminal", isOn: $showTerminal)
                                .onReceive([showTerminal].publisher.first(), perform: { (value) in
                                    self.prefs.displayTerminal = value
                                })
                                .disabled(!self.prefs.purchased)
                            Toggle("Create empty text file", isOn: $showNewFile)
                                .onReceive([showNewFile].publisher.first(), perform: { (value) in
                                    self.prefs.displayNewFile = value
                                })
                            Toggle("Copy paths to clipboard", isOn: $showCopyPaths)
                                .onReceive([showCopyPaths].publisher.first(), perform: { (value) in
                                    self.prefs.displayCopyPaths = value
                                })
                                .disabled(!self.prefs.purchased)
                        }
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Control the application:")
                                .bold()
                            Toggle("Use icons in menu items", isOn: $useMenuIcons)
                                .onReceive([useMenuIcons].publisher.first(), perform: { (value) in
                                    self.prefs.useMenuIcons = value
                                })
                            Toggle("Start automatically at Login", isOn: $startAtLogin)
                                .onReceive([startAtLogin].publisher.first(), perform: { (value) in
                                    self.prefs.startAtLogin = value
                                    LaunchAtLogin.isEnabled = value // I am not using the LaunchAtLogin.Toggle
                                })
                            Toggle("Close window quits app", isOn: $closeAutomatically)
                                .onReceive([closeAutomatically].publisher.first(), perform: { (value) in
                                    self.prefs.closeAutomatically = value
                                })
                        }
                        .disabled(!self.prefs.purchased)
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                
                Divider()
                
                Spacer()
                
                if (self.prefs.purchased) {
                    Group {
                        Text("Thank you for having purchased the full version of this app")
                    }
                } else {
                    if (store.isAuthorizedForPayments) {
                        HStack() {
                            Text("You can enable all options by buying the full version of this App")
                            Button(action: {
                                StoreManager.shared.doProductRequest() { (products) in
                                    
                                    print("received product list : \(products)")
                                    
                                    // for this app, we know there is only one product
                                    guard products.count == 1 else {
                                        print("Invalid product array")
                                        return
                                    }
                                    StoreManager.shared.buy(product: products[0]) { result in
                                        if result {
                                            print("purchase succeeded")
                                            self.prefs.payingCustomer = true // this also updates prefs.purchased
                                        } else {
                                            print("purchase failed")
                                        }
                                    }
                                }
                            }) {
                                Text("Purchase")
                            }
                        }
                    } else {
                        Text("In App purchases are not allowed.")
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 30)
            .alert(isPresented: $showAlertCanNotMakePurchase) {
                Alert(title: Text("In-App Purchases Status"), message: Text("Purchases are not allowed."))
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let prefs = UserPreferences.shared
        return ContentView(preferences: prefs)
    }
}
