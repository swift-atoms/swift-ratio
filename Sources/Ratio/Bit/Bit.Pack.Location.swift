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

public import struct Ordinal.Ordinal
public import struct Tagged.Tagged

extension Bit.Pack {

    public struct Location: Sendable {

        public let word: Index<Word>

        public let bit: Tagged<Bit, Difference>

        public let mask: Word

        @inlinable
        public init(
            word: Index<Word>,
            bit: Tagged<Bit, Difference>,
            mask: Word
        ) {
            self.word = word
            self.bit = bit
            self.mask = mask
        }

        @inlinable
        public init(
            word: Index<Word>,
            bit: Tagged<Bit, Difference>
        ) {
            self.word = word
            self.bit = bit
            precondition(bit.underlying.polarity != .negative)
            self.mask = Word(1) << bit.underlying.magnitude.value.rawValue
        }

        @inlinable
        public init(
            index: Index<Bit>,
            bitsPerWord: Ratio<Word, Bit>
        ) {

            let (wordIndex, bitOffset) = try! bitsPerWord.quotientAndRemainder(dividing: index)
            self.word = wordIndex
            self.bit = bitOffset
            self.mask = Word(1) << bitOffset.underlying.magnitude.value.rawValue
        }

        @inlinable
        public init(
            count: Tagged<Bit, Cardinal>,
            bitsPerWord: Ratio<Word, Bit>
        ) {
            self.init(
                index: Index<Bit>(
                    _unchecked: Ordinal(count.underlying.rawValue)
                ),
                bitsPerWord: bitsPerWord
            )
        }
    }
}

extension Bit.Pack.Location {

    @inlinable
    public func index(
        bitsPerWord: Ratio<Word, Bit>
    ) -> Index<Bit> {
        precondition(bitsPerWord.polarity == .positive)
        precondition(bit.underlying.polarity != .negative)
        let (precedingBits, multiplicationOverflow) = word.underlying.rawValue
            .multipliedReportingOverflow(by: try! bitsPerWord.value.integer(as: UInt.self))
        precondition(!multiplicationOverflow)
        let (absolute, additionOverflow) = precedingBits.addingReportingOverflow(
            bit.underlying.magnitude.value.rawValue
        )
        precondition(!additionOverflow)
        return Index<Bit>(_unchecked: Ordinal(absolute))
    }
}
#endif
