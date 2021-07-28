//
//  AppLauncher.swift
//  FinderExtraExtension
//
//  Created by Stormacq, Sebastien on 07/09/2020.
//  Copyright © 2020 Stormacq, Sebastien. All rights reserved.
//

import Foundation

struct AppLauncher {

    let targetUrl   : URL
    let application : String

    init(targetUrl: URL, application: String) {
        self.targetUrl     = targetUrl
        self.application   = application
    }
    
    func launch() {
        
        do {
            
            let task = Process()
            task.executableURL = URL(fileURLWithPath: "/usr/bin/open")
            task.arguments     = ["-a", self.application, self.targetUrl.absoluteString]
            
            NSLog("Going to execute command : /usr/bin/open -a \(self.application) \(self.targetUrl.absoluteString)")
            try task.run()
        
        } catch let error as NSError {
            NSLog("Failed to open /(self.application).app: \(error.localizedDescription)")
        }
    }
}
