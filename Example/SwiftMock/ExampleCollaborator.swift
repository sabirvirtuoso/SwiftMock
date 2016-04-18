//
//  ExampleCollaborator.swift
//  SwiftMock
//
//  Created by Matthew Flint on 20/09/2015.
//
//

import Foundation

/// collaborator class - this one will be mocked
class ExampleCollaborator {
    func voidFunction() {
        
    }
    
    func function(int: Int, _ string: String) -> String {
        return ""
    }
	
    func stringDictFunction(dict : [String: String]) -> String{
        return ""
    }

    func methodOne() {
      print("Method One invoked")
    }

    func methodTwo() {
      print("Method Two invoked")
    }

    func methodThree() {
      print("Method Three invoked")
    }
}
