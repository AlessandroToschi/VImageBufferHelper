//
//  VImageBufferWrapper.swift
//  VImageBufferHelper
//
//  Created by Alessandro Toschi on 10/04/21.
//

import Foundation
import Accelerate

public class VImageBufferWrapper: VImageBuffer{
    // MARK: Stored Properties
    
    public private(set) var buffer: vImage_Buffer
    public private(set) var pixelFormat: VImagePixelFormat
    
    public var `weak`: VImageBufferWeakWrapper {
        
        VImageBufferWeakWrapper(buffer: self.buffer, pixelFormat: self.pixelFormat)
        
    }
    
    // MARK: - Static
    
    private static func alignmentAndRowBytes(_ width: Int, _ height: Int, _ pixelFormat: VImagePixelFormat, _ contiguous: Bool) -> (alignment: Int, rowBytes: Int) {
        guard !contiguous,
              let preferredSettings = try? vImage_Buffer.preferredAlignmentAndRowBytes(width: width, height: height, bitsPerPixel: UInt32(pixelFormat.bitsPerPixel)) else {
            return (64, width * pixelFormat.bytesPerPixel)
        }
        
        return preferredSettings
    }
    
    // MARK: - Constructors
    
    public convenience init() {
        
        self.init(width: 0, height: 0, pixelFormat: .mono8, contiguous: true)
        
    }
    
    public convenience init(width: Int, height: Int, pixelFormat: VImagePixelFormat, contiguous: Bool = false) {
        
        guard width >= 0, height >= 0 else { fatalError("Width and height must be greater or equal to zero") }
        
        let (alignment, rowBytes) = VImageBufferWrapper.alignmentAndRowBytes(width, height, pixelFormat, contiguous)
        let rawPointer = UnsafeMutableRawPointer.allocate(byteCount: width * rowBytes, alignment: alignment)
        
        self.init(
            vImage_Buffer(data: rawPointer,
                          height: vImagePixelCount(height),
                          width: vImagePixelCount(width),
                          rowBytes: rowBytes),
            pixelFormat
        )
        
    }
    
    init(_ buffer: vImage_Buffer, _ pixelFormat: VImagePixelFormat) {
        
        self.buffer = buffer
        self.pixelFormat = pixelFormat
        
    }
    
    // MARK: - Destructor
    
    deinit {
        
        self.buffer.free()
        
    }
    
    // MARK: Realloc
    
    public func reallocIfNeeded(width: Int, height: Int, pixelFormat: VImagePixelFormat, contiguous: Bool = false) {
        
        guard width > 0, height > 0 else { return }
        
        if self.width == width, self.height == height, self.pixelFormat == pixelFormat, self.isContiguous == contiguous { return }
        
        self.buffer.free()
        
        let (alignment, rowBytes) = VImageBufferWrapper.alignmentAndRowBytes(width, height, pixelFormat, contiguous)
        let rawPointer = UnsafeMutableRawPointer.allocate(byteCount: width * rowBytes, alignment: alignment)
        
        self.buffer = vImage_Buffer(data: rawPointer, height: vImagePixelCount(height), width: vImagePixelCount(width), rowBytes: rowBytes)
        self.pixelFormat = pixelFormat
    }
    
    public func reallocIfNeeded(imageBufferWrapper: VImageBufferWrapper, contiguous: Bool = false) {
        self.reallocIfNeeded(width: imageBufferWrapper.width, height: imageBufferWrapper.height, pixelFormat: imageBufferWrapper.pixelFormat, contiguous: contiguous)
    }
    
    // MARK: Buffer Pointers
    
    public func mutableBufferPointer<T>(type: T.Type) -> UnsafeMutableBufferPointer<T>? {
        
        guard self.isContiguous, MemoryLayout<T>.size == self.pixelFormat.bytesPerPixel else { return nil }
        
        let mutableRawBufferPointer = UnsafeMutableRawBufferPointer(start: self.buffer.data, count: self.size)
        return mutableRawBufferPointer.bindMemory(to: type)
        
    }
    
    public func bufferPointer<T>(type: T.Type) -> UnsafeBufferPointer<T>? {
        
        guard self.isContiguous, MemoryLayout<T>.size == self.pixelFormat.bytesPerPixel else { return nil }
        
        let rawBufferPointer = UnsafeRawBufferPointer(start: self.buffer.data, count: self.size)
        return rawBufferPointer.bindMemory(to: type)
        
    }
    
    // MARK: ROI
    
    public func roi(rect: CGRect) -> VImageBufferWeakWrapper? {
        
        guard rect.origin.x >= 0.0,
              rect.size.width > 0.0,
              rect.origin.x + rect.size.width <= CGFloat(self.width),
              rect.origin.y >= 0.0,
              rect.size.height > 0.0,
              rect.origin.y + rect.size.height <= CGFloat(self.height)
        else { return nil }
        
        let offset = Int(rect.origin.y) * self.rowBytes + Int(rect.origin.x) * self.pixelFormat.bytesPerPixel
        let roiImageBuffer = vImage_Buffer(data: self.buffer.data.advanced(by: offset), height: vImagePixelCount(rect.height), width: vImagePixelCount(rect.width), rowBytes: self.rowBytes)
        
        return VImageBufferWeakWrapper(buffer: roiImageBuffer, pixelFormat: self.pixelFormat)
        
    }
    
}
