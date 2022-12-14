//
//  LogInView.swift
//  iTalk
//
//  Created by Patricio Benavente on 24/03/2022.
//

import SwiftUI

struct LogInView: View {
    @EnvironmentObject var vmLogin: LogInSignInVM
//    @State private var name = ""
//    @State private var email = ""
//    @State private var password = "" 0
//    @State private var passwordRetype = ""
//    @State private var phoneNumber = ""
//    @State private var errorMessage = "Error"
//  @State private var isLoginMode = true
    @Binding var isUserLoggedOut: Bool
    @State private var shouldShowImagePicker = false
    @State private var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    var didCompleateLoginProcess: () -> ()
    @FocusState private var focus: Focus?
    
    enum Focus {
        case emailLogin
        case emailSignUp
        case passwordLogin
        case passwordSignUp
        case name
        case retype
        case phone
    }
    
//    init(){
//        if !vmLogin.isUserLoggedOut {
//            self.didCompleateLoginProcess()
//        }
//    }
    
    func handleAction() {
        if vmLogin.isLoginMode {
            vmLogin.loginUser()
        } else {
            vmLogin.createAccount()
        }
        print("IsUserLoggedOut \(vmLogin.isUserLoggedOut)")
        if vmLogin.isUserLoggedOut {
//            presentationMode.wrappedValue.dismiss()
            self.didCompleateLoginProcess()
        }
    }
    
    var body: some View {
          VStack {
              Picker(selection: $vmLogin.isLoginMode, label: Text("Picker")) {
                  Text("Login")
                      .tag(true)
                  Text("Create Account")
                      .tag(false)
              }.pickerStyle(SegmentedPickerStyle())
                  .padding()
              Spacer()
              ScrollView {
                  VStack {
                      if !vmLogin.isLoginMode {
                          Button {
                              shouldShowImagePicker.toggle()
                          } label: {
                              VStack {
                                  if let image = vmLogin.image {
                                      Image(uiImage: image)
                                          .resizable()
                                          .scaledToFill()
                                          .frame(width: 128, height: 128)
                                          .cornerRadius(64)
                                  } else {
                                      Image(systemName: "person.fill")
                                          .font(.system(size: 64))
                                          .padding()
                                          .foregroundColor(Color(.label))
                                  }
                              }
                              .overlay(RoundedRectangle(cornerRadius: 64)
                                        .stroke(Color.black, lineWidth: 3))
                          }
                          Spacer()
                          Group {
                              TextField("Name", text: $vmLogin.name)
                                  .autocapitalization(.words)
                                  .keyboardType(.asciiCapable)
                                  .dynamicTypeSize(.large)
                                  .focused($focus, equals: .name)
                                  .onSubmit {
                                      focus = .emailSignUp
                                  }
                                  .submitLabel(.next)
                              TextField("Email", text: $vmLogin.email)
                                  .keyboardType(.emailAddress)
                                  .autocapitalization(.none)
                                  .dynamicTypeSize(.large)
                                  .focused($focus, equals: .emailLogin)
                                  .onSubmit {
                                      focus = .phone
                                  }
                                  .submitLabel(.next)
                              TextField("Phone", text: $vmLogin.phoneNumber)
                                  .keyboardType(.phonePad)
                                  .dynamicTypeSize(.large).focused($focus, equals: .phone)
                                  .onSubmit {
                                      focus = .passwordSignUp
                                  }
                                  .submitLabel(.next)
                              SecureField("Password", text: $vmLogin.password)
                                  .keyboardType(/*@START_MENU_TOKEN@*/.asciiCapableNumberPad/*@END_MENU_TOKEN@*/)
                                  .autocapitalization(.none)
                                  .dynamicTypeSize(.large)
                                  .focused($focus, equals: .passwordSignUp)
                                  .onSubmit {
                                      focus = .retype
                                  }
                                  .submitLabel(.next)
                              SecureField("Retype Password", text: $vmLogin.passwordRetype)
                                  .keyboardType(/*@START_MENU_TOKEN@*/.asciiCapableNumberPad/*@END_MENU_TOKEN@*/)
                                  .autocapitalization(.none)
                                  .dynamicTypeSize(.large)
                                  .focused($focus, equals: .retype)
                                  .onSubmit {
                                      focus = .passwordLogin
                                  }
                                  .submitLabel(.join)
                          }.textFieldStyle(RoundedBorderTextFieldStyle())
                              .padding(12)
                              .disableAutocorrection(true)
                              .font(.system(size: 24))
                          Spacer()
                      } else {
                          Group {
                              TextField("Email", text: $vmLogin.email)
                                  .keyboardType(.emailAddress)
                                  .autocapitalization(.none)
                                  .dynamicTypeSize(.large)
                                  .focused($focus, equals: .emailSignUp)
                                  .onSubmit {
                                      focus = .passwordLogin
                                  }
                                  .submitLabel(.next)
                              SecureField("Password", text: $vmLogin.password)
                              .autocapitalization(.none)
                                  .dynamicTypeSize(.large)
                                  .focused($focus, equals: .passwordLogin)
                                  .onSubmit {
                                      handleAction()
                                  }
                                  .submitLabel(.go)
                          }
                          .textFieldStyle(RoundedBorderTextFieldStyle())
                              .padding(12)
                             .disableAutocorrection(true)
                      }
                  }
                 
                  Button(action: {
                      handleAction()
                  }, label: {
                      Text(vmLogin.isLoginMode ? "Log In" : "Create Account" )
                          .font(.headline)
                          .padding(.vertical, 10)
                          .padding(5)
                  })
                  .buttonBorderShape(.capsule)
                    .background(Color.blue)
                    .controlSize(.regular)
                  Text(vmLogin.errorMessage)
                    .foregroundColor(.red)
              }
          }
          .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
              ImagePicker(selectedImage: $vmLogin.image, didSet: $shouldShowImagePicker)
          }
    }
        
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 14 Pro")
    }
}
