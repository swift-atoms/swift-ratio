@_exported public import Cardinal
@_exported public import Carrier
public import Magnitude
@_exported public import Polarity
@_exported public import Property
public import Rational
@_exported public import Tagged

public struct Ratio<From: ~Copyable & ~Escapable, To: ~Copyable & ~Escapable>: Hashable, Sendable {
    public let value: Rational
}

extension Ratio where From: ~Copyable & ~Escapable, To: ~Copyable & ~Escapable {
    public typealias Magnitude = Magnitude::Magnitude<Rational>

    public init(_ value: Rational) { self.value = value }

    public init(_ factor: Int) { self.init(Rational(Int128(factor))) }

    public init(
        numerator: UInt128,
        denominator: UInt128 = 1,
        polarity: Polarity = .positive
    ) throws(Error) {
        do {
            self.init(try Rational(numerator: numerator, denominator: denominator, polarity: polarity))
        } catch { throw Error(error) }
    }

    public init(polarity: Polarity, magnitude: Magnitude) {
        self.init(polarity == .negative ? -magnitude.value : magnitude.value)
    }

    public static func positive(_ magnitude: Magnitude) -> Self {
        Self(polarity: .positive, magnitude: magnitude)
    }

    public static func negative(_ magnitude: Magnitude) -> Self {
        Self(polarity: .negative, magnitude: magnitude)
    }

    public static var zero: Self { Self(Rational.zero) }

    public var polarity: Polarity? { value.polarity }
    public var numerator: Integer { value.numerator }
    public var denominator: Integer { value.denominator }

    public func intValue() throws(Error) -> Int {
        let integer: Int128
        do { integer = try value.integer(as: Int128.self) } catch { throw error == .inexact ? .inexact : .unrepresentable }
        guard let result = Int(exactly: integer) else { throw .unrepresentable }
        return result
    }

    public func inverted() throws(Error) -> Ratio<To, From> {
        do { return Ratio<To, From>(try value.inverted()) } catch { throw Error(error) }
    }

    public func composed<Next: ~Copyable & ~Escapable>(
        with other: Ratio<To, Next>
    ) throws(Error) -> Ratio<From, Next> {
        return Ratio<From, Next>(value.multiplied(by: other.value))
    }

    public func applying(to quantity: Rational) throws(Error) -> Rational {
        return value.multiplied(by: quantity)
    }

    public func applying(to quantity: Int128) throws(Error) -> Int128 {
        do { return try value.applying(to: quantity) } catch { throw Error(error) }
    }

    public func applying(to quantity: Tagged<From, Rational>) throws(Error) -> Tagged<To, Rational> {
        Tagged<To, Rational>(_unchecked: try applying(to: quantity.underlying))
    }

    public func applying(to quantity: Tagged<From, Int128>) throws(Error) -> Tagged<To, Int128> {
        Tagged<To, Int128>(_unchecked: try applying(to: quantity.underlying))
    }

    public func quotient(dividing quantity: Int128) throws(Error) -> (quotient: Int128, remainder: Int128) {
        guard polarity != nil else { throw .zeroFactor }
        guard polarity == .positive else { throw .negativeFactor }
        guard denominator == 1 else { throw .nonintegralFactor }
        do { return try value.quotient(dividing: quantity) } catch { throw Error(error) }
    }

    public func quotient(
        dividing quantity: Tagged<To, Int128>
    ) throws(Error) -> (quotient: Tagged<From, Int128>, remainder: Tagged<To, Int128>) {
        let result = try quotient(dividing: quantity.underlying)
        return (
            Tagged<From, Int128>(_unchecked: result.quotient),
            Tagged<To, Int128>(_unchecked: result.remainder)
        )
    }
}

extension Ratio where From == To, From: ~Copyable & ~Escapable {
    public static var identity: Self { Self(Rational.one) }
    public static var negate: Self { Self(-Rational.one) }
}

extension Ratio: Magnitude::Representable where From: ~Copyable & ~Escapable, To: ~Copyable & ~Escapable {
    public var magnitude: Magnitude { value.magnitude }
}

#if !hasFeature(Embedded)
    extension Ratio: Swift::Codable where From: ~Copyable & ~Escapable, To: ~Copyable & ~Escapable {}
#endif

#if Ordinal
    @_exported public import Cardinal
    @_exported public import Carrier
    @_exported public import Difference
    @_exported public import Ordinal
    @_exported public import Tagged

    extension Ratio where From: ~Copyable & ~Escapable, To: ~Copyable & ~Escapable {

        public func applying<Input: Carrier.`Protocol`>(
            to index: Input
        ) throws(Error) -> Tagged<To, Ordinal>
        where Input.Domain == From, Input.Underlying == Ordinal {
            let count = Tagged<From, Cardinal>(_unchecked: Cardinal(index.underlying.rawValue))
            let converted = try applying(to: count)
            return Tagged<To, Ordinal>(_unchecked: Ordinal(converted.underlying.rawValue))
        }

        public func quotientAndRemainder(
            dividing index: Tagged<To, Ordinal>
        ) throws(Error) -> (
            quotient: Tagged<From, Ordinal>, remainder: Tagged<To, Difference>
        ) {
            let count = Tagged<To, Cardinal>(_unchecked: Cardinal(index.underlying.rawValue))
            let result = try quotientAndRemainder(dividing: count)
            return (
                Tagged<From, Ordinal>(_unchecked: Ordinal(result.quotient.underlying.rawValue)),
                Tagged<To, Difference>(
                    _unchecked: .positive(Difference.Magnitude(result.remainder.underlying))
                )
            )
        }
    }
#endif

extension Ratio: Swift::CustomStringConvertible {
    public var description: String { "Ratio<\(From.self), \(To.self)>(\(value))" }
}

extension Ratio: Swift::ExpressibleByIntegerLiteral where From == To {
    @_disfavoredOverload
    public init(integerLiteral value: Int) { self.init(value) }
}
