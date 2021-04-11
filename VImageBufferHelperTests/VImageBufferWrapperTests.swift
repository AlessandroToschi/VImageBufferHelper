//
//  VImageBufferWrapperTests.swift
//  VImageBufferHelperTests
//
//  Created by Alessandro Toschi on 11/04/21.
//

import XCTest
@testable import VImageBufferHelper

class VImageBufferWrapperTests: XCTestCase {

    func testEmptyConstructor() {
        let emptyConstructor = VImageBufferWrapper()
        XCTAssertEqual(emptyConstructor.width, 0)
        XCTAssertEqual(emptyConstructor.height, 0)
        XCTAssertEqual(emptyConstructor.rowBytes, 0)
        XCTAssertEqual(emptyConstructor.size, 0)
        XCTAssertEqual(emptyConstructor.contiguousSize, 0)
        XCTAssertEqual(emptyConstructor.contiguousRowBytes, 0)
        XCTAssertEqual(emptyConstructor.isContiguous, true)
        XCTAssertEqual(emptyConstructor.pixelFormat, .mono8)
    }

    func testWidthHeightConstructor() {
        let width = Int.random(in: 0...10)
        let height = Int.random(in: 0...10)
        
        for pixelFormat in VImagePixelFormat.allCases {
            
            let image = VImageBufferWrapper(width: width, height: height, pixelFormat: pixelFormat)
            XCTAssertEqual(image.width, width)
            XCTAssertEqual(image.height, height)
            XCTAssertGreaterThanOrEqual(image.rowBytes, width * pixelFormat.bytesPerPixel)
            XCTAssertGreaterThanOrEqual(image.size, width * height * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.contiguousSize, width * height * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.contiguousRowBytes, width * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.isContiguous, image.rowBytes == image.contiguousRowBytes)
            XCTAssertEqual(image.pixelFormat, pixelFormat)
        }
        
        
    }
    
    func testWidthHeightContiguousConstructor() {
        let width = Int.random(in: 0...10)
        let height = Int.random(in: 0...10)
        
        for pixelFormat in VImagePixelFormat.allCases {
            
            let image = VImageBufferWrapper(width: width, height: height, pixelFormat: pixelFormat, contiguous: true)
            XCTAssertEqual(image.width, width)
            XCTAssertEqual(image.height, height)
            XCTAssertEqual(image.rowBytes, width * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.size, width * height * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.contiguousSize, width * height * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.contiguousRowBytes, width * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.isContiguous, image.rowBytes == image.contiguousRowBytes)
            XCTAssertEqual(image.pixelFormat, pixelFormat)
        }
    }
    
    func testRealloc() {
        let width = Int.random(in: 0...10)
        let height = Int.random(in: 0...10)
        
        for pixelFormat in VImagePixelFormat.allCases {
            
            let image = VImageBufferWrapper()
            
            XCTAssertEqual(image.width, 0)
            XCTAssertEqual(image.height, 0)
            XCTAssertEqual(image.rowBytes, 0)
            XCTAssertEqual(image.size, 0)
            XCTAssertEqual(image.contiguousSize, 0)
            XCTAssertEqual(image.contiguousRowBytes, 0)
            XCTAssertEqual(image.isContiguous, true)
            XCTAssertEqual(image.pixelFormat, .mono8)
            
            image.reallocIfNeeded(width: width, height: height, pixelFormat: pixelFormat)
            
            XCTAssertEqual(image.width, width)
            XCTAssertEqual(image.height, height)
            XCTAssertGreaterThanOrEqual(image.rowBytes, width * pixelFormat.bytesPerPixel)
            XCTAssertGreaterThanOrEqual(image.size, width * height * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.contiguousSize, width * height * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.contiguousRowBytes, width * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.isContiguous, image.rowBytes == image.contiguousRowBytes)
            XCTAssertEqual(image.pixelFormat, pixelFormat)
            
            image.reallocIfNeeded(width: width, height: height, pixelFormat: pixelFormat)
            
            XCTAssertEqual(image.width, width)
            XCTAssertEqual(image.height, height)
            XCTAssertGreaterThanOrEqual(image.rowBytes, width * pixelFormat.bytesPerPixel)
            XCTAssertGreaterThanOrEqual(image.size, width * height * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.contiguousSize, width * height * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.contiguousRowBytes, width * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.isContiguous, image.rowBytes == image.contiguousRowBytes)
            XCTAssertEqual(image.pixelFormat, pixelFormat)
        }
    }
    
    func testReallocNoAlloc() {
        let width = Int.random(in: 0...10)
        let height = Int.random(in: 0...10)
        
        for pixelFormat in VImagePixelFormat.allCases {
            
            let image = VImageBufferWrapper(width: width, height: height, pixelFormat: pixelFormat)
            XCTAssertEqual(image.width, width)
            XCTAssertEqual(image.height, height)
            XCTAssertGreaterThanOrEqual(image.rowBytes, width * pixelFormat.bytesPerPixel)
            XCTAssertGreaterThanOrEqual(image.size, width * height * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.contiguousSize, width * height * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.contiguousRowBytes, width * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.isContiguous, image.rowBytes == image.contiguousRowBytes)
            XCTAssertEqual(image.pixelFormat, pixelFormat)
            
            image.reallocIfNeeded(width: -1, height: height, pixelFormat: pixelFormat)
            
            XCTAssertEqual(image.width, width)
            XCTAssertEqual(image.height, height)
            XCTAssertGreaterThanOrEqual(image.rowBytes, width * pixelFormat.bytesPerPixel)
            XCTAssertGreaterThanOrEqual(image.size, width * height * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.contiguousSize, width * height * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.contiguousRowBytes, width * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.isContiguous, image.rowBytes == image.contiguousRowBytes)
            XCTAssertEqual(image.pixelFormat, pixelFormat)
            
            image.reallocIfNeeded(width: 0, height: height, pixelFormat: pixelFormat)
            
            XCTAssertEqual(image.width, width)
            XCTAssertEqual(image.height, height)
            XCTAssertGreaterThanOrEqual(image.rowBytes, width * pixelFormat.bytesPerPixel)
            XCTAssertGreaterThanOrEqual(image.size, width * height * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.contiguousSize, width * height * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.contiguousRowBytes, width * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.isContiguous, image.rowBytes == image.contiguousRowBytes)
            XCTAssertEqual(image.pixelFormat, pixelFormat)
            
            image.reallocIfNeeded(width: width, height: -1, pixelFormat: pixelFormat)
            
            XCTAssertEqual(image.width, width)
            XCTAssertEqual(image.height, height)
            XCTAssertGreaterThanOrEqual(image.rowBytes, width * pixelFormat.bytesPerPixel)
            XCTAssertGreaterThanOrEqual(image.size, width * height * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.contiguousSize, width * height * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.contiguousRowBytes, width * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.isContiguous, image.rowBytes == image.contiguousRowBytes)
            XCTAssertEqual(image.pixelFormat, pixelFormat)
            
            image.reallocIfNeeded(width: width, height: 0, pixelFormat: pixelFormat)
            
            XCTAssertEqual(image.width, width)
            XCTAssertEqual(image.height, height)
            XCTAssertGreaterThanOrEqual(image.rowBytes, width * pixelFormat.bytesPerPixel)
            XCTAssertGreaterThanOrEqual(image.size, width * height * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.contiguousSize, width * height * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.contiguousRowBytes, width * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.isContiguous, image.rowBytes == image.contiguousRowBytes)
            XCTAssertEqual(image.pixelFormat, pixelFormat)
            
        }
    }
    
    func testReallocContiguousNotContiguous() {
        let width = Int.random(in: 0...10)
        let height = Int.random(in: 0...10)
        
        for pixelFormat in VImagePixelFormat.allCases {
            
            let image = VImageBufferWrapper()
            
            XCTAssertEqual(image.width, 0)
            XCTAssertEqual(image.height, 0)
            XCTAssertEqual(image.rowBytes, 0)
            XCTAssertEqual(image.size, 0)
            XCTAssertEqual(image.contiguousSize, 0)
            XCTAssertEqual(image.contiguousRowBytes, 0)
            XCTAssertEqual(image.isContiguous, true)
            XCTAssertEqual(image.pixelFormat, .mono8)
            
            image.reallocIfNeeded(width: width, height: height, pixelFormat: pixelFormat, contiguous: true)
            
            XCTAssertEqual(image.width, width)
            XCTAssertEqual(image.height, height)
            XCTAssertEqual(image.rowBytes, width * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.size, width * height * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.contiguousSize, width * height * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.contiguousRowBytes, width * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.isContiguous, image.rowBytes == image.contiguousRowBytes)
            XCTAssertEqual(image.pixelFormat, pixelFormat)
            
            image.reallocIfNeeded(width: width, height: height, pixelFormat: pixelFormat)
            
            XCTAssertEqual(image.width, width)
            XCTAssertEqual(image.height, height)
            XCTAssertGreaterThanOrEqual(image.rowBytes, width * pixelFormat.bytesPerPixel)
            XCTAssertGreaterThanOrEqual(image.size, width * height * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.contiguousSize, width * height * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.contiguousRowBytes, width * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.isContiguous, image.rowBytes == image.contiguousRowBytes)
            XCTAssertEqual(image.pixelFormat, pixelFormat)
        }
    }
    
    func testReallocNotContiguousContiguous() {
        let width = Int.random(in: 0...10)
        let height = Int.random(in: 0...10)
        
        for pixelFormat in VImagePixelFormat.allCases {
            
            let image = VImageBufferWrapper()
            
            XCTAssertEqual(image.width, 0)
            XCTAssertEqual(image.height, 0)
            XCTAssertEqual(image.rowBytes, 0)
            XCTAssertEqual(image.size, 0)
            XCTAssertEqual(image.contiguousSize, 0)
            XCTAssertEqual(image.contiguousRowBytes, 0)
            XCTAssertEqual(image.isContiguous, true)
            XCTAssertEqual(image.pixelFormat, .mono8)
            
            image.reallocIfNeeded(width: width, height: height, pixelFormat: pixelFormat)
            
            XCTAssertEqual(image.width, width)
            XCTAssertEqual(image.height, height)
            XCTAssertGreaterThanOrEqual(image.rowBytes, width * pixelFormat.bytesPerPixel)
            XCTAssertGreaterThanOrEqual(image.size, width * height * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.contiguousSize, width * height * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.contiguousRowBytes, width * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.isContiguous, image.rowBytes == image.contiguousRowBytes)
            XCTAssertEqual(image.pixelFormat, pixelFormat)
            
            image.reallocIfNeeded(width: width, height: height, pixelFormat: pixelFormat, contiguous: true)
            
            XCTAssertEqual(image.width, width)
            XCTAssertEqual(image.height, height)
            XCTAssertEqual(image.rowBytes, width * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.size, width * height * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.contiguousSize, width * height * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.contiguousRowBytes, width * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.isContiguous, image.rowBytes == image.contiguousRowBytes)
            XCTAssertEqual(image.pixelFormat, pixelFormat)
        }
    }
    
    func testReallocGreaterToSmaller() {
        let width = Int.random(in: 5...15)
        let height = Int.random(in: 5...15)
        let width2 = Int.random(in: 1..<width)
        let height2 = Int.random(in: 1..<height)
        
        for pixelFormat in VImagePixelFormat.allCases {
            
            let image = VImageBufferWrapper()
            
            XCTAssertEqual(image.width, 0)
            XCTAssertEqual(image.height, 0)
            XCTAssertEqual(image.rowBytes, 0)
            XCTAssertEqual(image.size, 0)
            XCTAssertEqual(image.contiguousSize, 0)
            XCTAssertEqual(image.contiguousRowBytes, 0)
            XCTAssertEqual(image.isContiguous, true)
            XCTAssertEqual(image.pixelFormat, .mono8)
            
            image.reallocIfNeeded(width: width, height: height, pixelFormat: pixelFormat)
            
            XCTAssertEqual(image.width, width)
            XCTAssertEqual(image.height, height)
            XCTAssertGreaterThanOrEqual(image.rowBytes, width * pixelFormat.bytesPerPixel)
            XCTAssertGreaterThanOrEqual(image.size, width * height * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.contiguousSize, width * height * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.contiguousRowBytes, width * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.isContiguous, image.rowBytes == image.contiguousRowBytes)
            XCTAssertEqual(image.pixelFormat, pixelFormat)
            
            image.reallocIfNeeded(width: width, height: height, pixelFormat: pixelFormat, contiguous: true)
            
            XCTAssertEqual(image.width, width)
            XCTAssertEqual(image.height, height)
            XCTAssertEqual(image.rowBytes, width * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.size, width * height * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.contiguousSize, width * height * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.contiguousRowBytes, width * pixelFormat.bytesPerPixel)
            XCTAssertEqual(image.isContiguous, image.rowBytes == image.contiguousRowBytes)
            XCTAssertEqual(image.pixelFormat, pixelFormat)
        }
    }
    
    func testMutableBufferPointer() {
        let width = Int.random(in: 1...10)
        let height = Int.random(in: 1...10)
        
        for pixelFormat in VImagePixelFormat.allCases {
            
            let image = VImageBufferWrapper(width: width, height: height, pixelFormat: pixelFormat, contiguous: true)
            let mutableBufferPointer
            
        }
    }
}
