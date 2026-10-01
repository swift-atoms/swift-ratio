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

    public struct Bits: Sendable {

        public let unused: Tagged<Bit, Cardinal>

        @inlinable
        public init(unused: Tagged<Bit, Cardinal>) {
            self.unused = unused
        }
    }
}
#endif
