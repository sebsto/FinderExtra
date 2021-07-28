//
//  ClipboardCopier.swift
//  FinderExtraExtension
//
//  Created by Stormacq, Sebastien on 07/09/2020.
//  Copyright © 2020 Stormacq, Sebastien. All rights reserved.
//

import Cocoa

struct ClipboardCopier {
    
    var urls : [URL]
    
    init(selectedUrls : [URL]) {
        self.urls = selectedUrls
    }
    
    func copy() {
        
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        var toCopy = ""
        
        // Loop through all selected paths
        for path in self.urls {
            toCopy.append(contentsOf: path.relativePath)
            toCopy.append("\n")
        }
        toCopy.removeLast() // Remove trailing \n

        pasteboard.setString(toCopy, forType: NSPasteboard.PasteboardType.string)
    }
}
