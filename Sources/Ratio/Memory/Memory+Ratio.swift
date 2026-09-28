#if Memory
@_exported public import Memory

extension Ratio where From: ~Copyable & ~Escapable, To == Memory {

    @inlinable
    public static var stride: Self {
        .init(MemoryLayout<From>.stride)
    }
}
#endif
