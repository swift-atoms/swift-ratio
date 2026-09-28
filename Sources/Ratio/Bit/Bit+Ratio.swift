#if Bit
public import Bit
public import Cardinal
public import Difference
public import Index
public import Ordinal
public import Tagged
public import Magnitude
public import Rational

extension Ratio where To == Bit, From: FixedWidthInteger {

    @inlinable
    public static var bitWidth: Self { .init(From.bitWidth) }
}

extension Ratio where From == UInt, To == Bit {

    @inlinable
    public static var bitsPerWord: Self { .bitWidth }
}
#endif
