#if Ordinal && Difference
import Difference
import Ratio
import Cardinal
import Ordinal
import Tagged
import Tagged
import Testing

private enum Element {}
private enum Other {}

extension Difference {
    @Suite
    struct `Tagged Offset` {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
        @Suite(.serialized) struct Performance {}
    }
}

extension Difference.`Tagged Offset`.Unit {

    @Test
    func `offset is tagged vector`() {
        let offset: Tagged<Element, Ordinal>.Offset = 3

        let taggedVector: Tagged<Element, Difference> = offset
        #expect(taggedVector.underlying == Difference(3))
    }

    @Test
    func `construction from int`() {
        let offset = Tagged<Element, Ordinal>.Offset(5)
        #expect(offset.underlying == Difference(5))
    }

    @Test
    func `construction from negative int`() {
        let offset = Tagged<Element, Ordinal>.Offset(-3)
        #expect(offset.underlying == Difference(-3))
    }

    @Test
    func `construction from tagged cardinal`() {
        let count = Tagged<Element, Cardinal>(_unchecked: Cardinal(UInt(7)))
        let offset = Tagged<Element, Difference>(count)
        #expect(offset.underlying == Difference(7))
    }

    @Test
    func `construction from ordinal protocol`()  {
        let position = Tagged<Element, Ordinal>(_unchecked: Ordinal(UInt(5)))
        let offset = Tagged<Element, Difference>(position)
        #expect(offset.underlying == Difference(5))
    }

    @Test
    func `construction from zero`() {
        let position = Tagged<Element, Ordinal>(_unchecked: Ordinal(UInt(5)))
        let offset = Tagged<Element, Difference>(fromZero: position)
        #expect(offset.underlying == Difference(5))
    }

    @Test
    func `construction from integer literal`() {
        let offset: Tagged<Element, Ordinal>.Offset = 3
        #expect(offset.underlying == Difference(3))
    }

    @Test
    func `zero constant`() {
        let offset: Tagged<Element, Ordinal>.Offset = .zero
        #expect(offset.underlying == Difference(0))
    }

    @Test
    func `one constant`() {
        let offset: Tagged<Element, Ordinal>.Offset = .one
        #expect(offset.underlying == Difference(1))
    }

    @Test
    func `addition on tagged`() {
        let a: Tagged<Element, Ordinal>.Offset = 3
        let b: Tagged<Element, Ordinal>.Offset = 4
        let sum = a + b
        #expect(sum.underlying == Difference(7))
    }

    @Test
    func `subtraction on tagged`() {
        let a: Tagged<Element, Ordinal>.Offset = 5
        let b: Tagged<Element, Ordinal>.Offset = 2
        let diff = a - b
        #expect(diff.underlying == Difference(3))
    }

    @Test
    func `compound addition on tagged`() {
        var a: Tagged<Element, Ordinal>.Offset = 5
        a += Tagged<Element, Ordinal>.Offset(3)
        #expect(a.underlying == Difference(8))
    }

    @Test
    func `compound subtraction on tagged`() {
        var a: Tagged<Element, Ordinal>.Offset = 5
        a -= Tagged<Element, Ordinal>.Offset(3)
        #expect(a.underlying == Difference(2))
    }

    @Test
    func `unary minus on tagged`() {
        let v: Tagged<Element, Ordinal>.Offset = 5
        let negated: Tagged<Element, Ordinal>.Offset = -v
        #expect(negated.underlying == Difference(-5))
    }

    @Test
    func `magnitude of positive tagged offset`() {
        let offset: Tagged<Element, Ordinal>.Offset = 5
        let magnitude: Tagged<Element, Cardinal> = offset.magnitude.map { $0.value }
        #expect(magnitude.underlying == Cardinal(UInt(5)))
    }

    @Test
    func `magnitude of negative tagged offset`() {
        let offset: Tagged<Element, Ordinal>.Offset = -5
        let magnitude: Tagged<Element, Cardinal> = offset.magnitude.map { $0.value }
        #expect(magnitude.underlying == Cardinal(UInt(5)))
    }

    @Test
    func `tagged cardinal from non negative tagged vector`() throws(Cardinal.Error) {
        let offset: Tagged<Element, Ordinal>.Offset = 5
        let count: Tagged<Element, Cardinal> = try Tagged<Element, Cardinal>(offset)
        #expect(count.underlying == Cardinal(UInt(5)))
    }

    @Test
    func `vector less than cardinal same domain`() {
        let offset: Tagged<Element, Ordinal>.Offset = 3
        let count = Tagged<Element, Cardinal>(_unchecked: Cardinal(UInt(5)))
        #expect(offset < count)
    }

    @Test
    func `cardinal less than vector same domain`() {
        let count = Tagged<Element, Cardinal>(_unchecked: Cardinal(UInt(3)))
        let offset: Tagged<Element, Ordinal>.Offset = 5
        #expect(count < offset)
    }

    @Test
    func `vector equal to cardinal at zero`() {
        let offset: Tagged<Element, Ordinal>.Offset = .zero
        let count = Tagged<Element, Cardinal>(_unchecked: Cardinal(UInt(0)))
        #expect(offset <= count)
        #expect(offset >= count)
    }

    @Test
    func `negative vector less than any cardinal`() {
        let offset: Tagged<Element, Ordinal>.Offset = -1
        let count = Tagged<Element, Cardinal>(_unchecked: Cardinal(UInt(0)))
        #expect(offset < count)
    }

    @Test
    func `ratio scales tagged cardinal exactly`() throws {
        let ratio = Ratio<Element, Other>.init(3)
        let count = Tagged<Element, Cardinal>(_unchecked: Cardinal(UInt(4)))

        let forward: Tagged<Other, Cardinal> = try ratio.applying(to: count)
        let reverse: Tagged<Other, Cardinal> = try ratio.multiply.exact(by: count)

        #expect(forward.underlying == Cardinal(UInt(12)))
        #expect(reverse.underlying == Cardinal(UInt(12)))
    }

    @Test
    func `ratio scales tagged difference exactly`() throws {
        let ratio = Ratio<Element, Other>.init(3)
        let offset = Tagged<Element, Difference>(-4)

        let forward: Tagged<Other, Difference> = try ratio.applying(to: offset)
        let reverse: Tagged<Other, Difference> = try ratio.multiply.exact(by: offset)

        #expect(forward.underlying == Difference(-12))
        #expect(reverse.underlying == Difference(-12))
    }
}

extension Difference.`Tagged Offset`.`Edge Case` {

    @Test
    func `tagged cardinal from negative tagged vector throws`() {
        let offset: Tagged<Element, Ordinal>.Offset = -5
        #expect(throws: Cardinal.Error.negativeMagnitude(5)) {
            try Tagged<Element, Cardinal>(offset)
        }
    }

    @Test
    func `vector at int max compares below cardinal at uint max`() {
        let offset = Tagged<Element, Ordinal>.Offset(Int.max)
        let count = Tagged<Element, Cardinal>(_unchecked: .max)
        #expect(offset < count)
        #expect(offset <= count)
        #expect(!(offset > count))
        #expect(!(offset >= count))
    }

    @Test
    func `vector at int min compares below cardinal at uint max`() {
        let offset = Tagged<Element, Ordinal>.Offset(Int.min)
        let count = Tagged<Element, Cardinal>(_unchecked: .max)
        #expect(offset < count)
        #expect(offset <= count)
        #expect(!(offset > count))
        #expect(!(offset >= count))
    }

    @Test
    func `cardinal at uint max compares above vector at int max`() {
        let count = Tagged<Element, Cardinal>(_unchecked: .max)
        let offset = Tagged<Element, Ordinal>.Offset(Int.max)
        #expect(count > offset)
        #expect(count >= offset)
        #expect(!(count < offset))
        #expect(!(count <= offset))
    }

    @Test
    func `cardinal at uint max compares above vector at int min`() {
        let count = Tagged<Element, Cardinal>(_unchecked: .max)
        let offset = Tagged<Element, Ordinal>.Offset(Int.min)
        #expect(count > offset)
        #expect(count >= offset)
        #expect(!(count < offset))
        #expect(!(count <= offset))
    }
}

#endif
