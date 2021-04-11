//
//  VImageBufferWrapper.swift
//  VImageBufferHelper
//
//  Created by Alessandro Toschi on 10/04/21.
//

import Foundation
import Accelerate

public class VImageBufferWrapper{
    // MARK: Stored Properties
    
    public private(set) var imageBuffer: vImage_Buffer
    public let pixelFormat: VImagePixelFormat
    
    // MARK: - Computed Properties
    
    public var width: Int { Int(imageBuffer.width) }
    public var height: Int { Int(imageBuffer.height) }
    
    public var count: Int { self.width * self.height }
    
    public var rowBytes: Int { imageBuffer.rowBytes }
    public var size: Int { self.rowBytes * self.height }
    
    public var contiguousRowBytes: Int { self.width * self.pixelFormat.bytesPerPixel }
    public var contiguousSize: Int { self.contiguousRowBytes * self.height}
    public var isContiguous: Bool { self.rowBytes == self.contiguousRowBytes }
    
    public var `weak`: VImageBufferWeakWrapper { return VImageBufferWeakWrapper(imageBufferWrapper: self) }
    
    var freeImageBuffer: Bool { true }
    
    // MARK: - Static
    
    private static func rowBytesAndAlignment(_ width: Int, _ height: Int, _ pixelFormat: VImagePixelFormat, _ contiguous: Bool) -> (alignment: Int, rowBytes: Int) {
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
    
    public init(width: Int, height: Int, pixelFormat: VImagePixelFormat, contiguous: Bool = false) {
        
        guard width >= 0, height >= 0 else { fatalError("Width and height must be greater or equal to zero") }
        
        let (alignment, rowBytes) = VImageBufferWrapper.rowBytesAndAlignment(width, height, pixelFormat, contiguous)
        let rawPointer = UnsafeMutableRawPointer.allocate(byteCount: width * rowBytes, alignment: alignment)
        
        self.imageBuffer = vImage_Buffer(data: rawPointer, height: vImagePixelCount(height), width: vImagePixelCount(width), rowBytes: rowBytes)
        self.pixelFormat = pixelFormat
        
    }
    
    init(imageBuffer: vImage_Buffer, pixelFormat: VImagePixelFormat) {
        
        self.imageBuffer = imageBuffer
        self.pixelFormat = pixelFormat
        
    }
    
    // MARK: - Destructor
    
    deinit {
        
        if self.freeImageBuffer {
            
            self.imageBuffer.data.deallocate()
            self.imageBuffer.data = nil
            
        }

    }
    
    // MARK: Realloc
    
    public func reallocIfNeeded(width: Int, height: Int, pixelFormat: VImagePixelFormat, contiguous: Bool = false) {
        
    }
    
    public func reallocIfNeeded(imageBufferWrapper: VImageBufferWrapper, contiguous: Bool = false) {
        self.reallocIfNeeded(width: imageBufferWrapper.width, height: imageBufferWrapper.height, pixelFormat: imageBufferWrapper.pixelFormat, contiguous: contiguous)
    }
    
    // MARK: Buffer Pointers
    
    public func mutableBufferPointer<T>(type: T.Type) -> UnsafeMutableBufferPointer<T> {
        
        guard self.isContiguous else { fatalError("Buffer pointer can be created only if the underlying memory of the image is contiguous") }

        let mutableRawBufferPointer = UnsafeMutableRawBufferPointer(start: self.imageBuffer.data, count: self.size)
        return mutableRawBufferPointer.bindMemory(to: type)
        
    }
    
    public func bufferPointer<T>(type: T.Type) -> UnsafeBufferPointer<T> {
        
        guard self.isContiguous else { fatalError("Buffer pointer can be created only if the underlying memory of the image is contiguous") }
        
        let rawBufferPointer = UnsafeRawBufferPointer(start: self.imageBuffer.data, count: self.size)
        return rawBufferPointer.bindMemory(to: type)
        
    }
    
    // MARK: ROI
    
    public func roi(rect: CGRect) -> VImageBufferWeakWrapper? {
        
        guard rect.maxX <= CGFloat(self.width), rect.minX >= 0.0,
              rect.maxY <= CGFloat(self.height), rect.minY >= 0.0 else { return nil }
        
        let offset = Int(rect.origin.y) * self.rowBytes + Int(rect.origin.x) * self.pixelFormat.bytesPerPixel
        let roiImageBuffer = vImage_Buffer(data: self.imageBuffer.data.advanced(by: offset), height: vImagePixelCount(rect.height), width: vImagePixelCount(rect.width), rowBytes: self.rowBytes)
        
        return VImageBufferWeakWrapper(imageBuffer: roiImageBuffer, pixelFormat: self.pixelFormat)
    
    }
    
}
