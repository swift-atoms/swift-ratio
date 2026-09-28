#if Memory
import Memory
import Ratio
import Testing

private struct Padded {
    let byte: UInt8
    let word: UInt32
}

@Test func `stride uses the source memory layout`() {
    let integer: Ratio<UInt32, Memory> = .stride
    let padded: Ratio<Padded, Memory> = .stride
    #expect(integer == .init(MemoryLayout<UInt32>.stride))
    #expect(padded == .init(MemoryLayout<Padded>.stride))
}

#endif
