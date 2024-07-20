//
//  LogInPageView.swift
//  CultureTrek
//
//  Created by Giorgi Michitashvili on 7/12/24.
//

import SwiftUI

struct RegisterPageView: View {
    @StateObject var viewModel: RegisterPageVM
    
    var body: some View {
        ZStack {
            Color(hex: "181A20")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Register")
                    .font(.custom("FiraCode-Regular", size: 30))
                    .foregroundColor(.white)
                Spacer()
                    .frame(height: 70)
                VStack {
                    Text("Enter your Email")
                        .font(.custom("FiraCode-Regular", size: 15))
                        .foregroundColor(.gray)
                        .padding(.leading, -160)
                    
                    RoundedRectangle(cornerRadius: 20.0)
                        .stroke(Color.gray, lineWidth: 2)
                        .frame(height: 48)
                        .overlay(
                            TextField("Email", text: $viewModel.username)
                                .padding()
                                .foregroundColor(.white)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        )
                        .padding(.horizontal)
                    
                    Spacer()
                        .frame(height: 16)
                    
                    Text("Enter your password")
                        .font(.custom("FiraCode-Regular", size: 15))
                        .foregroundColor(.gray)
                        .padding(.leading, -160)
                    
                    RoundedRectangle(cornerRadius: 20.0)
                        .stroke(Color.gray, lineWidth: 2)
                        .frame(height: 48)
                        .overlay(
                            SecureField("Password", text: $viewModel.password)
                                .padding()
                                .foregroundColor(.white)
                        )
                        .padding(.horizontal)
                }
                
                Spacer()
                    .frame(height: 400)
                
                
                    Button(action: {
                        viewModel.validateInputs()
                    }, label: {
                        RoundedRectangle(cornerRadius: 24.0)
                            .fill(Color(hex: "353A40"))
                            .frame(width: 158, height: 48)
                            .overlay(
                                Text("Register")
                                    .foregroundColor(.white)
                                    .font(.custom("FiraCode-Regular", size: 18))
                            )
                    })
                
            }
            .padding()
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Input Error"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    RegisterPageView(viewModel: RegisterPageVM())
}

