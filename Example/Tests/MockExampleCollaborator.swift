//
//  MockExampleCollaborator.swift
//  SwiftMock
//
//  Created by Matthew Flint on 20/09/2015.
//
//

import Foundation
import XCTest
import SwiftMock

@testable import SwiftMock_Example

/// the mock ExampleCollaborator
/// this would exist in your test target
class MockExampleCollaborator: ExampleCollaborator, Mock {
    let callHandler: MockCallHandler
    
    init(testCase: XCTestCase) {
        callHandler = MockCallHandlerImpl(testCase)
    }
    
    override func voidFunction() {
      callHandler.accept(nil, functionName: #function, args: nil)
    }
    
    override func function(int: Int, _ string: String) -> String {
      return callHandler.accept("", functionName: #function, args: int, string) as! String
    }
	
    override func stringDictFunction(dict: Dictionary<String, String>) -> String {
      return callHandler.accept("", functionName: #function, args: dict) as! String
    }

    override func methodOne() {
      callHandler.accept(nil, functionName: #function, args: nil)
    }

    override func methodTwo() {
      callHandler.accept(nil, functionName: #function, args: nil)
    }

    override func methodThree() {
      callHandler.accept(nil, functionName: #function, args: nil)
    }
}
