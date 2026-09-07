import Cardinal
import Ratio
import Tagged
import Testing

@Suite
struct `Ratio errors belong to their conversion domains` {
    private final class Source {}
    private final class Destination {}

    private func scale<From: ~Copyable & ~Escapable, To: ~Copyable & ~Escapable>(
        _ count: Tagged<From, Cardinal>,
        by ratio: Ratio<From, To>
    ) throws(Ratio<From, To>.Error) -> Tagged<To, Cardinal> {
        try ratio.multiply.exact(by: count)
    }

    @Test
    func `generic scaling preserves its typed domain error`() {
        let ratio = Ratio<Source, Destination>(Int(2))
        let count = Tagged<Source, Cardinal>(_unchecked: .max)
        #expect(throws: Ratio<Source, Destination>.Error.overflow) {
            try scale(count, by: ratio)
        }
        #expect(count.underlying == .max)
    }

    @Test
    func `zero denominators fail in the declared ratio domain`() {
        #expect(throws: Ratio<Source, Destination>.Error.denominator) {
            try Ratio<Source, Destination>(numerator: 1, denominator: 0)
        }
    }

    @Test
    func `conversion errors cross tasks without requiring sendable domain tags`() async {
        typealias Conversion = Ratio<Source, Destination>
        let error = await Task.detached { () -> Conversion.Error? in
            do throws(Conversion.Error) {
                _ = try Conversion(Int(2)).applying(
                    to: Tagged<Source, Cardinal>(_unchecked: .max)
                )
                return nil
            } catch {
                return error
            }
        }.value
        #expect(error == .overflow)
        #expect(Set<Conversion.Error>([.overflow, .inexact, .overflow]).count == 2)
        #expect(
            ObjectIdentifier(Conversion.Error.self)
                != ObjectIdentifier(Ratio<Destination, Source>.Error.self)
        )
    }
}
