//
//  MockExpectation.swift
//  SwiftMock
//
//  Created by Matthew Flint on 13/09/2015.
//
//

import Foundation

public class MockExpectation {
    /// calls will be matched against this functionName and arguments array
    public var functionName: String?
    var args = [Any?]()
    var argumentMatcherRequirement =  [Bool]()

    /// the actionable object holds actions for this expectation, and can perform them
    var actionPerformer: MockActionPerformer!
    
    public init() {
    }
    
    /// this call makes a MockActionable<T>, where T is the return value of the funciton being mocked. The returned object is resonsible for making and performing Actions when the expectation is satisfied. Every subsequent call to "andDo", "andReturn", etc is a separate Action.
    public func call<T: Any>(value: T, withArgumentMatcherRequirement: [Bool]? = nil) -> MockActionable<T> {
        if let _ = withArgumentMatcherRequirement {
          argumentMatcherRequirement = withArgumentMatcherRequirement!
        }

        let theActionable = MockActionable(value)
        actionPerformer = theActionable
        return theActionable
    }
    
    /// record the function name and arguments during the expectation-setting phase
    public func acceptExpected(functionName theFunctionName: String, args theArgs: Any?...) -> Bool {
        // do we already have a function? if so, we can't accept this call as an expectation
        let result = functionName == nil
        if result {
            functionName = theFunctionName
            args = theArgs

            for index in (0..<theArgs.count) {
              argumentMatcherRequirement[index] = true
            }
        }
        return result
    }
    
    public func isComplete() -> Bool {
        return functionName != nil
    }
    
    /// offer this function, and its arguments, to the expectation to see if it matches
    public func satisfy(functionName theFunctionName: String, args theArgs: Any?...) -> Bool {
        let matcher = MockMatcher()
        var expectedArgs = [Any?]()
        var actualArgs = [Any?]()

        for (index, matchArg) in argumentMatcherRequirement.enumerate() {
          if matchArg {
            expectedArgs.append(args[index])
            actualArgs.append(theArgs[index])
          }
        }

        return functionName == theFunctionName && matcher.match(expectedArgs, actualArgs)
    }
    
    /// perform actions, and return a value from the mock
    public func performActions() -> Any? {
        return actionPerformer.performActions()
    }
    
}