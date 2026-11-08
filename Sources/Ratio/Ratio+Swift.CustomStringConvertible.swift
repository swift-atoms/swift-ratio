@_exported public import Cardinal
@_exported public import Carrier
import Magnitude
@_exported public import Polarity
@_exported public import Property
import Rational
@_exported public import Tagged

extension Ratio: Swift::CustomStringConvertible {
    public var description: String { "Ratio<\(From.self), \(To.self)>(\(value))" }
}
