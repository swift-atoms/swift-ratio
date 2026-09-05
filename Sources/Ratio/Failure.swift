internal import Rational

/// A conversion failure independent of its source and destination domains.
public enum Failure: Swift.Error, Hashable, Sendable {
    case denominator
    case zeroFactor
    case negativeFactor
    case nonintegralFactor
    case overflow
    case inexact
    case unrepresentable
}

extension Failure {
    internal init(_ error: Rational.Error) {
        switch error {
        case .denominator: self = .denominator
        case .zero: self = .zeroFactor
        case .overflow: self = .overflow
        case .inexact: self = .inexact
        case .unrepresentable: self = .unrepresentable
        }
    }
}
