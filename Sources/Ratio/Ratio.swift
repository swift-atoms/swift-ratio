public import Multiplication
public import Magnitude
@_exported public import Cardinal
@_exported public import Carrier_Protocol
@_exported public import Polarity
@_exported public import Property
@_exported public import Tagged

public struct Ratio<From: ~Copyable & ~Escapable, To: ~Copyable & ~Escapable>: Hashable,
    Sendable
{
    public typealias Magnitude = Magnitude::Magnitude<Cardinal>

    @usableFromInline
    internal let _polarity: Polarity

    public let magnitude: Magnitude

    @inlinable
    public init(polarity: Polarity, magnitude: Magnitude) {
        self._polarity = magnitude.value == .zero ? .positive : polarity
        self.magnitude = magnitude
    }

    @inlinable
    public var polarity: Polarity? {
        magnitude.value == .zero ? nil : _polarity
    }

    @inlinable
    public init(_ factor: Int) {
        self.init(
            polarity: factor >= 0 ? .positive : .negative,
            magnitude: Magnitude(Cardinal(factor.magnitude))
        )
    }

    @inlinable
    public static func positive(_ magnitude: Magnitude) -> Self {
        Self(polarity: .positive, magnitude: magnitude)
    }

    @inlinable
    public static func negative(_ magnitude: Magnitude) -> Self {
        Self(polarity: .negative, magnitude: magnitude)
    }

    @inlinable
    public static var zero: Self { .positive(Magnitude(.zero)) }
}

extension Ratio where From == To, From: ~Copyable & ~Escapable {
    @inlinable public static var identity: Self { .positive(Magnitude(Cardinal(1 as UInt))) }
    @inlinable public static var negate: Self { .negative(Magnitude(Cardinal(1 as UInt))) }
}

extension Ratio: CustomStringConvertible {
    public var description: String {
        let factor: String
        switch polarity {
        case .some(.positive): factor = magnitude.value.rawValue.description
        case .some(.negative): factor = "-" + magnitude.value.rawValue.description
        case nil: factor = "0"
        }
        return "Ratio<\(From.self), \(To.self)>(\(factor))"
    }
}

extension Ratio: ExpressibleByIntegerLiteral where From == To {
    @_disfavoredOverload
    @inlinable public init(integerLiteral value: Int) { self.init(value) }
}

extension Ratio where From: ~Copyable & ~Escapable, To: ~Copyable & ~Escapable {
    public enum Error: Swift.Error, Hashable, Sendable {
        case zeroFactor
        case negativeFactor
        case overflow
        case unrepresentable
    }


    @inlinable
    public var multiply: Property<Multiplication, Self> { Property(self) }

    @inlinable
    public func intValue() throws(Error) -> Int {
        switch polarity {
        case nil:
            return 0
        case .some(.positive):
            guard magnitude.value.rawValue <= UInt(Int.max) else { throw .unrepresentable }
            return Int(magnitude.value.rawValue)
        case .some(.negative):
            let minimumMagnitude = UInt(Int.max) + 1
            if magnitude.value.rawValue == minimumMagnitude { return Int.min }
            guard magnitude.value.rawValue <= UInt(Int.max) else { throw .unrepresentable }
            return -Int(magnitude.value.rawValue)
        }
    }
}

extension Property {
    @inlinable
    public func exact<
        A: ~Copyable & ~Escapable,
        B: ~Copyable & ~Escapable,
        C: ~Copyable & ~Escapable
    >(
        by other: Ratio<B, C>
    ) throws(Ratio<A, C>.Error) -> Ratio<A, C>
    where Tag == Multiplication, Base == Ratio<A, B> {
        let result: (polarity: Polarity, magnitude: UInt)
        do {
            result = try Multiplication.Signed.exact(
                lhsMagnitude: base.magnitude.value.rawValue,
                lhsPolarity: base._polarity,
                rhsMagnitude: other.magnitude.value.rawValue,
                rhsPolarity: other._polarity
            )
        } catch {
            throw .overflow
        }
        return Ratio<A, C>(
            polarity: result.polarity,
            magnitude: Ratio<A, C>.Magnitude(Cardinal(result.magnitude))
        )
    }

    @inlinable
    public func exact<
        A: ~Copyable & ~Escapable,
        B: ~Copyable & ~Escapable,
        Input: Carrier.`Protocol`
    >(
        by count: Input
    ) throws(Ratio<A, B>.Error) -> Tagged<B, Cardinal>
    where
        Tag == Multiplication,
        Base == Ratio<A, B>,
        Input.Domain == A,
        Input.Underlying == Cardinal
    {
        Tagged<B, Cardinal>(
            _unchecked: try base.multiplyCardinalExactly(count.underlying)
        )
    }
}

extension Ratio where From: ~Copyable & ~Escapable, To: ~Copyable & ~Escapable {

    @usableFromInline
    internal func multiplyCardinalExactly(_ count: Cardinal) throws(Error) -> Cardinal {
        if count.rawValue == 0 { return Cardinal(0 as UInt) }
        guard polarity != .negative else { throw .negativeFactor }
        do {
            return Cardinal(
                try Multiplication.exact(magnitude.value.rawValue, count.rawValue)
            )
        } catch {
            throw .overflow
        }
    }
}

@inlinable
public func * <
    A: ~Copyable & ~Escapable,
    B: ~Copyable & ~Escapable,
    C: ~Copyable & ~Escapable
>(
    lhs: Ratio<A, B>, rhs: Ratio<B, C>
) -> Ratio<A, C> {
    do { return try lhs.multiply.exact(by: rhs) }
    catch { preconditionFailure("Ratio overflow in multiplication") }
}

@inlinable
public func * <
    A: ~Copyable & ~Escapable,
    B: ~Copyable & ~Escapable,
    Input: Carrier.`Protocol`
>(
    lhs: Ratio<A, B>, rhs: Input
) -> Tagged<B, Cardinal>
where Input.Domain == A, Input.Underlying == Cardinal {
    do { return try lhs.multiply.exact(by: rhs) }
    catch let error {
        preconditionFailure("Invalid Cardinal scaling by Ratio: \(error)")
    }
}

@inlinable
public func * <
    A: ~Copyable & ~Escapable,
    B: ~Copyable & ~Escapable,
    Input: Carrier.`Protocol`
>(
    lhs: Input, rhs: Ratio<A, B>
) -> Tagged<B, Cardinal>
where Input.Domain == A, Input.Underlying == Cardinal {
    rhs * lhs
}

extension Ratio where From: ~Copyable & ~Escapable, To: ~Copyable & ~Escapable {
    @inlinable
    public func quotientAndRemainder(
        dividing count: Tagged<To, Cardinal>
    ) throws(Error) -> (quotient: Tagged<From, Cardinal>, remainder: Tagged<To, Cardinal>) {
        guard polarity != nil else { throw .zeroFactor }
        guard polarity == .positive else { throw .negativeFactor }
        let result = count.underlying.rawValue.quotientAndRemainder(
            dividingBy: magnitude.value.rawValue
        )
        return (
            Tagged<From, Cardinal>(_unchecked: Cardinal(result.quotient)),
            Tagged<To, Cardinal>(_unchecked: Cardinal(result.remainder))
        )
    }
}

extension Ratio: Magnitude::Representable {}
