#if Ordinal
@_exported public import Cardinal
@_exported public import Carrier
@_exported public import Difference
public import Magnitude
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
