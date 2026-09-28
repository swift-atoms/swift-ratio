#if Bit
public import Bit
public import Cardinal
public import Difference
public import Index
public import Ordinal
public import Tagged
public import Magnitude
public import Rational
public import struct Cardinal.Cardinal
public import struct Tagged.Tagged

extension Bit.Pack {

    public struct Words: Sendable {

        public let count: Tagged<Word, Cardinal>

        @inlinable
        public init(count: Tagged<Word, Cardinal>) {
            self.count = count
        }
    }
}
#endif
