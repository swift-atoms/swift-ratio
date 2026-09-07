internal import Rational

extension Ratio where From: ~Copyable & ~Escapable, To: ~Copyable & ~Escapable {
    public enum Error: Swift.Error, Hashable, Sendable {
        case denominator
        case zeroFactor
        case negativeFactor
        case nonintegralFactor
        case overflow
        case inexact
        case unrepresentable
    }
}

extension Ratio.Error where From: ~Copyable & ~Escapable, To: ~Copyable & ~Escapable {
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
