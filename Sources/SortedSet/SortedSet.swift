import Foundation

//class SortedSet(Generic[T]):

enum SortedSetCondition {
//    BUCKET_RATIO = 16
//    SPLIT_RATIO = 24
    static var BUCKET_RATIO: Double = 16
    static var SPLIT_RATIO: Int = 24
}

public struct SortedSet<Element: Comparable> {
    let BUCKET_RATIO: Double = SortedSetCondition.BUCKET_RATIO
    let SPLIT_RATIO: Int = SortedSetCondition.SPLIT_RATIO
    
    public typealias Index = ArraySlice<Element>.Index
    typealias BucketIndex = Array<ArraySlice<Element>>.Index
    var buckets: Array<ArraySlice<Element>>
    public private(set) var count: Int
    var isEmpty: Bool { count == 0 }
    //    def __init__(self, a: Iterable[T] = []) -> None:
    //        "Make a new SortedSet from iterable. / O(N) if sorted and unique / O(N log N)"
    //        a = list(a)
    //        n = len(a)
    //        if any(a[i] > a[i + 1] for i in range(n - 1)):
    //            a.sort()
    //        if any(a[i] >= a[i + 1] for i in range(n - 1)):
    //            a, b = [], a
    //            for x in b:
    //                if not a or a[-1] != x:
    //                    a.append(x)
    //        n = self.size = len(a)
    //        num_bucket = int(math.ceil(math.sqrt(n / self.BUCKET_RATIO)))
    //        self.a = [a[n * i // num_bucket : n * (i + 1) // num_bucket] for i in range(num_bucket)]
    private init(uniqued a: [Element]) {
        let n = a.count
        let num_bucket: Int = Int(ceil(sqrt(Double(n) / BUCKET_RATIO)))
        buckets = (0..<num_bucket).map{ i in a[n * i / num_bucket ..< n * (i + 1) / num_bucket] }
        count = n
    }

    init() {
        self.init(uniqued: [])
    }

    init(_ range: Range<Element>) where Element: FixedWidthInteger {
        self.init(uniqued: range + [])
    }

    init<S>(_ _a: S) where S: Collection, S.Element == Element {
        var a = _a + []
        if (0..<Swift.max(0,a.count - 1)).contains(where: { a[$0] > a[$0 + 1] }) {
            a.sort()
        }
        if (0..<Swift.max(0,a.count - 1)).contains(where: { a[$0] >= a[$0 + 1] }) {
            var (a,b): ([Element],[Element]) = ([],a)
            for x in b {
                if a.isEmpty || a.last != x {
                    a.append(x)
                }
            }
        }
        self.init(uniqued: a)
    }
}

extension SortedSet: Sequence {
    //    def __iter__(self) -> Iterator[T]:
    //        for i in self.a:
    //            for j in i: yield j
    public struct Iterator: IteratorProtocol {
        public mutating func next() -> Element? {
            if b == buckets.endIndex {
                return nil
            }
            defer {
                i += 1
                if buckets[b].endIndex <= i {
                    b += 1
                    if b < buckets.endIndex {
                        i = buckets[b].startIndex
                    }
                }
            }
            return buckets[b][i]
        }
        let buckets: [ArraySlice<Element>]
        var i: Index = 0
        var b: BucketIndex = 0
    }
    public func makeIterator() -> Iterator {
        Iterator(buckets: buckets)
    }
    //    def __reversed__(self) -> Iterator[T]:
    //        for i in reversed(self.a):
    //            for j in reversed(i): yield j
}

extension SortedSet: Equatable {
    //    def __eq__(self, other) -> bool:
    //        return list(self) == list(other)
}

extension SortedSet {
    //    def __len__(self) -> int:
    //        return self.size
    //
    //    def __repr__(self) -> str:
    //        return "SortedSet" + str(self.a)
    //
    //    def __str__(self) -> str:
    //        s = str(list(self))
    //        return "{" + s[1 : len(s) - 1] + "}"
}

extension SortedSet {
    //    def _position(self, x: T) -> Tuple[List[T], int, int]:
    //        "return the bucket, index of the bucket and position in which x should be. self must not be empty."
    //        for i, a in enumerate(self.a):
    //            if x <= a[-1]: break
    //        return (a, i, bisect_left(a, x))
    private func _position(_ x: Element) -> (ArraySlice<Element>, BucketIndex, Index) {
        var (left, right) = (buckets.startIndex, buckets.endIndex)
        while left < right {
            let mid = (left + right) >> 1
            if let l = buckets[mid].last, l < x {
                left = mid + 1
            } else {
                right = mid
            }
        }
        var bucketIndex = left
        if bucketIndex == buckets.endIndex {
            bucketIndex -= 1
        }
        return (buckets[bucketIndex], bucketIndex, buckets[bucketIndex].left(x))
    }
    //    def __contains__(self, x: T) -> bool:
    //        if self.size == 0: return False
    //        a, _, i = self._position(x)
    //        return i != len(a) and a[i] == x
    public func contains(_ x: Element) -> Bool {
        if count == 0 { return false }
        let (bucket,_,i) = _position(x)
        return i < bucket.endIndex && bucket[i] == x
    }
    //    def add(self, x: T) -> bool:
    //        "Add an element and return True if added. / O(√N)"
    //        if self.size == 0:
    //            self.a = [[x]]
    //            self.size = 1
    //            return True
    //        a, b, i = self._position(x)
    //        if i != len(a) and a[i] == x: return False
    //        a.insert(i, x)
    //        self.size += 1
    //        if len(a) > len(self.a) * self.SPLIT_RATIO:
    //            mid = len(a) >> 1
    //            self.a[b:b+1] = [a[:mid], a[mid:]]
    //        return True
    public mutating func insert(_ x: Element) -> Bool {
        if count == 0 {
            buckets = [[x]]
            count = 1
            return true
        }
        let (b,bi,i) = _position(x)
        if i < b.endIndex, b[i] == x { return false }
        buckets[bi].insert(x, at: i)
        count += 1
        if buckets[bi].count > buckets.count * SPLIT_RATIO {
            let mid = buckets[bi].count >> 1
            if mid != buckets[bi].startIndex {
                buckets[bi ..< bi + 1] = [ buckets[bi][..<mid], buckets[bi][mid...] ]
                buckets = buckets.map{ ArraySlice($0) }
            }
        }
        return true
    }
    //    def _pop(self, a: List[T], b: int, i: int) -> T:
    //        ans = a.pop(i)
    //        self.size -= 1
    //        if not a: del self.a[b]
    //        return ans
    private mutating func _pop(bucketIndex: BucketIndex, index: Index) -> Element {
        let ans = buckets[bucketIndex].remove(at: index)
        count -= 1
        if buckets[bucketIndex].isEmpty {
            buckets.remove(at: bucketIndex)
        }
        return ans
    }
    //    def discard(self, x: T) -> bool:
    //        "Remove an element and return True if removed. / O(√N)"
    //        if self.size == 0: return False
    //        a, b, i = self._position(x)
    //        if i == len(a) or a[i] != x: return False
    //        self._pop(a, b, i)
    //        return True
    public mutating func remove(_ x: Element) -> Bool {
        if count == 0 { return false }
        let (b, bi, i) = _position(x)
        if i == b.endIndex || b[i] != x { return false }
        _ = _pop(bucketIndex: bi, index: i)
        return true
    }
    //    def lt(self, x: T) -> Optional[T]:
    //        "Find the largest element < x, or None if it doesn't exist."
    //        for a in reversed(self.a):
    //            if a[0] < x:
    //                return a[bisect_left(a, x) - 1]
    public func lt(_ x: Element) -> Element? {
        for bucket in buckets.reversed() {
            if bucket[bucket.startIndex] < x { return bucket[bucket.left(x) - 1] }
        }
        return nil
    }
    //    def le(self, x: T) -> Optional[T]:
    //        "Find the largest element <= x, or None if it doesn't exist."
    //        for a in reversed(self.a):
    //            if a[0] <= x:
    //                return a[bisect_right(a, x) - 1]
    public func le(_ x: Element) -> Element? {
        for bucket in buckets.reversed() {
            if bucket[bucket.startIndex] <= x { return bucket[bucket.right(x) - 1] }
        }
        return nil
    }
    //    def gt(self, x: T) -> Optional[T]:
    //        "Find the smallest element > x, or None if it doesn't exist."
    //        for a in self.a:
    //            if a[-1] > x:
    //                return a[bisect_right(a, x)]
    public func gt(_ x: Element) -> Element? {
        for bucket in buckets {
            if let l = bucket.last, l > x {
                return bucket[bucket.right(x)]
            }
        }
        return nil
    }
    //    def ge(self, x: T) -> Optional[T]:
    //        "Find the smallest element >= x, or None if it doesn't exist."
    //        for a in self.a:
    //            if a[-1] >= x:
    //                return a[bisect_left(a, x)]
    public func ge(_ x: Element) -> Element? {
        for bucket in buckets {
            if let l = bucket.last, l >= x {
                return bucket[bucket.left(x)]
            }
        }
        return nil
    }
    //    def __getitem__(self, i: int) -> T:
    //        "Return the i-th element."
    //        if i < 0:
    //            for a in reversed(self.a):
    //                i += len(a)
    //                if i >= 0: return a[i]
    //        else:
    //            for a in self.a:
    //                if i < len(a): return a[i]
    //                i -= len(a)
    //        raise IndexError
    public subscript(index: Index) -> Element {
        var i = index
        if i < 0 {
            for bucket in buckets.reversed() {
                i += bucket.count
                if i >= 0 {
                    return bucket[bucket.startIndex + i]
                }
            }
        }
        else {
            for bucket in buckets {
                if i < bucket.count {
                    return bucket[bucket.startIndex + i]
                }
                i -= bucket.count
            }
        }
        fatalError("IndexError")
    }
    //    def pop(self, i: int = -1) -> T:
    //        "Pop and return the i-th element."
    //        if i < 0:
    //            for b, a in enumerate(reversed(self.a)):
    //                i += len(a)
    //                if i >= 0: return self._pop(a, ~b, i)
    //        else:
    //            for b, a in enumerate(self.a):
    //                if i < len(a): return self._pop(a, b, i)
    //                i -= len(a)
    //        raise IndexError
    public mutating func pop(_ index: Index) -> Element? {
        var i = index
        if i < 0 {
            for (b,bucket) in buckets.enumerated().reversed() {
                i += bucket.count
                if i >= 0 {
                    return _pop(bucketIndex: b, index: bucket.startIndex + i)
                }
            }
        }
        else {
            for (b,bucket) in buckets.enumerated() {
                if i < bucket.count {
                    return _pop(bucketIndex: b, index: bucket.startIndex + i)
                }
                i -= bucket.count
            }
        }
        return nil
    }
    //    def index(self, x: T) -> int:
    //        "Count the number of elements < x."
    //        ans = 0
    //        for a in self.a:
    //            if a[-1] >= x:
    //                return ans + bisect_left(a, x)
    //            ans += len(a)
    //        return ans
    public func left(_ x: Element) -> Index {
        var ans = 0
        for bucket in buckets {
            if let l = bucket.last, l >= x {
                return ans - bucket.startIndex + bucket.left(x)
            }
            ans += bucket.count
        }
        return ans
    }
    //    def index_right(self, x: T) -> int:
    //        "Count the number of elements <= x."
    //        ans = 0
    //        for a in self.a:
    //            if a[-1] > x:
    //                return ans + bisect_right(a, x)
    //            ans += len(a)
    //        return ans
    public func right(_ x: Element) -> Index {
        var ans = 0
        for bucket in buckets {
            if let l = bucket.last, l > x {
                return ans - bucket.startIndex + bucket.right(x)
            }
            ans += bucket.count
        }
        return ans
    }
}
