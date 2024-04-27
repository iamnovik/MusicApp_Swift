import SwiftUI

struct Registration: View {
    @StateObject var authService = AuthenticationService()
    @State private var email = ""
    @State private var password = ""
    @State private var loading = false
    @State private var error = ""
    
    var body: some View {
        ScrollView {
            VStack {
                Image("logo")
                    .resizable()
                    .frame(height: 160)
                
                Text("Зарегистрируйтесь")
                    .font(.title)
                    .foregroundColor(.black)
                    .padding(.top, 70)
                
                VStack(spacing: 20) {
                    TextField("Введите логин", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 30)
                    
                    SecureField("Введите пароль", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 30)
                }
                .padding(.top, 50)
                
                if !loading {
                    Button(action: register) {
                        Text("Регистрация")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(width: 300, height: 60)
                            .background(Color(red: 236/255, green: 0, blue: 51/255))
                            .cornerRadius(10)
                            .shadow(color: .gray, radius: 5, x: 0, y: 2)
                    }
                    .padding(.top, 100)
                } else {
                    ProgressView()
                        .padding(.top, 100)
                }
                
                Button(action: goToSignIn) {
                    Text("Войти")
                        .foregroundColor(Color(red: 100/255, green: 100/255, blue: 243/255))
                }
                .padding(.top, 20)
                
                Text(error)
                    .foregroundColor(Color(red: 219/255, green: 84/255, blue: 97/255))
                    .padding(.top, 20)
            }
            .padding()
        }
        .background(Color(red: 237/255, green: 237/255, blue: 237/255))
    }
    
    func register() {
            loading = true
    
            authService.register(email: email, password: password) { success in
                loading = false
                if success {
                    DispatchQueue.main.async {
                                    UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: Wrapper().environmentObject(authService))
                                }
                } else {
                    error = "Пожалуйста введите правильный email"
                }
            }
        }
    
    func goToSignIn() {
        DispatchQueue.main.async {
                        UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: SignIn().environmentObject(authService))
                    }
    }
}
