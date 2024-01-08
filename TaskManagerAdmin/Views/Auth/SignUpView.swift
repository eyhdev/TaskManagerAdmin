//
//  SignUpView.swift
//  TaskManagerApp
//
//  Created by eyh.mac on 7.01.2024.
//

import SwiftUI

// SwiftUI view struct representing a sign-up screen
struct SignUpView: View {
    @Binding var users: Users // Binding for user information input
    @Binding var confirmPassword: String // Binding for confirming the password
    @Binding var isShowingLogin: Bool // Binding to toggle between login and sign-up views
    @StateObject var taskManager: TaskManager // State object for managing the task manager

    // Computed property to check if passwords match and are not empty
    var passwordsMatch: Bool {
        return users.password == confirmPassword && !users.password.isEmpty
    }

    var body: some View {
        // Vertical scroll view containing the sign-up UI elements
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 40) {
                // Icon or logo for the sign-up screen
                Image(systemName: "person.badge.plus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gray)

                // Input fields for user information
                VStack(spacing: 16) {
                    TextField("Name", text: $users.name)
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 2).stroke(Color.gray, lineWidth: 0.1))

                    TextField("Surname", text: $users.surname)
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 2).stroke(Color.gray, lineWidth: 0.1))

                    TextField("What is your department?", text: $users.departmant)
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 2).stroke(Color.gray, lineWidth: 0.1))

                    TextField("Email", text: $users.email)
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 2).stroke(Color.gray, lineWidth: 0.1))

                    SecureField("Password", text: $users.password)
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 2).stroke(Color.gray, lineWidth: 0.1))

                    SecureField("Confirm Password", text: $confirmPassword)
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 2).stroke(Color.gray, lineWidth: 0.1))
                }

                // Buttons for signing up and switching between login and sign-up views
                VStack(spacing: 20) {
                    // Sign Up button
                    Button(action: {
                        taskManager.signUp(users: users) { success in
                            if success {
                                taskManager.fetchTasks()
                            }
                        }
                    }) {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(passwordsMatch ? Color.white : Color.black.opacity(0.5))
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(passwordsMatch ? Color.blue : Color.gray)
                            .cornerRadius(2)
                            .opacity(passwordsMatch ? 1.0 : 0.5)
                    }
                    .disabled(!passwordsMatch)

                    // Switch to Login button
                    Button(action: {
                        // Toggle between login and sign-up views
                        isShowingLogin.toggle()
                    }) {
                        Text("Already have an account? Log In")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }

                Spacer() // Spacer to push content to the top
            }
            .padding() // Padding around the content
        }
        .navigationBarTitle("Sign Up") // Set navigation bar title
    }
}
