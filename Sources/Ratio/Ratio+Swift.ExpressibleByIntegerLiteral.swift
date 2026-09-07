public import Magnitude
public import Rational
@_exported public import Cardinal
@_exported public import Carrier
@_exported public import Polarity
@_exported public import Property
@_exported public import Tagged

extension Ratio: Swift.ExpressibleByIntegerLiteral where From == To {
    @_disfavoredOverload
    public init(integerLiteral value: Int) { self.init(value) }
}
