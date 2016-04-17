//
//  MockCallHandlerImpl.swift
//  SwiftMock
//
//  Created by Matthew Flint on 13/09/2015.
//
//

import Foundation
import XCTest

public class MockCallHandlerImpl: MockCallHandler {
    // failures are routed through this object
    let failer: MockFailer
    
    // this is the expectation which is currently being configured (if any)
    var expectation: MockExpectation?
    
    // this is the collection of expectations
    var expectations = [MockExpectation]()
    
    public init(_ testCase: XCTestCase) {
        failer = MockFailerImpl(testCase)
    }
    
    public init(_ theFailer: MockFailer) {
        failer = theFailer
    }
    
    public func expect(file: String, _ line: UInt) -> MockExpectation {
        let newExpectation = MockExpectation()
        
        addExpectation(newExpectation, file: file, line)
        
        // this return value will never be nil, but it might be useless. But returning a useless object is better than forcing tests to constantly unwrap. The test should fail anyway.
        return newExpectation
    }

    private func addExpectation(expectation: MockExpectation, file: String, _ line: UInt) {
        if expectationsComplete(file, line) {
          // make new expectation, and store it
          self.expectation = expectation
          // and add to the array
          expectations.append(expectation)
        }
    }

    func expectationsComplete(file: String, _ line: UInt) -> Bool {
        var expectationsComplete = true

        guard expectation != nil && !isRejection(expectation!) else {
          return expectationsComplete
        }

        // check that any previous expectation is complete, before starting the next
        if !expectation!.isComplete() {
              failer.doFail("Previous expectation was started but not completed", file: file, line: line)
              expectationsComplete = false
        }

        return expectationsComplete
    }

    private func isRejection(expectation: MockExpectation) -> Bool {
        return expectation is MockRejection
    }
    
    public func reject(file: String, _ line: UInt) -> MockExpectation {
        let newExpectation = MockRejection(failer: failer, file: file, line)

        addExpectation(newExpectation, file: file, line)

        return newExpectation
    }
    
    public func stub(file: String, _ line: UInt) -> MockExpectation {
        return expect(file, line)
    }
    
    public func verify(file: String, _ line: UInt) {
        if expectationsComplete(file, line) && expectations.count > 0 {
            for expectation in expectations {
              let functionName = expectation.functionName!

              guard isRejection(expectation) else {
                failer.doFail("Expected call to '\(functionName)' not received", file: file, line: line)

                continue
              }

              if (expectation as! MockRejection).rejectCalled {
                failer.doFail("Unexpected call to '\(functionName)' received", file: file, line: line)
              }
            }
        }
    }
    
    public func checkOptional<T>(block: (value: T?) -> Bool) -> T? {
        return nil
    }
    
    public func accept(expectationReturnValue: Any?, functionName: String, args: Any?...) -> Any? {
        var returnValue = expectationReturnValue
        var expectationRegistered = false
        
        if let currentExpectation = expectation {
            // there's an expectation in progress - is it waiting for the function details?
            expectationRegistered = currentExpectation.acceptExpected(functionName:functionName, args: args)
        }
        
        if !expectationRegistered {
            // OK, this wasn't a call to set up function expectations, so it's a real call
            var matchedExpectationIndex: Int?

            for index in (0..<expectations.count) {
                    if expectations[index].satisfy(functionName:functionName, args: args) {
                      matchedExpectationIndex = index

                      break
                    }
            }

            if let index = matchedExpectationIndex {
                // it was expected
                returnValue = expectationMatched(index)
            } else {
                // whoopsie, unexpected
                failer.doFail("Unexpected call to '\(functionName)' received", file: "", line: 0)
            }
        }
        
        return returnValue
    }
    
    func expectationMatched(index: Int) -> Any? {
        // get the expectation
        let expectation = expectations[index]

        if expectation is MockRejection {
          return nil
        }

        // ... if not rejection then remove it
        expectations.removeAtIndex(index)


        // perform any actions on that expectation
        return expectation.performActions()
    }
}