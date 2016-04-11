//
//  MockActionable.swift
//  Pods
//
//  Created by Matthew Flint on 16/09/2015.
//
//

import Foundation

/*
This class can make and perform actions associated with an expectation
*/

public class MockActionable<T>: MockActionPerformer {
    /// this is the list of MockAction to perform
    var actions = [MockAction<T>]()

    /// this is the expectation to which this MockActionPeformer belongs
    weak var expectation: MockExpectation!

    /// this is the dummy return value, used to keep the compiler happy
    let dummyReturnValue: T

    init(ofExpectation expectation: MockExpectation, withReturnValue value: T) {
        self.expectation = expectation
        dummyReturnValue = value
    }

    public func andReturn(value: T) -> MockActionable<T> {
        return andReturnValue({ () -> T in
            return value
        })
    }
    
    public func andReturnValue(closure: () -> T) -> MockActionable<T> {
        let action = MockAction(closure, providesReturnValue: true)
        addAction(action)
        return self
    }
    
    public func andDo(closure: (args: Any?...) -> Void) -> MockActionable<T> {
        let action = MockAction({
            [unowned self] () -> T in

            closure(args: self.expectation.actualArgs)

            return self.dummyReturnValue
        })
        addAction(action)
        return self
    }
    
    func addAction(action: MockAction<T>) {
        actions.append(action);
    }
    
    func performActions() -> Any? {
        var returnValue: Any?
        
        for action in actions {
            if action.providesReturnValue() {
                returnValue = action.performAction()
            } else {
                action.performAction()
            }
        }
        
        return returnValue
    }
}
