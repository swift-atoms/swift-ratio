#if Bit
public import Bit
import Cardinal
import Difference
public import Index
import Ordinal
public import Tagged
import Magnitude
import Rational

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
