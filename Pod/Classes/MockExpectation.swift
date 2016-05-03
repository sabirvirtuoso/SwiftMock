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
    var expectedArgs = [Any?]()
    var actualArgs = [Any?]()
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

        assertArgumentCountMatch()

        let theActionable = MockActionable(ofExpectation: self, withReturnValue: value)
        actionPerformer = theActionable
        return theActionable
    }
  
    private func assertArgumentCountMatch() {
        if argumentMatcherRequirement.count > 0 && argumentMatcherRequirement.count != expectedArgs.count {
          fatalError("There is a mismatch between number of expected arguments and its corresponding matcher requirement")
        }
    }
    
    /// record the function name and arguments during the expectation-setting phase
    public func acceptExpected(functionName theFunctionName: String, args theArgs: [Any?]?) -> Bool {
        // do we already have a function? if so, we can't accept this call as an expectation
        let result = functionName == nil
        if result {
            functionName = theFunctionName
            expectedArgs = theArgs ?? []
        }

        return result
    }
    
    public func isComplete() -> Bool {
        return functionName != nil
    }
    
    public func satisfy(functionName theFunctionName: String) -> Bool {
        return functionName == theFunctionName
    }

    /// offer this function, and its arguments, to the expectation to see if it matches
    public func satisfy(args theArgs: [Any?]?) -> Bool {
        let matcher = MockMatcher()
        var expectedArgsToMatch = [Any?]()
        var actualArgsToMatch = [Any?]()

        actualArgs = theArgs ?? []

        guard !argumentMatcherRequirement.isEmpty else {
          return matcher.match(expectedArgs, actualArgs)
        }

        for (index, matchArg) in argumentMatcherRequirement.enumerate() {
          if matchArg {
            expectedArgsToMatch.append(expectedArgs[index])
            actualArgsToMatch.append(actualArgs[index])
          }
        }

        return matcher.match(expectedArgsToMatch, actualArgsToMatch)
    }
    
    /// perform actions, and return a value from the mock
    public func performActions() -> Any? {
        return actionPerformer.performActions()
    }
}

public class MockRejection: MockExpectation {

  let failer: MockFailer
  let file: String
  let line: UInt
  private var rejectCalled = false

  public init(failer: MockFailer, file: String, _ line: UInt) {
    self.failer = failer
    self.file = file
    self.line = line
  }

  public func called(rejectCalled: Bool) {
    self.rejectCalled = rejectCalled
  }
    
  public func isCalled() -> Bool {
    return rejectCalled
  }
  
  private override func assertArgumentCountMatch() {
    // do nothing
  }

}