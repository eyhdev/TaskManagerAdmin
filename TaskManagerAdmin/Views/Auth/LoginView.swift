//
//  LoginView.swift
//  TaskManagerApp
//
//  Created by eyh.mac on 7.01.2024.
//

import SwiftUI

// SwiftUI view struct representing a login screen
struct LoginView: View {
    @Binding var email: String // Binding for email input
    @Binding var password: String // Binding for password input
    @Binding var isShowingLogin: Bool // Binding to toggle between login and sign-up views
    @StateObject var taskManager: TaskManager // State object for managing the task manager

    var body: some View {
        // Vertical scroll view containing the login UI elements
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 40) {
                // App icon or logo
                Image(systemName: "list.clipboard.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gray)

                // Input fields for email and password
                VStack(spacing: 16) {
                    TextField("Email", text: $email)
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 2).stroke(Color.gray, lineWidth: 0.1))

                    SecureField("Password", text: $password)
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 2).stroke(Color.gray, lineWidth: 0.1))
                }

                // Buttons for logging in and switching between login and sign-up views
                VStack(spacing: 20) {
                    // Log In button
                    Button(action: {
                        taskManager.signIn(email: email, password: password) { success in
                            if success {
                                taskManager.fetchTasks()
                            }
                        }
                    }) {
                        Text("Log In")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(.ultraThickMaterial)
                            .cornerRadius(2)
                    }

                    // Switch to Sign-Up button
                    Button(action: {
                        // Toggle between login and sign-up views
                        isShowingLogin.toggle()
                    }) {
                        Text("Don't have an account? Sign Up")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }

                Spacer() // Spacer to push content to the top
            }
            .padding() // Padding around the content
        }
        .navigationBarTitle("Login") // Set navigation bar title
    }
}

