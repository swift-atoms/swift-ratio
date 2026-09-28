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

extension Bit {

    public struct Pack<Word: FixedWidthInteger & UnsignedInteger & Sendable>: Sendable {

        public let words: Words

        public let bits: Bits

        @inlinable
        public init(
            count: Tagged<Bit, Cardinal>,
            bitsPerWord: Ratio<Word, Bit>
        ) {

            let (wordCount, remainingBits) = try! bitsPerWord.quotientAndRemainder(dividing: count)
            let hasPartialWord = remainingBits.underlying.rawValue > 0
            let roundedWordCount: Tagged<Word, Cardinal>
            if hasPartialWord {
                let (next, overflow) = wordCount.underlying.rawValue
                    .addingReportingOverflow(1)
                precondition(!overflow)
                roundedWordCount = Tagged<Word, Cardinal>(
                    _unchecked: Cardinal(next)
                )
            } else {
                roundedWordCount = wordCount
            }
            self.words = Words(count: roundedWordCount)
            let bitsPerWordCount = Tagged<Bit, Cardinal>(
                _unchecked: Cardinal(try! bitsPerWord.value.integer(as: UInt.self))
            )
            self.bits = Bits(
                unused: hasPartialWord
                    ? Tagged<Bit, Cardinal>(
                        _unchecked: Cardinal(
                            bitsPerWordCount.underlying.rawValue
                                - remainingBits.underlying.rawValue
                        )
                    )
                    : Tagged<Bit, Cardinal>(_unchecked: Cardinal(UInt(0)))
            )
        }
    }
}

extension Bit.Pack {

    @inlinable
    public static var bitWidth: Tagged<Bit, Cardinal> {
        Tagged<Bit, Cardinal>(_unchecked: Cardinal(UInt(Word.bitWidth)))
    }
}
#endif
