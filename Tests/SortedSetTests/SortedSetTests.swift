//
//  SortedSetTests.swift
//  swift-ac-collections
//
//  Created by narumij on 2024/09/16.
//

import XCTest
@testable import SortedSet

final class SortedSetTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        SortedSetCondition.BUCKET_RATIO = 1
        SortedSetCondition.SPLIT_RATIO = 1
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample0() throws {
        var set = SortedSet<Int>(0 ..< 10000)
        XCTAssertEqual(set.pop(999),999)
    }
    
    func testExample01() throws {
        let set = SortedSet<Int>()
        XCTAssertEqual(set.buckets.flatMap{$0}, [])
    }
    
//    func testExample1() throws {
//        var set = SortedSet<Int>(a: 0 ..< 1200)
//        XCTAssertEqual(set.a.count, 9)
//        XCTAssertEqual(set.index(1101), 1101)
//        XCTAssertEqual(set.pop(1100),1100)
//        XCTAssertEqual(set.a.count, 9)
//        XCTAssertEqual(set.index(1101), 1100)
//        XCTAssertEqual(set.pop(1100),1101)
//        XCTAssertEqual(set.a.count, 9)
//        XCTAssertEqual(set.index(1102), 1100)
//    }
    
    func testExample1() throws {
        var set = SortedSet<Int>([0,1,2,3,4])
        XCTAssertEqual(set.remove(0), true)
        XCTAssertEqual(set.remove(1), true)
        XCTAssertEqual(set.remove(2), true)
        XCTAssertEqual(set.remove(3), true)
        XCTAssertEqual(set.remove(4), true)
        XCTAssertEqual(set.buckets.flatMap{$0}, [])
        XCTAssertEqual(set.remove(0), false)
        XCTAssertEqual(set.remove(1), false)
        XCTAssertEqual(set.remove(2), false)
        XCTAssertEqual(set.remove(3), false)
        XCTAssertEqual(set.remove(4), false)
    }
    
    func testExample11() throws {
        var set = SortedSet<Int>([0,1,2,3,4])
        XCTAssertEqual(set.pop(0), 0)
        XCTAssertEqual(set.buckets.flatMap{$0}, [1,2,3,4])
        XCTAssertEqual(set.pop(0), 1)
        XCTAssertEqual(set.buckets.flatMap{$0}, [2,3,4])
        XCTAssertEqual(set.pop(0), 2)
        XCTAssertEqual(set.buckets.flatMap{$0}, [3,4])
        XCTAssertEqual(set.pop(0), 3)
        XCTAssertEqual(set.buckets.flatMap{$0}, [4])
        XCTAssertEqual(set.pop(0), 4)
        XCTAssertEqual(set.buckets.flatMap{$0}, [])
        XCTAssertEqual(set.pop(0), nil)
    }

    func testExample12() throws {
        var set = SortedSet<Int>([0])
        XCTAssertEqual(set.pop(-1), 0)
        XCTAssertEqual(set.buckets.flatMap{$0}, [])
    }

    func testExample13() throws {
        
        var set = SortedSet<Int>([0,1,2,3,4])
        XCTAssertEqual(set.pop(-1), 4)
        XCTAssertEqual(set.buckets.flatMap{$0}, [0,1,2,3])
        XCTAssertEqual(set.pop(-1), 3)
        XCTAssertEqual(set.buckets.flatMap{$0}, [0,1,2])
        XCTAssertEqual(set.pop(-1), 2)
        XCTAssertEqual(set.buckets.flatMap{$0}, [0,1])
        XCTAssertEqual(set.pop(-1), 1)
        XCTAssertEqual(set.buckets.flatMap{$0}, [0])
        XCTAssertEqual(set.pop(-1), 0)
        XCTAssertEqual(set.buckets.flatMap{$0}, [])
        XCTAssertEqual(set.pop(-1), nil)
    }

    func testExample2() throws {
        var set = SortedSet<Int>([])
        XCTAssertEqual(set.insert(0), true)
        XCTAssertEqual(set.insert(1), true)
        XCTAssertEqual(set.insert(2), true)
        XCTAssertEqual(set.insert(3), true)
        XCTAssertEqual(set.insert(4), true)
        XCTAssertEqual(set.buckets.flatMap{$0}, [0,1,2,3,4])
        XCTAssertEqual(set.insert(0), false)
        XCTAssertEqual(set.insert(1), false)
        XCTAssertEqual(set.insert(2), false)
        XCTAssertEqual(set.insert(3), false)
        XCTAssertEqual(set.insert(4), false)
    }
    
    func testExample3() throws {
        var set = SortedSet<Int>([0,1,2,3,4])
        XCTAssertEqual(set.count, 5)
        XCTAssertEqual(set.lt(-1), nil)
        XCTAssertEqual(set.gt(-1), 0)
        XCTAssertEqual(set.lt(0), nil)
        XCTAssertEqual(set.gt(0), 1)
        XCTAssertEqual(set.lt(1), 0)
        XCTAssertEqual(set.gt(1), 2)
        XCTAssertEqual(set.lt(2), 1)
        XCTAssertEqual(set.gt(2), 3)
        XCTAssertEqual(set.lt(3), 2)
        XCTAssertEqual(set.gt(3), 4)
        XCTAssertEqual(set.lt(4), 3)
        XCTAssertEqual(set.gt(4), nil)
        XCTAssertEqual(set.lt(5), 4)
        XCTAssertEqual(set.gt(5), nil)
        XCTAssertEqual(set.remove(1), true)
        XCTAssertEqual(set.remove(3), true)
        XCTAssertEqual(set.remove(1), false)
        XCTAssertEqual(set.remove(3), false)
        XCTAssertEqual(set.buckets.flatMap{$0}, [0,2,4])
        XCTAssertEqual(set.lt(-1), nil)
        XCTAssertEqual(set.gt(-1), 0)
        XCTAssertEqual(set.lt(0), nil)
        XCTAssertEqual(set.gt(0), 2)
        XCTAssertEqual(set.lt(1), 0)
        XCTAssertEqual(set.gt(1), 2)
        XCTAssertEqual(set.lt(2), 0)
        XCTAssertEqual(set.gt(2), 4)
        XCTAssertEqual(set.lt(3), 2)
        XCTAssertEqual(set.gt(3), 4)
        XCTAssertEqual(set.lt(4), 2)
        XCTAssertEqual(set.gt(4), nil)
        XCTAssertEqual(set.lt(5), 4)
        XCTAssertEqual(set.gt(5), nil)
        XCTAssertEqual(set.remove(2), true)
        XCTAssertEqual(set.remove(1), false)
        XCTAssertEqual(set.remove(2), false)
        XCTAssertEqual(set.remove(3), false)
        XCTAssertEqual(set.buckets.flatMap{$0}, [0,4])
        XCTAssertEqual(set.lt(-1), nil)
        XCTAssertEqual(set.gt(-1), 0)
        XCTAssertEqual(set.lt(0), nil)
        XCTAssertEqual(set.gt(0), 4)
        XCTAssertEqual(set.lt(1), 0)
        XCTAssertEqual(set.gt(1), 4)
        XCTAssertEqual(set.lt(2), 0)
        XCTAssertEqual(set.gt(2), 4)
        XCTAssertEqual(set.lt(3), 0)
        XCTAssertEqual(set.gt(3), 4)
        XCTAssertEqual(set.lt(4), 0)
        XCTAssertEqual(set.gt(4), nil)
        XCTAssertEqual(set.lt(5), 4)
        XCTAssertEqual(set.gt(5), nil)
        XCTAssertEqual(set.remove(0), true)
        XCTAssertEqual(set.remove(1), false)
        XCTAssertEqual(set.remove(2), false)
        XCTAssertEqual(set.remove(3), false)
        XCTAssertEqual(set.remove(4), true)
        XCTAssertEqual(set.lt(-1), nil)
        XCTAssertEqual(set.gt(-1), nil)
        XCTAssertEqual(set.lt(0), nil)
        XCTAssertEqual(set.gt(0), nil)
        XCTAssertEqual(set.lt(1), nil)
        XCTAssertEqual(set.gt(1), nil)
        XCTAssertEqual(set.lt(2), nil)
        XCTAssertEqual(set.gt(2), nil)
        XCTAssertEqual(set.lt(3), nil)
        XCTAssertEqual(set.gt(3), nil)
        XCTAssertEqual(set.lt(4), nil)
        XCTAssertEqual(set.gt(4), nil)
        XCTAssertEqual(set.lt(5), nil)
        XCTAssertEqual(set.gt(5), nil)
        XCTAssertEqual(set.buckets.flatMap{$0}, [])
    }
    
    func testExample4() throws {
        var set = SortedSet<Int>([0,1,2,3,4])
        XCTAssertEqual(set.count, 5)
        XCTAssertEqual(set.contains(-1), false)
        XCTAssertEqual(set.contains(0), true)
        XCTAssertEqual(set.contains(1), true)
        XCTAssertEqual(set.contains(2), true)
        XCTAssertEqual(set.contains(3), true)
        XCTAssertEqual(set.contains(4), true)
        XCTAssertEqual(set.contains(5), false)
        XCTAssertEqual(set.remove(1), true)
        XCTAssertEqual(set.remove(3), true)
        XCTAssertEqual(set.remove(1), false)
        XCTAssertEqual(set.remove(3), false)
        XCTAssertEqual(set.buckets.flatMap{$0}, [0,2,4])
        XCTAssertEqual(set.contains(-1), false)
        XCTAssertEqual(set.contains(0), true)
        XCTAssertEqual(set.contains(1), false)
        XCTAssertEqual(set.contains(2), true)
        XCTAssertEqual(set.contains(3), false)
        XCTAssertEqual(set.contains(4), true)
        XCTAssertEqual(set.contains(5), false)
        XCTAssertEqual(set.remove(2), true)
        XCTAssertEqual(set.remove(1), false)
        XCTAssertEqual(set.remove(2), false)
        XCTAssertEqual(set.remove(3), false)
        XCTAssertEqual(set.buckets.flatMap{$0}, [0,4])
        XCTAssertEqual(set.contains(-1), false)
        XCTAssertEqual(set.contains(0), true)
        XCTAssertEqual(set.contains(1), false)
        XCTAssertEqual(set.contains(2), false)
        XCTAssertEqual(set.contains(3), false)
        XCTAssertEqual(set.contains(4), true)
        XCTAssertEqual(set.contains(5), false)
        XCTAssertEqual(set.remove(0), true)
        XCTAssertEqual(set.remove(1), false)
        XCTAssertEqual(set.remove(2), false)
        XCTAssertEqual(set.remove(3), false)
        XCTAssertEqual(set.remove(4), true)
        XCTAssertEqual(set.contains(-1), false)
        XCTAssertEqual(set.contains(0), false)
        XCTAssertEqual(set.contains(1), false)
        XCTAssertEqual(set.contains(2), false)
        XCTAssertEqual(set.contains(3), false)
        XCTAssertEqual(set.contains(4), false)
        XCTAssertEqual(set.contains(5), false)
        XCTAssertEqual(set.buckets.flatMap{$0}, [])
    }
    
    func testExample5() throws {
        var set = SortedSet<Int>([0,1,2,3,4])
        XCTAssertEqual(set.count, 5)
        XCTAssertEqual(set.le(-1), nil)
        XCTAssertEqual(set.ge(-1), 0)
        XCTAssertEqual(set.le(0), 0)
        XCTAssertEqual(set.ge(0), 0)
        XCTAssertEqual(set.le(1), 1)
        XCTAssertEqual(set.ge(1), 1)
        XCTAssertEqual(set.le(2), 2)
        XCTAssertEqual(set.ge(2), 2)
        XCTAssertEqual(set.le(3), 3)
        XCTAssertEqual(set.ge(3), 3)
        XCTAssertEqual(set.le(4), 4)
        XCTAssertEqual(set.ge(4), 4)
        XCTAssertEqual(set.le(5), 4)
        XCTAssertEqual(set.ge(5), nil)
        XCTAssertEqual(set.remove(1), true)
        XCTAssertEqual(set.remove(3), true)
        XCTAssertEqual(set.remove(1), false)
        XCTAssertEqual(set.remove(3), false)
        XCTAssertEqual(set.buckets.flatMap{$0}, [0,2,4])
        XCTAssertEqual(set.le(-1), nil)
        XCTAssertEqual(set.ge(-1), 0)
        XCTAssertEqual(set.le(0), 0)
        XCTAssertEqual(set.ge(0), 0)
        XCTAssertEqual(set.le(1), 0)
        XCTAssertEqual(set.ge(1), 2)
        XCTAssertEqual(set.le(2), 2)
        XCTAssertEqual(set.ge(2), 2)
        XCTAssertEqual(set.le(3), 2)
        XCTAssertEqual(set.ge(3), 4)
        XCTAssertEqual(set.le(4), 4)
        XCTAssertEqual(set.ge(4), 4)
        XCTAssertEqual(set.le(5), 4)
        XCTAssertEqual(set.ge(5), nil)
        XCTAssertEqual(set.remove(2), true)
        XCTAssertEqual(set.remove(1), false)
        XCTAssertEqual(set.remove(2), false)
        XCTAssertEqual(set.remove(3), false)
        XCTAssertEqual(set.buckets.flatMap{$0}, [0,4])
        XCTAssertEqual(set.le(-1), nil)
        XCTAssertEqual(set.ge(-1), 0)
        XCTAssertEqual(set.le(0), 0)
        XCTAssertEqual(set.ge(0), 0)
        XCTAssertEqual(set.le(1), 0)
        XCTAssertEqual(set.ge(1), 4)
        XCTAssertEqual(set.le(2), 0)
        XCTAssertEqual(set.ge(2), 4)
        XCTAssertEqual(set.le(3), 0)
        XCTAssertEqual(set.ge(3), 4)
        XCTAssertEqual(set.le(4), 4)
        XCTAssertEqual(set.ge(4), 4)
        XCTAssertEqual(set.le(5), 4)
        XCTAssertEqual(set.ge(5), nil)
        XCTAssertEqual(set.remove(0), true)
        XCTAssertEqual(set.remove(1), false)
        XCTAssertEqual(set.remove(2), false)
        XCTAssertEqual(set.remove(3), false)
        XCTAssertEqual(set.remove(4), true)
        XCTAssertEqual(set.le(-1), nil)
        XCTAssertEqual(set.ge(-1), nil)
        XCTAssertEqual(set.le(0), nil)
        XCTAssertEqual(set.ge(0), nil)
        XCTAssertEqual(set.le(1), nil)
        XCTAssertEqual(set.ge(1), nil)
        XCTAssertEqual(set.le(2), nil)
        XCTAssertEqual(set.ge(2), nil)
        XCTAssertEqual(set.le(3), nil)
        XCTAssertEqual(set.ge(3), nil)
        XCTAssertEqual(set.le(4), nil)
        XCTAssertEqual(set.ge(4), nil)
        XCTAssertEqual(set.le(5), nil)
        XCTAssertEqual(set.ge(5), nil)
        XCTAssertEqual(set.buckets.flatMap{$0}, [])
    }

    func testExample6() throws {
        var set = SortedSet<Int>([0,1,2,3,4])
        XCTAssertEqual(set.count, 5)
        XCTAssertEqual(set.left(-1), 0)
        XCTAssertEqual(set.buckets.flatMap{$0}.count{ $0 < -1 }, 0)
        XCTAssertEqual(set.left(0), 0)
        XCTAssertEqual(set.buckets.flatMap{$0}.count{ $0 < 0 }, 0)
        XCTAssertEqual(set.left(1), 1)
        XCTAssertEqual(set.buckets.flatMap{$0}.count{ $0 < 1 }, 1)
        XCTAssertEqual(set.left(2), 2)
        XCTAssertEqual(set.left(3), 3)
        XCTAssertEqual(set.left(4), 4)
        XCTAssertEqual(set.left(5), 5)
        XCTAssertEqual(set.left(6), 5)
        XCTAssertEqual(set.right(-1), 0)
        XCTAssertEqual(set.buckets.flatMap{$0}.count{ $0 <= -1 }, 0)
        XCTAssertEqual(set.right(0), 1)
        XCTAssertEqual(set.buckets.flatMap{$0}.count{ $0 <= 0 }, 1)
        XCTAssertEqual(set.right(1), 2)
        XCTAssertEqual(set.buckets.flatMap{$0}.count{ $0 <= 1 }, 2)
        XCTAssertEqual(set.right(2), 3)
        XCTAssertEqual(set.right(3), 4)
        XCTAssertEqual(set.right(4), 5)
        XCTAssertEqual(set.right(5), 5)
        XCTAssertEqual(set.right(6), 5)
        XCTAssertEqual(set.remove(1), true)
        XCTAssertEqual(set.remove(3), true)
        XCTAssertEqual(set.remove(1), false)
        XCTAssertEqual(set.remove(3), false)
        XCTAssertEqual(set.buckets.flatMap{$0}, [0,2,4])
        XCTAssertEqual(set.left(-1), 0)
        XCTAssertEqual(set.left(0), 0)
        XCTAssertEqual(set.left(1), 1)
        XCTAssertEqual(set.left(2), 1)
        XCTAssertEqual(set.left(3), 2)
        XCTAssertEqual(set.left(4), 2)
        XCTAssertEqual(set.left(5), 3)
        XCTAssertEqual(set.right(-1), 0)
        XCTAssertEqual(set.right(0), 1)
        XCTAssertEqual(set.right(1), 1)
        XCTAssertEqual(set.right(2), 2)
        XCTAssertEqual(set.right(3), 2)
        XCTAssertEqual(set.right(4), 3)
        XCTAssertEqual(set.right(5), 3)
        XCTAssertEqual(set.remove(2), true)
        XCTAssertEqual(set.remove(1), false)
        XCTAssertEqual(set.remove(2), false)
        XCTAssertEqual(set.remove(3), false)
        XCTAssertEqual(set.buckets.flatMap{$0}, [0,4])
        XCTAssertEqual(set.left(-1), 0)
        XCTAssertEqual(set.left(0), 0)
        XCTAssertEqual(set.left(1), 1)
        XCTAssertEqual(set.left(2), 1)
        XCTAssertEqual(set.left(3), 1)
        XCTAssertEqual(set.left(4), 1)
        XCTAssertEqual(set.left(5), 2)
        XCTAssertEqual(set.right(-1), 0)
        XCTAssertEqual(set.right(0), 1)
        XCTAssertEqual(set.right(1), 1)
        XCTAssertEqual(set.right(2), 1)
        XCTAssertEqual(set.right(3), 1)
        XCTAssertEqual(set.right(4), 2)
        XCTAssertEqual(set.right(5), 2)
        XCTAssertEqual(set.remove(0), true)
        XCTAssertEqual(set.remove(1), false)
        XCTAssertEqual(set.remove(2), false)
        XCTAssertEqual(set.remove(3), false)
        XCTAssertEqual(set.remove(4), true)
        XCTAssertEqual(set.left(-1), 0)
        XCTAssertEqual(set.left(0), 0)
        XCTAssertEqual(set.left(1), 0)
        XCTAssertEqual(set.left(2), 0)
        XCTAssertEqual(set.left(3), 0)
        XCTAssertEqual(set.left(4), 0)
        XCTAssertEqual(set.left(5), 0)
        XCTAssertEqual(set.right(-1), 0)
        XCTAssertEqual(set.right(0), 0)
        XCTAssertEqual(set.right(1), 0)
        XCTAssertEqual(set.right(2), 0)
        XCTAssertEqual(set.right(3), 0)
        XCTAssertEqual(set.right(4), 0)
        XCTAssertEqual(set.right(5), 0)
        XCTAssertEqual(set.buckets.flatMap{$0}, [])
    }
    
    func testExample7() throws {
        var set = SortedSet<Int>([0,1,2,3,4])
        XCTAssertEqual(set[0], 0)
        XCTAssertEqual(set[1], 1)
        XCTAssertEqual(set[2], 2)
        XCTAssertEqual(set[3], 3)
        XCTAssertEqual(set[4], 4)

        XCTAssertEqual(set[-1], 4)
        XCTAssertEqual(set[-2], 3)
        XCTAssertEqual(set[-3], 2)
        XCTAssertEqual(set[-4], 1)
        XCTAssertEqual(set[-5], 0)
    }
    
    func testExample8() throws {
        var set = SortedSet<Int>(0..<1000)
        XCTAssertEqual(set.map{ $0 }, (0..<1000) + [])
    }


    func testPerformanceExample0() throws {
        throw XCTSkip()
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            var set = SortedSet<Int>((0 ..< 1_000_000) + [])
        }
    }
    
    func testPerformanceExample1() throws {
        throw XCTSkip()
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            var set = SortedSet<Int>(0 ..< 1_000_000)
        }
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
//            var set = SortedSet<Int>(a: 0 ..< 5_000_000)
//            XCTAssertEqual(set.pop(999),999)
        }
    }

}
