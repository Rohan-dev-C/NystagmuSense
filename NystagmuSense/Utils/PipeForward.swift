//
//  PipeForward.swift
//  NystagmuSense
//
//  Created by Rohan Sampath on 6/30/25.
//

// Utils/PipeForward.swift
infix operator |> : MultiplicationPrecedence   // declare infix operator

@inlinable
func |> <T, U>(lhs: T, rhs: (T) throws -> U) rethrows -> U {
    try rhs(lhs)
}
