public import Cardinal
public import Carrier
public import Difference
internal import Division
internal import Magnitude
public import Multiplication
public import Property
internal import Rational
public import Tagged

extension Ratio where From: ~Copyable & ~Escapable, To: ~Copyable & ~Escapable {
    public var multiply: Property<Multiplication, Self> { Property(self) }

    public func applying<Input: Carrier.`Protocol`>(
        to count: Input
    ) throws(Error) -> Tagged<To, Cardinal>
    where Input.Domain == From, Input.Underlying == Cardinal {
        if count.underlying == .zero { return Tagged<To, Cardinal>(_unchecked: .zero) }
        guard polarity != .negative else { throw .negativeFactor }
        let scaled: UInt128
        do { scaled = try value.applying(to: UInt128(count.underlying.rawValue)) }
        catch { throw Error(error) }
        guard let result = UInt(exactly: scaled) else { throw .overflow }
        return Tagged<To, Cardinal>(_unchecked: Cardinal(result))
    }

    public func applying<Input: Carrier.`Protocol`>(
        to offset: Input
    ) throws(Error) -> Tagged<To, Difference>
    where Input.Domain == From, Input.Underlying == Difference {
        let unsigned = UInt128(offset.underlying.magnitude.value.rawValue)
        let input = offset.underlying.polarity == .negative ? -Int128(unsigned) : Int128(unsigned)
        let scaled = try applying(to: input)
        guard let magnitude = UInt(exactly: scaled.magnitude) else { throw .overflow }
        return Tagged<To, Difference>(_unchecked: Difference(
            polarity: scaled < 0 ? .negative : .positive,
            magnitude: Difference.Magnitude(Cardinal(magnitude))
        ))
    }

    public func quotientAndRemainder(
        dividing count: Tagged<To, Cardinal>
    ) throws(Error) -> (quotient: Tagged<From, Cardinal>, remainder: Tagged<To, Cardinal>) {
        guard polarity != nil else { throw .zeroFactor }
        guard polarity == .positive else { throw .negativeFactor }
        guard denominator == 1 else { throw .nonintegralFactor }
        let result: (quotient: UInt128, remainder: UInt128)
        do { result = try Division.quotient(UInt128(count.underlying.rawValue), by: numerator) }
        catch { throw .overflow }
        return (
            Tagged<From, Cardinal>(_unchecked: Cardinal(UInt(result.quotient))),
            Tagged<To, Cardinal>(_unchecked: Cardinal(UInt(result.remainder)))
        )
    }
}

extension Property {
    public func exact<
        A: ~Copyable & ~Escapable,
        B: ~Copyable & ~Escapable,
        C: ~Copyable & ~Escapable
    >(by other: Ratio<B, C>) throws(Ratio::Failure) -> Ratio<A, C>
    where Tag == Multiplication, Base == Ratio<A, B> {
        try base.composed(with: other)
    }

    public func exact<
        A: ~Copyable & ~Escapable,
        B: ~Copyable & ~Escapable,
        Input: Carrier.`Protocol`
    >(by count: Input) throws(Ratio::Failure) -> Tagged<B, Cardinal>
    where Tag == Multiplication, Base == Ratio<A, B>, Input.Domain == A, Input.Underlying == Cardinal {
        try base.applying(to: count)
    }

    public func exact<
        A: ~Copyable & ~Escapable,
        B: ~Copyable & ~Escapable,
        Input: Carrier.`Protocol`
    >(by offset: Input) throws(Ratio::Failure) -> Tagged<B, Difference>
    where Tag == Multiplication, Base == Ratio<A, B>, Input.Domain == A, Input.Underlying == Difference {
        try base.applying(to: offset)
    }
}

public func * <A: ~Copyable & ~Escapable, B: ~Copyable & ~Escapable, C: ~Copyable & ~Escapable>(
    lhs: Ratio<A, B>, rhs: Ratio<B, C>
) -> Ratio<A, C> {
    do { return try lhs.composed(with: rhs) }
    catch { preconditionFailure("Ratio overflow in multiplication") }
}

public func * <A: ~Copyable & ~Escapable, B: ~Copyable & ~Escapable, Input: Carrier.`Protocol`>(
    lhs: Ratio<A, B>, rhs: Input
) -> Tagged<B, Cardinal> where Input.Domain == A, Input.Underlying == Cardinal {
    do { return try lhs.applying(to: rhs) }
    catch { preconditionFailure("Invalid Cardinal scaling by Ratio: \(error)") }
}

public func * <A: ~Copyable & ~Escapable, B: ~Copyable & ~Escapable, Input: Carrier.`Protocol`>(
    lhs: Input, rhs: Ratio<A, B>
) -> Tagged<B, Cardinal> where Input.Domain == A, Input.Underlying == Cardinal {
    rhs * lhs
}
