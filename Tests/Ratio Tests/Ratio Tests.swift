import Cardinal
import Magnitude
import Testing
import Ratio
import Rational

private enum A {}
private enum B {}
private enum C {}

private func magnitude(_ value: UInt128) -> Magnitude::Magnitude<Rational> {
    try! Rational(numerator: value).magnitude
}

private struct Count<Tag>: Carrier.`Protocol` {
    typealias Domain = Tag
    let underlying: Cardinal
    init(_ underlying: Cardinal) { self.underlying = underlying }
}

@Test func `ratio preserves the full unsigned magnitude range`() {
    let positive = Ratio<A, B>.positive(magnitude(.max))
    let negative = Ratio<A, B>.negative(magnitude(.max))
    #expect(positive.magnitude == magnitude(.max))
    #expect(positive.polarity == .positive)
    #expect(negative.magnitude == magnitude(.max))
    #expect(negative.polarity == .negative)
}

@Test func `zero is canonical regardless of requested polarity`() {
    let positive = Ratio<A, B>(polarity: .positive, magnitude: magnitude(0))
    let negative = Ratio<A, B>(polarity: .negative, magnitude: magnitude(0))
    #expect(positive == .zero)
    #expect(negative == .zero)
    #expect(positive.polarity == nil)
    #expect(negative.polarity == nil)
}

@Test func `composition matches its intermediate domain and signs`() throws {
    let ab = Ratio<A, B>.negative(magnitude(2))
    let bc = Ratio<B, C>.negative(magnitude(3))
    let ac: Ratio<A, C> = try ab.multiply.exact(by: bc)
    #expect(ac == .positive(magnitude(6)))
}

@Test func `composition detects overflow`() {
    #expect(throws: Ratio<A, C>.Error.overflow) {
        try Ratio<A, B>.positive(magnitude(.max)).multiply.exact(
            by: Ratio<B, C>.positive(magnitude(2))
        )
    }
}

@Test func `zero composition is canonical across full-width factors`() throws {
    let exact: Ratio<A, C> = try Ratio<A, B>.zero.multiply.exact(
        by: Ratio<B, C>.negative(magnitude(.max))
    )
    let ordinary: Ratio<A, C> = Ratio<A, B>.positive(magnitude(.max)) * Ratio<B, C>.zero
    #expect(exact == .zero)
    #expect(ordinary == .zero)
}

@Test func `cardinal quotient supports UInt max`() throws {
    let ratio = Ratio<A, B>.positive(magnitude(2))
    let count = Tagged<B, Cardinal>(_unchecked: .max)
    let result = try ratio.quotientAndRemainder(dividing: count)
    #expect(result.quotient.underlying.rawValue == UInt.max / 2)
    #expect(result.remainder.underlying.rawValue == UInt.max % 2)
}

@Test func `cardinal quotient rejects zero and negative factors`() {
    let count = Tagged<B, Cardinal>(_unchecked: Cardinal(1))
    #expect(throws: Ratio<A, B>.Error.zeroFactor) {
        try Ratio<A, B>.zero.quotientAndRemainder(dividing: count)
    }
    #expect(throws: Ratio<A, B>.Error.negativeFactor) {
        try Ratio<A, B>.negative(magnitude(1)).quotientAndRemainder(dividing: count)
    }
}

@Test func `tagged cardinal scaling changes domain`() throws {
    let count = Tagged<A, Cardinal>(_unchecked: Cardinal(7))
    let result: Tagged<B, Cardinal> = try Ratio<A, B>.positive(magnitude(3)).multiply.exact(
        by: count
    )
    #expect(result.underlying == Cardinal(21))
}

@Test func `custom cardinal carriers scale in both operator directions`() throws {
    let count = Count<A>(Cardinal(7))
    let ratio = Ratio<A, B>.positive(magnitude(3))
    let exact: Tagged<B, Cardinal> = try ratio.multiply.exact(by: count)
    let forward: Tagged<B, Cardinal> = ratio * count
    let reverse: Tagged<B, Cardinal> = count * ratio
    #expect(exact.underlying == Cardinal(21))
    #expect(forward == exact)
    #expect(reverse == exact)
}

@Test func `negative ratio accepts zero Cardinal and rejects nonzero Cardinal`() throws {
    let ratio = Ratio<A, B>.negative(magnitude(.max))
    let zero = Count<A>(Cardinal(0))
    let one = Count<A>(Cardinal(1))
    #expect(try ratio.multiply.exact(by: zero).underlying == Cardinal(0))
    #expect((ratio * zero).underlying == Cardinal(0))
    #expect((zero * ratio).underlying == Cardinal(0))
    #expect(throws: Ratio<A, B>.Error.negativeFactor) {
        try ratio.multiply.exact(by: one)
    }
}

@Test func `cardinal scaling supports full width and detects overflow`() throws {
    let maximum = Count<A>(Cardinal.max)
    let identity = Ratio<A, B>.positive(magnitude(1))
    #expect(try identity.multiply.exact(by: maximum).underlying == .max)
    #expect(throws: Ratio<A, B>.Error.overflow) {
        try Ratio<A, B>.positive(magnitude(2)).multiply.exact(by: maximum)
    }
}

@Test func `Int conversion is exact`() throws {
    #expect(try Ratio<A, B>(Int.min).intValue() == Int.min)
    #expect(throws: Ratio<A, B>.Error.unrepresentable) {
        try Ratio<A, B>.positive(magnitude(.max)).intValue()
    }
}
