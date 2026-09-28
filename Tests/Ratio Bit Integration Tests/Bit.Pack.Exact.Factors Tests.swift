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
import Testing

@Suite
struct `Bit packing preserves exact unsigned factors` {
    @Test
    func `Packing preserves unused bits above the signed integer maximum`() throws {
        let factor = try Ratio<UInt, Bit>(numerator: UInt128(UInt.max))
        let count = Tagged<Bit, Cardinal>(_unchecked: Cardinal(UInt(1)))
        let pack = Bit.Pack<UInt>(count: count, bitsPerWord: factor)

        #expect(pack.words.count.underlying.rawValue == 1)
        #expect(pack.bits.unused.underlying.rawValue == UInt.max - 1)
    }

    @Test
    func `A location reconstructs the maximum unsigned index exactly`() throws {
        let factor = try Ratio<UInt, Bit>(numerator: UInt128(UInt.max))
        let location = Bit.Pack<UInt>.Location(
            word: Index<UInt>(_unchecked: Ordinal(UInt(1))),
            bit: Tagged<Bit, Difference>(_unchecked: .zero)
        )

        #expect(location.index(bitsPerWord: factor).underlying.rawValue == UInt.max)
        #expect(location.mask == 1)
    }
}

#endif
