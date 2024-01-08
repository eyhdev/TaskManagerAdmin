//
//  AddTaskView.swift
//  TaskManagerApp
//
//  Created by eyh.mac on 7.01.2024.
//

import SwiftUI

// SwiftUI view struct representing a form to add a new task
struct AddTaskView: View {
    @Binding var isPresented: Bool // Binding to control the presentation of the view
    @State private var taskTitle = "" // State for the task title
    @State private var taskDetails = "" // State for the task details
    @State private var selectedColorIndex = 0 // State for the selected color index
    @State private var selectedTaskTypeIndex = 0 // State for the selected task type index
    @State private var taskDeadline = Date() // State for the task deadline
    @State private var progress = 0 // State for the task progress (as a percentage)

    let colors = ["Red", "Green", "Blue", "Yellow", "Purple"] // Array of color options
    let taskTypes = ["Basic", "Urgent", "Important"] // Array of task type options

    // Callback closure to add a new task
    var onAddTask: (String, String, String, String, Int, Date) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Information")) {
                    // TextFields for task title and details
                    TextField("Task Title", text: $taskTitle)
                    TextField("Task Job Details", text: $taskDetails)
                }
                
                Section(header: Text("Task Type")) {
                    // Picker for selecting the task type
                    Picker("Task Type", selection: $selectedTaskTypeIndex) {
                        ForEach(0..<taskTypes.count) {
                            Text(taskTypes[$0])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Task Color")) {
                    // Picker for selecting the task color
                    Picker("Select Color", selection: $selectedColorIndex) {
                        ForEach(0..<colors.count) {
                            Text(colors[$0])
                                .foregroundColor(Color(colors[$0]))
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Task Progress")) {
                    // Picker for selecting the task progress as a percentage
                    Picker("Select Progress", selection: $progress) {
                        ForEach(0..<10) { percent in
                            Text("\(percent * 10)%")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }

                Section(header: Text("Task Deadline")) {
                    // DatePicker for selecting the task deadline
                    DatePicker("Select Date", selection: $taskDeadline, in: Date()..., displayedComponents: .date)
                }

                Section {
                    // Button to add the task with the selected parameters
                    Button("Add Task") {
                        let selectedColor = colors[selectedColorIndex].lowercased()
                        let selectedTaskType = taskTypes[selectedTaskTypeIndex]
                        
                        // Call the onAddTask closure with the provided task details
                        onAddTask(taskTitle, taskDetails, selectedColor, selectedTaskType, progress, taskDeadline)
                        
                        // Close the AddTaskView
                        isPresented = false
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationBarTitle("Add Task", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                // Close the AddTaskView when the cancel button is tapped
                isPresented = false
            })
        }
    }
}

