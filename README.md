# Ratio

`Ratio<From, To>` is a domain-indexed signed integral scaling factor with a
full-width `Magnitude<Cardinal>`. Zero has one signless representation, and exact
composition reports unsigned multiplication overflow.

Cardinal scaling accepts a `Carrier<Cardinal>` whose domain is `From` and returns
`Tagged<To, Cardinal>`. Ordinary multiplication supports both operand orders and
requires a representable nonnegative Cardinal result. A negative factor may scale
zero because the result is canonical zero.

Multiplication uses the shared `Multiplication` operation identity. Ratio conforms
to `Magnitude.Representable`, and its associated and stored magnitude is
`Magnitude<Cardinal>`.

```swift
enum Pixels {}
enum Points {}

let scale = Ratio<Pixels, Points>.positive(Magnitude(Cardinal(2)))
let input = Tagged<Pixels, Cardinal>(_unchecked: Cardinal(3))
let output: Tagged<Points, Cardinal> = try scale.multiply.exact(by: input)
```

Only the arithmetic workspace is active for this design pass. Broader Ratio
generalization and downstream adoption remain deferred.
