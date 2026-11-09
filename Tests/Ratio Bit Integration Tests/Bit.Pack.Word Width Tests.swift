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

    enum `Bit.Pack.Word Width Tests` {}

    extension `Bit.Pack.Word Width Tests` {
        @Suite
        struct `Bits per word is bounded by the word's width` {
            @Test
            func `A pack fills words to their full width`() {
                let count = Tagged<Bit, Cardinal>(_unchecked: Cardinal(UInt(9)))
                let pack = Bit.Pack<UInt8>(count: count, bitsPerWord: .bitWidth)

                #expect(pack.words.count.underlying.rawValue == 2)
                #expect(pack.bits.unused.underlying.rawValue == 7)
            }

            @Test
            func `A location at the last bit of a word sets the word's top bit`() {
                let location = Bit.Pack<UInt8>.Location(
                    index: Index<Bit>(_unchecked: Ordinal(UInt(15))),
                    bitsPerWord: .bitWidth
                )

                #expect(location.word.underlying.rawValue == 1)
                #expect(location.mask == 0x80)
                #expect(location.index(bitsPerWord: .bitWidth).underlying.rawValue == 15)
            }

            @Test
            func `A pack refuses more bits per word than the word holds`() async {
                await #expect(processExitsWith: .failure) {
                    let count = Tagged<Bit, Cardinal>(_unchecked: Cardinal(UInt(1)))
                    _ = Bit.Pack<UInt8>(count: count, bitsPerWord: Ratio<UInt8, Bit>(9 as Int))
                }
            }

            @Test
            func `A location refuses more bits per word than the word holds`() async {
                await #expect(processExitsWith: .failure) {
                    _ = Bit.Pack<UInt8>.Location(
                        index: Index<Bit>(_unchecked: Ordinal(UInt(8))),
                        bitsPerWord: Ratio<UInt8, Bit>(9 as Int)
                    )
                }
            }

            @Test
            func `A location refuses a bit offset past the word's width`() async {
                await #expect(processExitsWith: .failure) {
                    _ = Bit.Pack<UInt8>.Location(
                        word: Index<UInt8>(_unchecked: .zero),
                        bit: Tagged<Bit, Difference>(_unchecked: Difference(8))
                    )
                }
            }

            @Test
            func `Reconstructing an index refuses more bits per word than the word holds`() async {
                await #expect(processExitsWith: .failure) {
                    let location = Bit.Pack<UInt8>.Location(
                        word: Index<UInt8>(_unchecked: Ordinal(UInt(1))),
                        bit: Tagged<Bit, Difference>(_unchecked: .zero)
                    )
                    _ = location.index(bitsPerWord: Ratio<UInt8, Bit>(9 as Int))
                }
            }
        }
    }

#endif
