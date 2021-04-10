//
//  VImageBufferWeakWrapper.swift
//  VImageBufferHelper
//
//  Created by Alessandro Toschi on 10/04/21.
//

import Foundation
import Accelerate

public class VImageBufferWeakWrapper: VImageBufferWrapper {
    override var freeImageBuffer: Bool { false }
    
    override init(imageBuffer: vImage_Buffer, pixelFormat: VImagePixelFormat) {
        super.init(imageBuffer: imageBuffer, pixelFormat: pixelFormat)
    }
    
    public init(imageBufferWrapper: VImageBufferWrapper) {
        super.init(imageBuffer: imageBufferWrapper.imageBuffer, pixelFormat: imageBufferWrapper.pixelFormat)
    }
}
