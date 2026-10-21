@_exported public import Cardinal
@_exported public import Carrier
import Magnitude
@_exported public import Polarity
@_exported public import Property
import Rational
@_exported public import Tagged

extension Ratio: Swift::ExpressibleByIntegerLiteral where From == To {
    @_disfavoredOverload
    public init(integerLiteral value: Int) { self.init(value) }
}
