//
//  VImageBufferWeakWrapper.swift
//  VImageBufferHelper
//
//  Created by Alessandro Toschi on 10/04/21.
//

import Foundation
import Accelerate

public struct VImageBufferWeakWrapper: VImageBuffer {
    
    public private(set) var buffer: vImage_Buffer
    public private(set) var pixelFormat: VImagePixelFormat
    
}
