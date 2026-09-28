#if Difference
import Carrier
import Difference
import Property
import Tagged
import Testing
import Ratio

private enum A {}
private enum B {}

private func magnitude(_ value: UInt) -> Difference.Magnitude {
    Difference.Magnitude(Cardinal(value))
}

private struct Offset<Tag>: Carrier.`Protocol` {
    typealias Domain = Tag
    let underlying: Difference
    init(_ underlying: Difference) { self.underlying = underlying }
}

@Test func `tagged difference scales across domains`() throws {
    let value = Tagged<A, Difference>(_unchecked: .negative(magnitude(3)))
    let ratio = Ratio<A, B>(Int(-4))
    let result = try ratio.multiply.exact(by: value)
    #expect(result.underlying == .positive(magnitude(12)))
}

@Test func `zero factor gives canonical zero`() throws {
    let value = Tagged<A, Difference>(_unchecked: .negative(magnitude(.max)))
    let result = try Ratio<A, B>.zero.multiply.exact(by: value)
    #expect(result.underlying == .zero)
}

@Test func `difference scaling detects overflow`() {
    let value = Tagged<A, Difference>(_unchecked: .positive(magnitude(2)))
    #expect(throws: Ratio<A, B>.Error.overflow) {
        try Ratio<A, B>(numerator: UInt128(UInt.max)).multiply.exact(by: value)
    }
}

@Test func `custom difference carriers scale in both operator directions`() throws {
    let value = Offset<A>(Difference.negative(magnitude(3)))
    let ratio = Ratio<A, B>(Int(-4))
    let exact: Tagged<B, Difference> = try ratio.multiply.exact(by: value)
    let forward: Tagged<B, Difference> = ratio * value
    let reverse: Tagged<B, Difference> = value * ratio
    #expect(exact.underlying == .positive(magnitude(12)))
    #expect(forward == exact)
    #expect(reverse == exact)
}

@Test func `full-width scaling and zero normalization are exact`() throws {
    let maximum = Offset<A>(Difference.negative(magnitude(.max)))
    let identity = Ratio<A, B>(Int(1))
    let fullWidth: Tagged<B, Difference> = try identity.multiply.exact(by: maximum)
    let zero: Tagged<B, Difference> = try Ratio<A, B>.zero.multiply.exact(by: maximum)
    #expect(fullWidth.underlying == .negative(magnitude(.max)))
    #expect(zero.underlying == .zero)
}

@Test func `rational signed scaling is exact or reports inexactness`() throws {
    let half = try Ratio<A, B>(numerator: 1, denominator: 2)
    let even = Offset<A>(Difference(-6))
    #expect(try half.applying(to: even).underlying == Difference(-3))
    #expect(throws: Ratio<A, B>.Error.inexact) {
        try half.applying(to: Offset<A>(Difference(-5)))
    }
}

#endif
