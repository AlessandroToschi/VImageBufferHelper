//
//  VImageBufferWeakWrapperTests.swift
//  VImageBufferHelperTests
//
//  Created by Alessandro Toschi on 10/04/21.
//

import XCTest
import Accelerate
@testable import VImageBufferHelper

class VImageBufferWeakWrapperTests: XCTestCase {

    func testNoDeallocation() {
        var unsafe: UnsafeMutableRawPointer! = nil
        let closure = {
            let image = VImageBufferWrapper(width: 5, height: 5, pixelFormat: .mono8)
            var weakImage: VImageBufferWeakWrapper? = image.weak
            unsafe = UnsafeMutableRawPointer(image.imageBuffer.data)
            weakImage = nil
        }
        closure()
        print(unsafe.assumingMemoryBound(to: UInt8.self)[0])
    }
    
    func testDealloc() {
        let x = UnsafeMutableRawPointer.allocate(byteCount: 10, alignment: 1)
        // x is unitialized and unbound
        let p = x.bindMemory(to: UInt8.self, capacity: 10)
        p.initialize(to: 1)
        x.deallocate() // x should be deallocated.
        
        print(x.storeBytes(of: 2, as: UInt8.self))
        print(x.load(as: UInt8.self))
    }

}
