#if Ordinal
import Cardinal
import Carrier
import Difference
import Magnitude
import Ordinal
import Tagged
import Testing
import Ratio

private enum A {}
private enum B {}

@Test func `ordinal quotient supports UInt max`() throws {
    let ratio = Ratio<A, B>(2 as Int)
    let index = Tagged<B, Ordinal>(_unchecked: Ordinal(UInt.max))
    let result = try ratio.quotientAndRemainder(dividing: index)
    #expect(result.quotient.underlying.rawValue == UInt.max / 2)
    #expect(
        result.remainder.underlying
            == Difference(Int(UInt.max % 2))
    )
}

@Test func `ordinal quotient rejects zero and negative factors`() {
    let index = Tagged<B, Ordinal>(_unchecked: .zero)
    #expect(throws: Ratio<A, B>.Error.zeroFactor) {
        try Ratio<A, B>.zero.quotientAndRemainder(dividing: index)
    }
    #expect(throws: Ratio<A, B>.Error.negativeFactor) {
        try Ratio<A, B>(-1 as Int).quotientAndRemainder(dividing: index)
    }
}

@Test func `ordinal scaling delegates exact cardinal conversion`() throws {
    let ratio = try Ratio<A, B>(numerator: 1, denominator: 2)
    let index = Tagged<A, Ordinal>(_unchecked: Ordinal(6 as UInt))
    let result: Tagged<B, Ordinal> = try ratio.applying(to: index)
    #expect(result.underlying == Ordinal(3 as UInt))
    #expect(throws: Ratio<A, B>.Error.inexact) {
        try ratio.applying(to: Tagged<A, Ordinal>(_unchecked: Ordinal(5 as UInt)))
    }
    #expect(throws: Ratio<A, B>.Error.negativeFactor) {
        try Ratio<A, B>(-1 as Int).applying(to: index)
    }
}

@Test func `fractional factors cannot define discrete ordinal remainders`() throws {
    let ratio = try Ratio<A, B>(numerator: 1, denominator: 2)
    let index = Tagged<B, Ordinal>(_unchecked: Ordinal(6 as UInt))
    #expect(throws: Ratio<A, B>.Error.nonintegralFactor) {
        try ratio.quotientAndRemainder(dividing: index)
    }
}

#endif
