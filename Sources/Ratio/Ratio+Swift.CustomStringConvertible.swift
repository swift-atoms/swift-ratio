public import Magnitude
public import Rational
@_exported public import Cardinal
@_exported public import Carrier
@_exported public import Polarity
@_exported public import Property
@_exported public import Tagged

extension Ratio: Swift.CustomStringConvertible {
    public var description: String { "Ratio<\(From.self), \(To.self)>(\(value))" }
}
