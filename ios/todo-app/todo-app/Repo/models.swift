//
//  Contract.swift
//  todo-app
//
//  Created by Nicholas Chase on 3/2/22.
//

import Foundation

// Model
struct Todo: Codable, Identifiable{
    var uuid = UUID()
    var todo: String
    var dueDate: String
    var createdDate:  String
    let completed: Bool
    
    
    var id: UUID {
        return self.uuid
    }
}

struct NewTodo: Codable {
    var todo:String
    var dueDate:String
    var completed:Bool
}
