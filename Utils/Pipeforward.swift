@inlinable
prefix func |> <T, U>(lhs: T, rhs: (T) throws -> U) rethrows -> U {
    try rhs(lhs)
}