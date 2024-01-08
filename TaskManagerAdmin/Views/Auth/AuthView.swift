//
//  AuthView.swift
//  TaskManagerApp
//
//  Created by eyh.mac on 7.01.2024.
//

import SwiftUI

struct AuthView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isShowingLogin: Bool = true
    @StateObject var taskManager: TaskManager

    // Create an instance of Users
    @State private var users = Admins(name: "", surname: "", email: "", department: "", password: "", userId: nil)

    var body: some View {
        if isShowingLogin {
            LoginView(email: $email, password: $password, isShowingLogin: $isShowingLogin, taskManager: taskManager)
        } else {
            SignUpView(admins: $users, confirmPassword: $confirmPassword, isShowingLogin: $isShowingLogin, taskManager: taskManager)
        }
    }
}
