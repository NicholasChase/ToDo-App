////
////  alamofireApi.swift
////  todo-app
////
////  Created by Nicholas Chase on 3/2/22.
////
//
//import Foundation
//import Alamofire
//
//
//struct CatFact: Codable {
//    var fact: String
//    var length: Int
//}
//
//struct Todos: Codable, Identifiable {
//    var uuid = UUID()
//    var todo: String
//    var dueDate: String
//    var createdDate:  String
//    let completed: Bool
//    
//    
//    var id: UUID {
//        return self.uuid
//    }
//}
//
//
//struct NewTodo: Codable {
//    var todo:String
//    var dueDate:String
//    var completed:Bool
//}
//
//struct Nothing: Codable {
//    
//}
//// but first define the contract by making the reposotory contract
//// API Calls to go in the reposotory
//class catApi {
//    func getTasks() async -> [Todos] {
//        let req = AF.request("http://localhost:5000/task", method: .get, parameters: nil)
//        let todos = try! await req.serializingDecodable([Todos].self).value
//        print(todos)
//        return todos
//    }
//    
//    func getFact() async {
//        let req = AF.request("https://catfact.ninja/fact", method: .get, parameters: nil)
//        let fact = try? await req.serializingDecodable(CatFact.self).value //Async
//        print(fact!)
//    }
//
//    
//    func delTask() async {
//        let req = AF.request("http://localhost:5000/task/d89879ae-ba6d-48e9-8da8-175d873bbef8", method: .delete, parameters: nil)
//        
//    }
//    
//    func createTask(_ newTodo:NewTodo) async {
//        let req = AF.request("http://localhost:5000/task", method: .post, parameters: newTodo, encoder: JSONParameterEncoder.default)
//        _ = req.serializingDecodable(Nothing.self, emptyResponseCodes: [201,204,205])
//    }
//}
