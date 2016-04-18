//
//  Example.swift
//  SwiftMock
//
//  Created by Matthew Flint on 20/09/2015.
//
//

import Foundation

/// the class we're testing
class Example {
    let collaborator: ExampleCollaborator
    
    init(_ theCollaborator: ExampleCollaborator) {
        collaborator = theCollaborator
    }
    
    func doSomething() {
        // test will fail if this call isn't made
        collaborator.voidFunction()
    }
    
    func doSomethingWithParamters(int: Int, _ string: String) -> String {
        // test will fail if this call isn't made
        return collaborator.function(int, string)
    }
	
    func doSomethingWithDictParameters(dict: Dictionary<String, String>) -> String {
        return collaborator.stringDictFunction(dict)
    }

    func ExpectRejectExpect() {
      collaborator.methodOne()
      collaborator.methodThree()
    }

    func ExpectExpectReject() {
      collaborator.methodOne()
      collaborator.methodTwo()
    }

    func RejectRejectExpect() {
      collaborator.methodThree()
    }

    func ExpectExpectExpect() {
      collaborator.methodOne()
      collaborator.methodTwo()
      collaborator.methodThree()
    }

    func RejectRejectReject() {
      // call nothing
    }

    func RejectExpectExpect() {
      collaborator.methodTwo()
      collaborator.methodThree()
    }

    func RejectExpectReject() {
      collaborator.methodTwo()
    }

    func ExpectRejectReject() {
      collaborator.methodOne()
    }
}

