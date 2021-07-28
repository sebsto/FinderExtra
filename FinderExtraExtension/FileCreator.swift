//
//  FileCreator.swift
//  FinderExtraExtension
//
//  Created by Stormacq, Sebastien on 05/09/2020.
//  Copyright © 2020 Stormacq, Sebastien. All rights reserved.
//

import Foundation

struct FileCreator {
    
    let targetUrl     : URL
    let filename      : String
    let fileExtension : String
    
    init(targetUrl: URL, filename: String, fileExtension : String ) {
        self.targetUrl     = targetUrl
        self.filename      = filename
        self.fileExtension = fileExtension
    }
    
    // create a unique file name using the given base and estension
    func createFile() {
        
        let fm = FileManager.default
        
        // find a file name that does not exist
        var counter = 1
        var candidateFilename = self.filename + "." + self.fileExtension
        NSLog("Going to check existence of : \(candidateFilename)")

        while fm.fileExists(atPath: self.targetUrl.appendingPathComponent(candidateFilename).path) {
            candidateFilename = self.filename + " " + String(counter) + "." + self.fileExtension
            counter += 1
            NSLog("Going to check existence of : \(candidateFilename)")
        }
        
        // create an empty file
        do {
            
            NSLog("Going to create file : \(candidateFilename)")
            try "".write(to: self.targetUrl.appendingPathComponent(candidateFilename), atomically: true, encoding: String.Encoding.utf8)
        
        } catch let error as NSError {
            NSLog("Failed to create new file: \(error.localizedDescription)")
        }
    }
}
