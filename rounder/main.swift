//
//  main.swift
//  rounder
//
//  Created by Jorge on 16/07/14.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014 LateNiteSoft.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation

extension String {
    subscript (i: Int) -> String {
        return String(Array(self)[i])
    }
}

func showHeader() {
    println("Rounder 1.0")
    println("Copyright (c) LateNiteSoft 2014")
    println("Make image dimensions multiples of two.")
    println()
}

func showUsage() {
    println("Usage: rounder image-name-regex-pattern [-p]")
    println("Optional parameter -p makes rounder preserve the original file.")
    exit(1)
}

func main() {
    showHeader()
    
    let arguments = Process.arguments
    
    var preserveOriginal : Bool = false
    
    if arguments.count < 2 || arguments.count > 3 {
        showUsage()
    }
    
    if arguments.count == 3 {
        if arguments[2] != "-p" {
            showUsage()
        } else {
            preserveOriginal = true
        }
    }
    
    let currentPath = NSFileManager.defaultManager().currentDirectoryPath
    println("Base directory is \(currentPath)")
    
    var error : NSError?
    let regex = NSRegularExpression.regularExpressionWithPattern(arguments[1], options: NSRegularExpressionOptions.CaseInsensitive, error: &error)
    
    if error {
        println("Bad regex: \(error)")
        exit(2)
    }
    
    let contentsAtPath = NSFileManager.defaultManager().contentsOfDirectoryAtPath(currentPath, error: nil) as [String]
    for file in contentsAtPath {
        let filename = file.lastPathComponent
        
        let filenameLength = filename.utf16Count
        if filename[0] == "." || filenameLength == 0 {
            continue
        }
        let matches = regex.numberOfMatchesInString(filename, options: NSMatchingOptions(0), range: NSMakeRange(0, filenameLength))
        if (matches > 0) {
            println("\nProcessing file \(file)")
            let result = ImageProcessor.processImageAtPath("\(currentPath)/\(filename)", overwrite: !preserveOriginal)
            
            if (result) {
                println("Fixed \(filename)")
            }
        }
    }
}

main()

