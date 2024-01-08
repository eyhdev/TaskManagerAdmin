//
//  ContentView.swift
//  TaskManagerAdmin
//
//  Created by eyh.mac on 7.01.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isShowingLogin = true
    @StateObject var taskManager: TaskManager
    @State private var isShowingAddTaskSheet = false
    var body: some View {
        NavigationView {
            if taskManager.currentUser != nil {
                UsersList(taskManager: TaskManager())
                    .navigationTitle("Users Tasks")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(
                        leading: Button(action: {
                            taskManager.signOut()
                        }, label: {
                            Text("Sign Out")
                                .foregroundStyle(.red)
                                .font(.callout)
                        })
                    )
            } else {
                VStack {
                    AuthView(taskManager: taskManager)
                }
                .padding()
                .navigationTitle("Authentication")
            }
        }
        .accentColor(.brown)
    }
}

