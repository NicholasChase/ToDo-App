//
//  NewToDoModal.swift
//  todo-app
//
//  Created by Nicholas Chase on 3/4/22.
//

import SwiftUI

struct NewToDoModal: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        ZStack {
            if isShowing {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing = false
                    }
                VStack {
                    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                }
                .frame(height: 400)
                .frame(maxWidth: .infinity)
                .background(Color.white)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut)
        

    }
}

struct NewToDoModal_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
