#if Difference
@_exported public import Carrier
@_exported public import Difference
@_exported public import Property
@_exported public import Tagged


@inlinable
public func * <
    A: ~Copyable & ~Escapable,
    B: ~Copyable & ~Escapable,
    Input: Carrier.`Protocol`
>(
    lhs: Ratio<A, B>, rhs: Input
) -> Tagged<B, Difference>
where Input.Domain == A, Input.Underlying == Difference {
    do { return try lhs.applying(to: rhs) }
    catch { preconditionFailure("Difference overflow in Ratio scaling") }
}

@inlinable
public func * <
    A: ~Copyable & ~Escapable,
    B: ~Copyable & ~Escapable,
    Input: Carrier.`Protocol`
>(
    lhs: Input, rhs: Ratio<A, B>
) -> Tagged<B, Difference>
where Input.Domain == A, Input.Underlying == Difference {
    rhs * lhs
}
#endif
