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
         let todoApi = TodoApiCalls()
        func getallTodos() async {
            
            let allTodos = await todoApi.getTodos()
            self.todos = allTodos
        }
         
         func getallTodosWithFilter(isComplete: Bool, isIncomplete: Bool) async {
             let allTodos = await todoApi.getTodosWithFilters(isComplete: isComplete, isIncomplete: isIncomplete)
             self.todos = allTodos
         }
         
         
         func deleteTodo(todoUUID: UUID) async {
             let uid = todoUUID
             await todoApi.delTodo(todoUUID: uid)
             
         }
         func postTodo(_ newTodo:NewTodo) async  {
             await todoApi.createTodo(newTodo)
         }
         
         func updateTodo(todoUUID: UUID, updateTodo: String, updateDueDate: String) async {
             let uid = todoUUID
             let uTodo = updateTodo
             let uDueDate = updateDueDate
             await todoApi.updateTodo(todoUUID: uid, updateTodo: uTodo, updateDueDate: uDueDate)
         }
         
//         func updateCompleteTodo(todoUUID: UUID, updateDueDate: String) async {
//             let uid = todoUUID
//             let uDueDate = updateDueDate
//             await todoApi.updateCompleteTodo(todoUUID: uid, updateDueDate: uDueDate)
//         }
         func updateStatus(todoUUID: UUID, completeStatus: Bool) async {
             let uid = todoUUID
             await todoApi.updateStatus(todoUUID: uid, completeStatus: completeStatus)
         }
         
    }
