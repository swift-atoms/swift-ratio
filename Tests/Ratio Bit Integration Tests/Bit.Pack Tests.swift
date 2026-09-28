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

@Suite
struct `Bit.Pack Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
    @Suite(.serialized) struct Performance {}
}

extension `Bit.Pack Tests`.Unit {
    @Test
    func `pack for 0 bits`() {
        let pack = Bit.Pack<UInt64>(count: bitCount(0), bitsPerWord: .bitWidth)

        #expect(pack.words.count.underlying.rawValue == 0)
        #expect(pack.bits.unused.underlying.rawValue == 0)
    }

    @Test
    func `pack for exactly 64 bits`() {
        let pack = Bit.Pack<UInt64>(count: bitCount(64), bitsPerWord: .bitWidth)

        #expect(pack.words.count.underlying.rawValue == 1)
        #expect(pack.bits.unused.underlying.rawValue == 0)
    }

    @Test
    func `pack for 65 bits`() {
        let pack = Bit.Pack<UInt64>(count: bitCount(65), bitsPerWord: .bitWidth)

        #expect(pack.words.count.underlying.rawValue == 2)
        #expect(pack.bits.unused.underlying.rawValue == 63)
    }

    @Test
    func `pack for 100 bits`() {
        let pack = Bit.Pack<UInt64>(count: bitCount(100), bitsPerWord: .bitWidth)

        #expect(pack.words.count.underlying.rawValue == 2)
        #expect(pack.bits.unused.underlying.rawValue == 28)
    }

    @Test
    func `pack for UInt8 words`() {
        let pack = Bit.Pack<UInt8>(count: bitCount(10), bitsPerWord: .bitWidth)

        #expect(pack.words.count.underlying.rawValue == 2)
        #expect(pack.bits.unused.underlying.rawValue == 6)
    }

    @Test
    func `capacity-based init`() {
        let pack = Bit.Pack<UInt64>(count: bitCount(100), bitsPerWord: .bitWidth)

        #expect(pack.words.count.underlying.rawValue == 2)
        #expect(pack.bits.unused.underlying.rawValue == 28)
    }
}

extension `Bit.Pack Tests`.`Edge Case` {
    @Test
    func `pack for 1 bit`() {
        let pack = Bit.Pack<UInt64>(count: bitCount(1), bitsPerWord: .bitWidth)

        #expect(pack.words.count.underlying.rawValue == 1)
        #expect(pack.bits.unused.underlying.rawValue == 63)
    }

    @Test
    func `pack at exact word boundary`() {
        let pack = Bit.Pack<UInt64>(count: bitCount(128), bitsPerWord: .bitWidth)

        #expect(pack.words.count.underlying.rawValue == 2)
        #expect(pack.bits.unused.underlying.rawValue == 0)
    }
}

#endif
