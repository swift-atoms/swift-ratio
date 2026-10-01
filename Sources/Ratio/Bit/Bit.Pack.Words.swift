#if Bit
public import Bit
public import Cardinal
import Difference
import Index
import Ordinal
public import Tagged
import Magnitude
import Rational
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
