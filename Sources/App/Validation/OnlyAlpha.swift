//
//  OnlyAlpha.swift
//  FriendService
//
//  Created by Jussi Suojanen on 05/09/2017.
//
//
import Validation

private let scandicAlphaCharacters = "abcdefghijklmnopqrstuvwxyzåäö"
private let validCharacters = scandicAlphaCharacters.characters

/// A validator that can be used to check that a
/// given string contains only alphanumeric characters
public struct OnlyScandicAlpha: Validator {
    public init() {}
    /**
     Validate whether or not an input string contains only
     alphanumeric characters. a...zåäö

     - parameter value: input value to validate

     - throws: an error if validation fails
     */
    public func validate(_ input: String) throws {
        let passed = input
            .lowercased()
            .characters
            .filter(validCharacters.contains)
            .count

        if passed != input.characters.count {
            throw error("\(input) does not contain only alpha characters")
        }
    }
}
