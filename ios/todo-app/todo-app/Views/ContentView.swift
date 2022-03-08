//
//  ContentView.swift
//  todo-app
//
//  Created by Nicholas Chase on 3/1/22.
//

import SwiftUI
import CoreData
import Alamofire


struct ContentView: View {
      @StateObject private var viewModel = ViewModel()
      @State private var showingPostModal = false
      @State private var showingUpdateModal = false
      @State private var showingFilterModal = false
      @State private var isComplete = false
    var body: some View {
//        let test = TodoApiCalls()
        HStack{
            
            Button(action: {
                showingPostModal.toggle()

            }) {
                Image(systemName: "rectangle.stack.fill.badge.plus")
//                  .renderingMode(.original)
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 30, height: 30)
                  .symbolRenderingMode(.palette)
                  .foregroundStyle(.black, .blue)
            }.offset(x: 175, y: 10)
             .sheet(isPresented: $showingPostModal) {
                 PostModalView(viewModel: viewModel)
                }
                
                
        }
        
        HStack {
            Text(String(isComplete))
            Button(action: {
                showingFilterModal.toggle()
            }){
                Image(systemName: "list.bullet")
//                  .renderingMode(.original)
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 30, height: 30)
                  .symbolRenderingMode(.palette)
                  .foregroundStyle(.black, .blue)
            }.offset(x: 175, y: 35)
                .sheet(isPresented: $showingFilterModal) {
                    FilterView(isComplete: isComplete, viewModel: viewModel)
                   }
            
        }
                
        Text("ToDo'S")
            .task {
                 await viewModel.getallTodos()
                }

        VStack {
            List(viewModel.todos) { todos in
                VStack {
                    Text("Todo: \(todos.todo)")
                    Text("Created: \(todos.createdDate)")
                    Text("Due Date: \(todos.dueDate)")
                    Text(String("Finished: \(todos.completed)"))
                    HStack {
                        Button(action: {
                            
                            print("First button is tapped")
                        }) {
                            Image(systemName: "checkmark")
                              .renderingMode(.original)
                              .resizable()
                              .aspectRatio(contentMode: .fit)
                              .frame(width: 20, height: 20)
                        }.onTapGesture {
                            print("Complete button is tapped")
                            Task {
                                await viewModel.updateStatus(todoUUID: todos.uuid)
                                await viewModel.getallTodos()

                            }
                        }
                        Spacer()
                        Button(action: {
                            showingUpdateModal.toggle()
                            print("Update button is tapped")
                            print(todos.todo)
                        }) {
                            Image(systemName: "square.and.pencil")
                              .renderingMode(.original)
                              .resizable()
                              .aspectRatio(contentMode: .fit)
                              .frame(width: 20, height: 20)
                        }
                        .sheet(isPresented: $showingUpdateModal) { [todos] in
                            UpdateModalView(viewModel: viewModel, todo: todos.todo, dueDate: todos.dueDate, todoUUID: todos.uuid)
                        }
                        
                        
                        Spacer()
                        Button(action: {
                            
                        }) {
                            Image(systemName: "xmark")
                              .renderingMode(.original)
                              .resizable()
                              .aspectRatio(contentMode: .fit)
                              .frame(width: 20, height: 20)
                        }.onTapGesture {
                            print("Delete button is tapped")
                            Task {
//                                await test.delTodo(todoUUID: todos.uuid)
                                await viewModel.deleteTodo(todoUUID: todos.uuid)
                                await viewModel.getallTodos()
                            }
                        }
                    }

                }
//                .onTapGesture(perform: {
//                    print("list was tapped")
//                    Task {
//                        await test.getAtodo(todoUUID: todos.uuid)
//                    }
//                })
            }

        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct UpdateModalView: View {
    @Environment(\.dismiss) var dismiss
    var viewModel: ViewModel
    var todo: String
    var dueDate: String
    var todoUUID: UUID

    @State private var updatedTodo: String = ""
    @State private var updatedDueDate: String = ""
    
    
    var body: some View {
        Text("Update Screen")
            .font(.custom("", size: 50))
        
        
        VStack {
        TextField("\(todo)", text: $updatedTodo)
                .font(.custom("", size: 30))
                .background(Color.clear)
                .border(Color.black)
                .cornerRadius(3)
        TextField("\(dueDate)", text: $updatedDueDate)
                .font(.custom("", size: 30))
                .background(Color.clear)
                .border(Color.black)
                .cornerRadius(3)
        }
        .padding()
        .textFieldStyle(PlainTextFieldStyle())
        
        
        Button("UPDATE") {
            Task {
                await viewModel.updateTodo(todoUUID: todoUUID, updateTodo: updatedTodo, updateDueDate: updatedDueDate)
                await viewModel.getallTodos()

            }
            dismiss()
        }
        .font(.title)
        .padding()
        .background(Color.clear)
        .border(Color.black)
        .cornerRadius(3)
    }
}


struct PostModalView: View {
    @Environment(\.dismiss) var dismiss
    var viewModel: ViewModel
    
    @State private var newTodo: String = ""
    @State private var newDueDate: String = ""

    var body: some View {
        Text("New Todo")
            .font(.custom("", size: 50))
        VStack {
        TextField("Todo:", text: $newTodo)
                .font(.custom("", size: 30))
                .background(Color.clear)
                .border(Color.black)
                .cornerRadius(3)
        TextField("Due Date", text: $newDueDate)
                .font(.custom("", size: 30))
                .background(Color.clear)
                .border(Color.black)
                .cornerRadius(3)
        }
            .padding()
            .textFieldStyle(PlainTextFieldStyle())
        
        Button("Submit") {
            Task {
                await viewModel.postTodo(NewTodo(todo: newTodo, dueDate: newDueDate, completed: false))
                await viewModel.getallTodos()
            }
            dismiss()
        }
        .font(.title)
        .padding()
        .background(Color.clear)
        .border(Color.black)
        .cornerRadius(3)
    }
}



struct FilterView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var isComplete: Bool
    var viewModel: ViewModel

    var body: some View {
        
        Text("Filter")
            .font(.custom("", size: 50))

            .padding()
            .textFieldStyle(PlainTextFieldStyle())
        Text(String(isComplete))
        
        VStack {
            
            Toggle("Show completed tasks", isOn: $isComplete)
            
        }
        
       
        
        Button("Confirm") {
            dismiss()
        }
        .font(.title)
        .padding()
        .background(Color.clear)
        .border(Color.black)
        .cornerRadius(3)
    }
}
