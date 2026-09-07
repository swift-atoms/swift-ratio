import Cardinal
import Difference
import Rational
import Ratio
import Tagged
import Testing

private enum Second {}
private enum Minute {}
private enum Yoctosecond {}

@Suite
struct `Ratio Rational Tests` {}

extension `Ratio Rational Tests` {
    @Test
    func `inverse minute conversion preserves fractions and domains`() throws {
        let seconds = try Ratio<Minute, Second>(numerator: 60)
        let minutes = try seconds.inverted()
        let input = Tagged<Second, Rational>(_unchecked: Rational(-1))
        let output: Tagged<Minute, Rational> = try minutes.applying(to: input)
        #expect(try output.underlying == Rational(numerator: 1, denominator: 60, polarity: .negative))
        #expect(try seconds.applying(to: output) == input)
        #expect(try minutes.composed(with: seconds) == Ratio<Second, Second>.identity)
        #expect(throws: Ratio::Failure.inexact) { try minutes.applying(to: Int128(-1)) }
    }

    @Test
    func `SI fractional endpoints compose exactly`() throws {
        let factor: UInt128 = 1_000_000_000_000_000_000_000_000
        let seconds = try Ratio<Second, Yoctosecond>(numerator: factor)
        let minutes = try Ratio<Minute, Second>(numerator: 60)
        let combined: Ratio<Minute, Yoctosecond> = try minutes.composed(with: seconds)
        #expect(combined.numerator == Integer(factor * 60) && combined.denominator == 1)
        #expect(try combined.applying(to: Int128(-1)) == -Int128(factor * 60))
        let fraction = try combined.inverted().applying(to: Rational(1))
        #expect(try fraction == Rational(numerator: 1, denominator: factor * 60))
    }

    @Test
    func `negative signed quantities use Euclidean quotient and remainder`() throws {
        let ratio = try Ratio<Minute, Second>(numerator: 60)
        let result = try ratio.quotient(dividing: Tagged<Second, Int128>(_unchecked: -61))
        let quotient: Tagged<Minute, Int128> = result.quotient
        let remainder: Tagged<Second, Int128> = result.remainder
        #expect(quotient.underlying == -2 && remainder.underlying == 59)
        #expect(throws: Ratio::Failure.nonintegralFactor) {
            try ratio.inverted().quotient(dividing: Int128(1))
        }
        #expect(throws: Ratio::Failure.zeroFactor) { try Ratio<Minute, Second>.zero.inverted() }
    }

    @Test
    func `signed Difference scaling preserves the output domain and range`() throws {
        let ratio = try Ratio<Minute, Second>(numerator: 60)
        let input = Tagged<Minute, Difference>(_unchecked: Difference(-2))
        let output: Tagged<Second, Difference> = try ratio.applying(to: input)
        #expect(output.underlying == Difference(-120))
        #expect(try ratio.inverted().applying(to: output) == input)
        let maximum = Tagged<Minute, Difference>(_unchecked: Difference.positive(.init(Cardinal.max)))
        #expect(throws: Ratio::Failure.overflow) { try ratio.applying(to: maximum) }
    }

    @Test
    func `fractional Cardinal scaling rejects inexact output`() throws {
        let ratio = try Ratio<Second, Minute>(numerator: 1, denominator: 60)
        let whole = Tagged<Second, Cardinal>(_unchecked: Cardinal(120))
        #expect(try ratio.applying(to: whole).underlying == Cardinal(2))
        #expect(throws: Ratio::Failure.inexact) {
            try ratio.applying(to: Tagged<Second, Cardinal>(_unchecked: Cardinal(1)))
        }
    }
}
