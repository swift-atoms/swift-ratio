#if Bit
public import Bit
public import Cardinal
public import Difference
public import Index
public import Ordinal
public import Tagged
public import Magnitude
public import Rational

extension Index<Bit> {

    @inlinable
    public func location<Word: FixedWidthInteger & UnsignedInteger & Sendable>(
        bitsPerWord: Ratio<Word, Bit>
    ) -> Bit.Pack<Word>.Location {
        Bit.Pack<Word>.Location(
            index: self,
            bitsPerWord: bitsPerWord
        )
    }
}
#endif
