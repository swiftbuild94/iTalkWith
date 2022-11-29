//
//  LogInView.swift
//  iTalk
//
//  Created by Patricio Benavente on 24/03/2022.
//

import SwiftUI

struct LogInView: View {
    @ObservedObject var vm = LogInSignInVM()
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
//        if !vm.isUserLoggedOut {
//            self.didCompleateLoginProcess()
//        }
//    }
    
    func handleAction() {
        if vm.isLoginMode {
            vm.loginUser()
        } else {
            vm.createAccount()
        }
        print("IsUserLoggedOut \(vm.isUserLoggedOut)")
        if vm.isUserLoggedOut {
//            presentationMode.wrappedValue.dismiss()
            self.didCompleateLoginProcess()
        }
    }
    
    var body: some View {
          VStack {
              Picker(selection: $vm.isLoginMode, label: Text("Picker")) {
                  Text("Login")
                      .tag(true)
                  Text("Create Account")
                      .tag(false)
              }.pickerStyle(SegmentedPickerStyle())
                  .padding()
              Spacer()
              ScrollView {
                  VStack {
                      if !vm.isLoginMode {
                          Button {
                              shouldShowImagePicker.toggle()
                          } label: {
                              VStack {
                                  if let image = vm.image {
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
                              TextField("Name", text: $vm.name)
                                  .autocapitalization(.words)
                                  .keyboardType(.asciiCapable)
                                  .dynamicTypeSize(.large)
                                  .focused($focus, equals: .name)
                                  .onSubmit {
                                      focus = .emailSignUp
                                  }
                                  .submitLabel(.next)
                              TextField("Email", text: $vm.email)
                                  .keyboardType(.emailAddress)
                                  .autocapitalization(.none)
                                  .dynamicTypeSize(.large)
                                  .focused($focus, equals: .emailLogin)
                                  .onSubmit {
                                      focus = .phone
                                  }
                                  .submitLabel(.next)
                              TextField("Phone", text: $vm.phoneNumber)
                                  .keyboardType(.phonePad)
                                  .dynamicTypeSize(.large).focused($focus, equals: .phone)
                                  .onSubmit {
                                      focus = .passwordSignUp
                                  }
                                  .submitLabel(.next)
                              SecureField("Password", text: $vm.password)
                                  .keyboardType(/*@START_MENU_TOKEN@*/.asciiCapableNumberPad/*@END_MENU_TOKEN@*/)
                                  .autocapitalization(.none)
                                  .dynamicTypeSize(.large)
                                  .focused($focus, equals: .passwordSignUp)
                                  .onSubmit {
                                      focus = .retype
                                  }
                                  .submitLabel(.next)
                              SecureField("Retype Password", text: $vm.passwordRetype)
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
                              TextField("Email", text: $vm.email)
                                  .keyboardType(.emailAddress)
                                  .autocapitalization(.none)
                                  .dynamicTypeSize(.large)
                                  .focused($focus, equals: .emailSignUp)
                                  .onSubmit {
                                      focus = .passwordLogin
                                  }
                                  .submitLabel(.next)
                              SecureField("Password", text: $vm.password)
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
                      Text(vm.isLoginMode ? "Log In" : "Create Account" )
                          .font(.headline)
                          .padding(.vertical, 10)
                  })
                  .buttonBorderShape(.capsule)
                  .buttonStyle(.bordered)
                      .background(Color.blue)
                      .buttonStyle(.borderedProminent)
                     
                      .controlSize(.regular)
                      .padding()
                  Text(vm.errorMessage)
                      .foregroundColor(.red)
              }
          }
          .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
              ImagePicker(selectedImage: $vm.image, didSet: $shouldShowImagePicker)
          }
    }
        
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
