//
//  TasksList.swift
//  TaskManagerApp
//
//  Created by eyh.mac on 7.01.2024.
//

import SwiftUI

// Extension on Date to check if the date is in the future (isNew)
extension Date {
    var isNew: Bool {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        let taskDate = calendar.startOfDay(for: self)

        return taskDate >= currentDate
    }
}

// SwiftUI view struct representing a list of tasks
struct TasksList: View {
    @StateObject var taskManager = TaskManager() // State object for managing the task manager
    @State private var isShowingAddTaskSheet = false
    let user: Users
    
    var body: some View {
        // Vertical scroll view containing the list of tasks
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                // Check if there are no tasks, display a message and an image
                if taskManager.tasks.isEmpty {
                    VStack {
                        Text("No tasks added yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                        Image(systemName: "xmark.bin")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    }
                } else {
                    // Display the list of tasks using LazyVStack
                    LazyVStack(spacing: 10) {
                        ForEach(taskManager.tasksForUser(userId: user.userId ?? "")) { task in
                            TaskCard(task: task, taskManager: TaskManager())
                        }
                        .padding(5)
                    }
                }
            }
            .padding(5)
            .navigationBarItems(trailing: Button(action: {
                isShowingAddTaskSheet.toggle()
            }) {
                Label {
                    Text("Add Task")
                        .font(.callout)
                        .fontWeight(.semibold)
                    
                } icon: {
                    Image(systemName: "plus.app.fill")
                }
                .foregroundColor(.white)
                .padding(5)
                .background(.brown , in:Capsule())
            })
            .sheet(isPresented: $isShowingAddTaskSheet) {
                AddTaskView(isPresented: $isShowingAddTaskSheet, onAddTask: { title, details, color, type, userId, progress, deadline in
                    taskManager.addTask(title: title, details: details, color: color, type: type, userId: userId, progress: progress, deadline: deadline)
                }, user: user)
            }

        }
        .onAppear(perform: taskManager.fetchTasks) // Fetch tasks when the view appears
    }
}
