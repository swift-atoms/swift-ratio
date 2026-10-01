#if Bit
public import Bit
import Cardinal
import Difference
import Index
import Ordinal
import Tagged
import Magnitude
import Rational

extension Ratio where To == Bit, From: FixedWidthInteger {

    @inlinable
    public static var bitWidth: Self { .init(From.bitWidth) }
}

extension Ratio where From == UInt, To == Bit {

    @inlinable
    public static var bitsPerWord: Self { .bitWidth }
}
#endif
