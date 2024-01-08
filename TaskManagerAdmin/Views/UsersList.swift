//
//  UsersList.swift
//  TaskManagerAdmin
//
//  Created by eyh.mac on 7.01.2024.
//

import SwiftUI


struct UsersList: View {
    @ObservedObject var taskManager: TaskManager

    var body: some View {
        List(taskManager.users, id: \.userId) { user in
            NavigationLink {
                UserDetailView(user: user)
            } label: {
                HStack {
                    Text("\(user.name) \(user.surname)")
                        .bold()
                    Spacer()
                    Text(user.departmant ?? "")
                        .foregroundColor(.white)
                        .font(.callout)
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                        .background {
                            Capsule()
                                .fill(.brown.opacity(0.8))
                        }
                }
            }
        }
        .onAppear {
            taskManager.fetchUsers()
        }
    }
}


struct UserDetailView: View {
    let user: Users

    var body: some View {
        List {
            Section(header: Text("Personal Information")) {
                Text("\(user.name)")
                Text("\(user.surname)")
                Text("\(user.email)")
            }
            .bold()
            Section(header: Text("Department")) {
                Text("\(user.departmant)")
            }
            .bold()
            Section(header: Text("Tasks List")) {
                NavigationLink {
                    TasksList(taskManager: TaskManager(), user: user)
                } label: {
                    Text("User Tasks")
                }
            }
            .bold()
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("User Detail")
    }
}
