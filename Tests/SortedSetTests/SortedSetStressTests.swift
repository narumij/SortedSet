//
//  SortedSetStressTests.swift
//  SortedSet
//
//  Created by narumij on 2024/09/16.
//

import XCTest
import SortedSet

final class SortedSetStressTests: XCTestCase {
    
    func skip() throws {
#if false
        throw XCTSkip()
#endif
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() throws {
        try skip()
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    let count = 1_000_000

    func testPerformanceExample0() throws {
        try skip()
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            _ = SortedSet<Int>((0 ..< count) + [])
        }
    }
    
    func testPerformanceExample1() throws {
        try skip()
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            _ = SortedSet<Int>(0 ..< count)
        }
    }
    
    func testPerformanceExample2() throws {
        try skip()
        // This is an example of a performance test case.
        self.measure {
          var set = SortedSet<Int>()
            // Put the code you want to measure the time of here.
            for i in 0 ..< count {
                _ = set.insert(i)
            }
        }
    }

}
