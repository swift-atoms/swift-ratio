#if Bit
import Bit
import Cardinal
import Difference
import Index
import Ordinal
import Tagged
import Magnitude
import Rational
import Ratio
import Ratio_Test_Support
import Testing

private func bitCount(_ rawValue: UInt) -> Tagged<Bit, Cardinal> {
    Tagged(_unchecked: Cardinal(rawValue))
}

private func bitIndex(_ rawValue: UInt) -> Index<Bit> {
    Index<Bit>(_unchecked: Ordinal(rawValue))
}

private func bitOffset(_ rawValue: Int) -> Tagged<Bit, Difference> {
    Tagged(_unchecked: Difference(rawValue))
}

private func wordIndex<Word>(_ rawValue: UInt) -> Index<Word> {
    Index(_unchecked: Ordinal(rawValue))
}

@Suite
struct `Bit.Pack.Location Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
    @Suite(.serialized) struct Performance {}
}

extension `Bit.Pack.Location Tests`.Unit {
    @Test
    func `init from word, bit, and mask components`() {
        let word: Index<UInt64> = wordIndex(5)
        let bit = bitOffset(3)
        let mask: UInt64 = 1 << 3

        let location = Bit.Pack<UInt64>.Location(word: word, bit: bit, mask: mask)

        #expect(location.word.underlying.rawValue == 5)
        #expect(location.bit.underlying.magnitude.value.rawValue == 3)
        #expect(location.mask == mask)
    }

    @Test
    func `init from word and bit computes mask`() {
        let word: Index<UInt64> = wordIndex(0)
        let bit = bitOffset(7)

        let location = Bit.Pack<UInt64>.Location(word: word, bit: bit)

        #expect(location.word.underlying.rawValue == 0)
        #expect(location.bit.underlying.magnitude.value.rawValue == 7)
        #expect(location.mask == UInt64(1) << 7)
    }

    @Test
    func `mask computation for bit 0`() {
        let word: Index<UInt64> = wordIndex(0)
        let bit = bitOffset(0)

        let location = Bit.Pack<UInt64>.Location(word: word, bit: bit)

        #expect(location.mask == 1)
    }

    @Test
    func `mask computation for various bit positions`() {
        (0..<64).forEach { bitPosition in
            let word: Index<UInt64> = wordIndex(0)
            let bit = bitOffset(bitPosition)

            let location = Bit.Pack<UInt64>.Location(word: word, bit: bit)

            #expect(location.mask == UInt64(1) << bitPosition)
        }
    }

    @Test
    func `init from typed bit index`() {

        let bitIndex = bitIndex(70)
        let location = Bit.Pack<UInt64>.Location(index: bitIndex, bitsPerWord: .bitWidth)

        #expect(location.word.underlying.rawValue == 1)
        #expect(location.bit.underlying.magnitude.value.rawValue == 6)
        #expect(location.mask == UInt64(1) << 6)
    }

    @Test
    func `init from typed bit count`() {

        let count = bitCount(70)
        let location = Bit.Pack<UInt64>.Location(count: count, bitsPerWord: .bitWidth)

        #expect(location.word.underlying.rawValue == 1)
        #expect(location.bit.underlying.magnitude.value.rawValue == 6)
        #expect(location.mask == UInt64(1) << 6)
    }

    @Test
    func `location for bit index 0`() {
        let bitIndex = bitIndex(0)
        let location = Bit.Pack<UInt64>.Location(index: bitIndex, bitsPerWord: .bitWidth)

        #expect(location.word.underlying.rawValue == 0)
        #expect(location.bit.underlying.magnitude.value.rawValue == 0)
        #expect(location.mask == 1)
    }

    @Test
    func `location for bit index 63 (last bit of first word)`() {
        let bitIndex = bitIndex(63)
        let location = Bit.Pack<UInt64>.Location(index: bitIndex, bitsPerWord: .bitWidth)

        #expect(location.word.underlying.rawValue == 0)
        #expect(location.bit.underlying.magnitude.value.rawValue == 63)
        #expect(location.mask == UInt64(1) << 63)
    }

    @Test
    func `location for bit index 64 (first bit of second word)`() {
        let bitIndex = bitIndex(64)
        let location = Bit.Pack<UInt64>.Location(index: bitIndex, bitsPerWord: .bitWidth)

        #expect(location.word.underlying.rawValue == 1)
        #expect(location.bit.underlying.magnitude.value.rawValue == 0)
        #expect(location.mask == 1)
    }

    @Test
    func `UInt8 word type - 8 bits per word`() {

        let bitIndex = bitIndex(10)
        let location = Bit.Pack<UInt8>.Location(index: bitIndex, bitsPerWord: .bitWidth)

        #expect(location.word.underlying.rawValue == 1)
        #expect(location.bit.underlying.magnitude.value.rawValue == 2)
        #expect(location.mask == UInt8(1) << 2)
    }

    @Test
    func `UInt32 word type - 32 bits per word`() {

        let bitIndex = bitIndex(35)
        let location = Bit.Pack<UInt32>.Location(index: bitIndex, bitsPerWord: .bitWidth)

        #expect(location.word.underlying.rawValue == 1)
        #expect(location.bit.underlying.magnitude.value.rawValue == 3)
        #expect(location.mask == UInt32(1) << 3)
    }

    @Test
    func `location via Index<Bit> convenience method`() {
        let bitIndex = bitIndex(70)
        let location: Bit.Pack<UInt64>.Location = bitIndex.location(bitsPerWord: .bitWidth)

        #expect(location.word.underlying.rawValue == 1)
        #expect(location.bit.underlying.magnitude.value.rawValue == 6)
        #expect(location.mask == UInt64(1) << 6)
    }
}

extension `Bit.Pack.Location Tests`.`Edge Case` {
    @Test
    func `boundary: bit position 0 in word 0`() {
        let bitIndex = bitIndex(0)
        let location = Bit.Pack<UInt64>.Location(index: bitIndex, bitsPerWord: .bitWidth)

        #expect(location.word.underlying.rawValue == 0)
        #expect(location.bit.underlying.magnitude.value.rawValue == 0)
        #expect(location.mask == 1)
    }

    @Test
    func `boundary: maximum bit position in UInt8 word`() {
        let bitIndex = bitIndex(7)
        let location = Bit.Pack<UInt8>.Location(index: bitIndex, bitsPerWord: .bitWidth)

        #expect(location.word.underlying.rawValue == 0)
        #expect(location.bit.underlying.magnitude.value.rawValue == 7)
        #expect(location.mask == UInt8(1) << 7)
    }

    @Test
    func `boundary: word transition at UInt8 boundary`() {

        let bit7 = bitIndex(7)
        let bit8 = bitIndex(8)

        let loc7 = Bit.Pack<UInt8>.Location(index: bit7, bitsPerWord: .bitWidth)
        let loc8 = Bit.Pack<UInt8>.Location(index: bit8, bitsPerWord: .bitWidth)

        #expect(loc7.word.underlying.rawValue == 0)
        #expect(loc7.bit.underlying.magnitude.value.rawValue == 7)

        #expect(loc8.word.underlying.rawValue == 1)
        #expect(loc8.bit.underlying.magnitude.value.rawValue == 0)
    }

    @Test
    func `large bit index`() {
        let bitIndex = bitIndex(1000)
        let location = Bit.Pack<UInt64>.Location(index: bitIndex, bitsPerWord: .bitWidth)

        #expect(location.word.underlying.rawValue == 15)
        #expect(location.bit.underlying.magnitude.value.rawValue == 40)
        #expect(location.mask == UInt64(1) << 40)
    }
}

#endif
