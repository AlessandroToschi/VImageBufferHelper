//
//  VImageBufferFormat.swift
//  VImageBufferHelper
//
//  Created by Alessandro Toschi on 10/04/21.
//

import Foundation


public enum VImagePixelFormat: CaseIterable {
    case rgba8
    case rgbaF
    
    
    case bgra8
    case bgraF
    
    case argb8
    case argbF
    
    case abgr8
    case abgrF
    
    case rgb8
    case rgbF
    
    case bgr8
    case bgrF
    
    case mono8
    case monoF
    
    public var bitsPerPixel: Int {
        
        switch self {
            
            case .rgba8, .bgra8, .argb8, .abgr8:
                return 32
                
            case .rgbaF, .bgraF, .argbF, .abgrF:
                return 128
                
            case .rgb8, .bgr8:
                return 24
                
            case .rgbF, .bgrF:
                return 96
                
            case .mono8:
                return 8
                
            case .monoF:
                return 32
                
        }
        
    }
    
    public var bytesPerPixel: Int { self.bitsPerPixel / 8 }
    
    public var type: VImagePixelFormatConvertible.Type {
        switch self {
            case .rgba8, .bgra8, .argb8, .abgr8:
                return SIMD4<UInt8>.self
                
            case .rgbaF, .bgraF, .argbF, .abgrF:
                return SIMD4<Float>.self
                
            case .rgb8, .bgr8:
                return SIMD3<UInt8>.self
                
            case .rgbF, .bgrF:
                return SIMD3<Float>.self
                
            case .mono8:
                return UInt8.self
                
            case .monoF:
                return Float.self
        }
    }
    
    

}

public protocol VImagePixelFormatConvertible { }

extension UInt8: VImagePixelFormatConvertible { }
extension Float: VImagePixelFormatConvertible { }
extension SIMD3: VImagePixelFormatConvertible where Scalar: VImagePixelFormatConvertible { }
extension SIMD4: VImagePixelFormatConvertible where Scalar: VImagePixelFormatConvertible { }
