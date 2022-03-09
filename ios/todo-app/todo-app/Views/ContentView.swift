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
      @State private var isIncomplete = false
      @State private var completeStatus = false
    var body: some View {
        HStack{
            
            Button(action: {
                showingPostModal.toggle()

            }) {
                Image(systemName: "rectangle.stack.fill.badge.plus")
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
            Button(action: {
                showingFilterModal.toggle()
            }){
                Image(systemName: "list.bullet")
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 30, height: 30)
                  .symbolRenderingMode(.palette)
                  .foregroundStyle(.black, .blue)
            }.offset(x: 175, y: 35)
                .sheet(isPresented: $showingFilterModal) {
                    FilterView(isComplete: $isComplete, isIncomplete: $isIncomplete, viewModel: viewModel)
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
                                completeStatus = todos.completed
                                completeStatus.toggle()
                                await viewModel.updateStatus(todoUUID: todos.uuid, completeStatus: completeStatus)
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
                                await viewModel.deleteTodo(todoUUID: todos.uuid)
                                await viewModel.getallTodos()
                            }
                        }
                    }

                }
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
    @State var selectedDate = Date()
    
    
    var body: some View {
        Text("Update Screen")
            .font(.custom("", size: 50))
        
        
        VStack {
        TextField("\(todo)", text: $updatedTodo)
                .font(.custom("", size: 30))
                .background(Color.clear)
                .border(Color.black)
                .cornerRadius(3)
        }
        .padding()
        .textFieldStyle(PlainTextFieldStyle())
        
        VStack {
            Form{
                
                DatePicker("Due Date", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                    Text("Your due date is: \(selectedDate)")
                }.padding()
            }
        
        
        Button("UPDATE") {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            updatedDueDate = formatter.string(from: selectedDate)
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
    @State var selectedDate = Date()
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
        }
            .padding()
            .textFieldStyle(PlainTextFieldStyle())
        
        
        VStack {
            Form{
                DatePicker("Due Date", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                    Text("Your due date is: \(selectedDate)")
                }.padding()
            }
            
        Button("Submit") {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            newDueDate = formatter.string(from: selectedDate)
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
    
    @Binding var isComplete: Bool
    @Binding var isIncomplete: Bool
    var viewModel: ViewModel

    var body: some View {
        
        Text("Filter")
        
            .font(.custom("", size: 50))

            .padding()
            .textFieldStyle(PlainTextFieldStyle())
        
        VStack {
            Toggle("Show incompleted tasks", isOn: $isIncomplete)
                .padding()
            Toggle("Show completed tasks", isOn: $isComplete)
                .padding()
        }
        
        Button("Confirm") {
            dismiss()
            if isComplete {
            Task {
                    await viewModel.getallTodosWithFilter(isComplete: isComplete, isIncomplete: isIncomplete)
                }
            }
            if isIncomplete {
                Task {
                    await viewModel.getallTodosWithFilter(isComplete: isComplete, isIncomplete: isIncomplete)
                }
            }
            else {
                Task {
                    await viewModel.getallTodos()
                }
            }
        }
        .font(.title)
        .padding()
        .background(Color.clear)
        .border(Color.black)
        .cornerRadius(3)
        .offset(y: 200)
    }
}
