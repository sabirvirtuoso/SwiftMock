//
//  Mock.swift
//  SwiftMock
//
//  Created by Matthew Flint on 13/09/2015.
//
//

/*
This protocol, and its extension, acts as a proxy to the real workhorse, MockCallHandler. It's here to reduce the amount of boiler-plate code when creating mock objects
*/

public protocol Mock {
    var callHandler: MockCallHandler { get }
    
    func expect(file: String, _ line: UInt) -> MockExpectation
    func stub(file: String, _ line: UInt) -> MockExpectation
    func reject(file: String, _ line: UInt) -> MockExpectation
    
    func verify(file: String, _ line: UInt)
    
    /// check an optional value with a block
//    func checkOptional<T>(block: (value: T?) -> Bool) -> T?
}

public extension Mock {
    func expect(file: String = #file, _ line: UInt = #line) -> MockExpectation {
        return callHandler.expect(file, line)
    }
    
    func stub(file: String = #file, _ line: UInt = #line) -> MockExpectation {
        return callHandler.stub(file, line)
    }

    func reject(file: String = #file, _ line: UInt = #line) -> MockExpectation {
        return callHandler.reject(file, line)
    }

    func verify(file: String = #file, _ line: UInt = #line) {
        callHandler.verify(file, line)
    }
    
//    func checkString(block: (value: String) -> Bool) -> String {
//        return nil
//    }
}