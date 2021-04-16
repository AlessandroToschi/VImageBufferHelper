//
//  VImageBuffer.swift
//  VImageBufferHelper
//
//  Created by Alessandro Toschi on 16/04/21.
//

import Foundation
import Accelerate

public protocol VImageBuffer {
    
    var buffer: vImage_Buffer { get }
    var pixelFormat: VImagePixelFormat { get }
    
    var width: Int { get }
    var height: Int { get }
    
    var count: Int { get }
    
    var rowBytes: Int { get }
    var size: Int { get }
    
    var contiguousRowBytes: Int { get }
    var contiguousSize: Int { get }
    var isContiguous: Bool { get }
    
}

public extension VImageBuffer {
    
    var width: Int { Int(buffer.width) }
    var height: Int { Int(buffer.height) }
    
    var count: Int { self.width * self.height }
    
    var rowBytes: Int { buffer.rowBytes }
    var size: Int { self.rowBytes * self.height }
    
    var contiguousRowBytes: Int { self.width * self.pixelFormat.bytesPerPixel }
    var contiguousSize: Int { self.contiguousRowBytes * self.height}
    var isContiguous: Bool { self.rowBytes == self.contiguousRowBytes }
}
