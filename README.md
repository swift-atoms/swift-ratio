# Ratio

`Ratio<From, To>` is an exact rational conversion between two domains. It stores
`Rational`, with a reduced UInt128 numerator and positive denominator. Its
magnitude is `Magnitude<Rational>`, and zero has no polarity.

```swift
import Rational
import Ratio
import Tagged

enum Minute {}
enum Second {}

let seconds = try Ratio<Minute, Second>(numerator: 60)
let minutes = try seconds.inverted()
let input = Tagged<Second, Rational>(_unchecked: Rational(-1))
let output: Tagged<Minute, Rational> = try minutes.applying(to: input)
// Exactly -1/60 minute.
```

`composed(with:)` requires matching intermediate domains. `applying(to:)` supports
Rational and Int128 values and their domain tags, plus Cardinal and Difference
carriers. Integral application throws `.inexact` when rounding would be required.
Cardinal output must be nonnegative; signed Difference output retains its full
magnitude range.

`quotient(dividing:)` accepts a positive integral ratio and uses Euclidean
division. Its typed Int128 overload returns the quotient in `From` and the
nonnegative remainder in `To`; `-61` divided by a factor of `60` gives `(-2, 59)`.
The Cardinal `quotientAndRemainder(dividing:)` preserves the corresponding count
domains.

`Ratio::Failure` is independent of domain parameters, and every specialization's
`Error` aliases it. Exact multiplication through `multiply.exact(by:)` retains the
shared Multiplication operation vocabulary. Codable validation is delegated to
Rational.

Package manifests use URL dependencies. The arithmetic and calendar-time
workspaces provide local overrides during development.
