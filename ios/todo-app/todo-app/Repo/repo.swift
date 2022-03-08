//
//  alamofireApi.swift
//  todo-app
//
//  Created by Nicholas Chase on 3/2/22.
//

import Foundation
import Alamofire

struct Nothing: Codable {
    
}

protocol TodoRepo {
    func getTodos() async -> Todo
    func getTodosWithFilters() async -> Todo
    func createTodo(newTodo: NewTodo) async
    func delTodo(todoUUID: UUID)   async
    func updateTodo(todoUUID: UUID) async
    func getAtodo(todoUUID: UUID) async
}

let localHost = "http://localhost:5000"

class TodoApiCalls {
    func getTodos() async -> [Todo] {
        let req = AF.request("\(localHost)/task", method: .get, parameters: nil)
        let todos = try! await req.serializingDecodable([Todo].self).value
        print(todos)
        return todos
    }
    
    func getTodosWithFilters(isComplete: Bool, isIncomplete: Bool) async -> [Todo] {
        
        let req = AF.request("\(localHost)/task", method: .get, parameters: nil)
        let todos = try! await req.serializingDecodable([Todo].self).value
        
        if isComplete {
            let req = AF.request("\(localHost)/task/complete", method: .get, parameters: nil)
            let todos = try! await req.serializingDecodable([Todo].self).value
            return todos
        }
        if isIncomplete {
            let req = AF.request("\(localHost)/task/incomplete", method: .get, parameters: nil)
            let todos = try! await req.serializingDecodable([Todo].self).value
            return todos
        }
        print("This is incomplete")
        print(isIncomplete)
        return todos
        
    }
    
    func createTodo(_ newTodo:NewTodo) async {
        let req = AF.request("\(localHost)/task", method: .post, parameters: newTodo, encoder: JSONParameterEncoder.default)
        _ = try! await req.serializingDecodable(Nothing.self, emptyResponseCodes: [201,204,205]).value
    }
    
    func delTodo(todoUUID: UUID) async {
       let strUUID = String(describing: todoUUID)
       let req = AF.request("\(localHost)/task/\(strUUID)", method: .delete, parameters: nil, headers: nil)
        _ = try! await req.serializingDecodable(Nothing.self, emptyResponseCodes: [201,204,205]).value
        
    }
    
    func updateTodo(todoUUID: UUID, updateTodo: String, updateDueDate: String) async {
        
        let params: Parameters = [
                "todo": updateTodo,
                "dueDate": updateDueDate,
            ]
        let strUUID = String(describing: todoUUID)

        let req = AF.request("\(localHost)/task/\(strUUID)", method: .put, parameters: params, headers: nil)
        _ = try! await req.serializingDecodable(Nothing.self, emptyResponseCodes: [201,204,205]).value
        
    }
    
    func getAtodo(todoUUID: UUID) async {
        print("This is the uuid ")
        print(todoUUID)
        let strUUID = String(describing: todoUUID)
        let req = AF.request("\(localHost)/task/\(strUUID)", method: .get, parameters: nil)
        let todos = try! await req.serializingDecodable([Todo].self).value
        print(todos)
    }
    
    func updateCompleteTodo(todoUUID: UUID, updateDueDate: String) async {
        let params: Parameters = [
            "dueDate": updateDueDate,
            "completed": true,
        ]
        let strUUID = String(describing: todoUUID)
        let req = AF.request("\(localHost)/task/\(strUUID)", method: .put, parameters: params, headers: nil)
        _ = try! await req.serializingDecodable(Nothing.self).value
        
    }
    
    
    func updateStatus(todoUUID: UUID) async {
        let params: Parameters = [
            "completed": true,
        ]
        let strUUID = String(describing: todoUUID)
        let req = AF.request("\(localHost)/task/statusComplete/\(strUUID)", method: .put, parameters: params, headers: nil)
        _ = try! await req.serializingDecodable(Nothing.self, emptyResponseCodes: [201,204,205]).value
    }
    
}
