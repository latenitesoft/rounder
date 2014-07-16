//
//  ImageProcessor.swift
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
import AppKit

class ImageProcessor {
    class func processImageAtPath(filePath: String, overwrite: Bool) -> Bool
    {
        let imageData = NSData(contentsOfFile: filePath)
        let image : NSImage? = NSImage(data: imageData)
        
        if (image) {
            println("Image size: \(image!.size)")
            if image!.size.width % 2 == 1 || image!.size.height % 2 == 1 {
                println("Fixing...")
                
                let newSize = NSMakeSize(image!.size.width + image!.size.width % 2,
                                         image!.size.height + image!.size.height % 2)
                
                let imageRepresentation = bitmapImageRepresentation(image!, size: newSize)
                let imageData = imageRepresentation.representationUsingType(NSBitmapImageFileType.NSPNGFileType, properties: nil)
                
                var success = false;
                if (overwrite) {
                    success = imageData.writeToFile(filePath, atomically: true)
                } else {
                    success = imageData.writeToFile("\(filePath.stringByDeletingPathExtension)-rounded.png", atomically: true)
                }
                
                if success {
                    println("Created image of size: \(newSize)")
                }
                
                return success
            }
        }
        
        return false
    }
    
    class func bitmapImageRepresentation(image: NSImage, size: NSSize) -> NSBitmapImageRep {
        let width : Int = Int(size.width)
        let height : Int = Int(size.height)
        let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: width, pixelsHigh: height, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: NSDeviceRGBColorSpace, bytesPerRow: 4 * width, bitsPerPixel: 32)
        
        let context = NSGraphicsContext(bitmapImageRep: rep)
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.setCurrentContext(context)
        
        image.drawAtPoint(NSZeroPoint, fromRect: NSZeroRect, operation: NSCompositingOperation.CompositeCopy, fraction: 1.0)
        context.flushGraphics()
        
        NSGraphicsContext.restoreGraphicsState()
        
        return rep
    }
}