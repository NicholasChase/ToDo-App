//
//  ContentViewModel.swift
//  todo-app
//
//  Created by Nicholas Chase on 3/4/22.
//

import Foundation
import SwiftUI

//extension ContentView {
     @MainActor class ViewModel: ObservableObject {
        @Published var todos: [Todo] = []
        func getallTodos() async {
            let test = TodoApiCalls()
            
            let allTodos = await test.getTodos()
            self.todos = allTodos
        }
         
         func getallTodosWithFilter(isComplete: Bool, isIncomplete: Bool) async {
             let test = TodoApiCalls()
             let allTodos = await test.getTodosWithFilters(isComplete: isComplete, isIncomplete: isIncomplete)
             self.todos = allTodos
         }
         
         
         func deleteTodo(todoUUID: UUID) async {
             let test = TodoApiCalls()
             let uid = todoUUID
             await test.delTodo(todoUUID: uid)
             
         }
         func postTodo(_ newTodo:NewTodo) async  {
             let test = TodoApiCalls()
             await test.createTodo(newTodo)
         }
//         func updateTodo(todoUUID: UUID) async {
//             let test = TodoApiCalls()
//             let uid = todoUUID
//             await test.updateTodo(todoUUID: uid)
//         }
         func updateTodo(todoUUID: UUID, updateTodo: String, updateDueDate: String) async {
             let test = TodoApiCalls()
             let uid = todoUUID
             let uTodo = updateTodo
             let uDueDate = updateDueDate
             await test.updateTodo(todoUUID: uid, updateTodo: uTodo, updateDueDate: uDueDate)
         }
         
         func updateCompleteTodo(todoUUID: UUID, updateDueDate: String) async {
             let test = TodoApiCalls()
             let uid = todoUUID
             let uDueDate = updateDueDate
             await test.updateCompleteTodo(todoUUID: uid, updateDueDate: uDueDate)
         }
         func updateStatus(todoUUID: UUID) async {
             let test = TodoApiCalls()
             let uid = todoUUID
             await test.updateStatus(todoUUID: uid)
         }
         
    }
//}

