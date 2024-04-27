
import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @EnvironmentObject var authenticationService: AuthenticationService
    @ObservedObject var userData = UserData(uid: "")
    @State private var loadedUserData = false
    
    var body: some View {
        if let userId = Auth.auth().currentUser?.uid {
            NavigationView {
                VStack {
                    VStack {
                        //Spacer()
                        HStack {
                            PreviewImage(path: userData.image)
                            VStack(alignment: .leading) {
                                TextField("First Name", text: $userData.firstname)
                                    .padding(.bottom)
                                TextField("Second Name", text: $userData.secondname)
                                    .padding(.bottom)
                                TextField("About", text: $userData.about)
                            }
                        }
                        DatePicker("Birthdate", selection: $userData.birthdate, displayedComponents: .date)
                            .padding(.bottom)
                        TextField("Address", text: $userData.address)
                    }.padding(.horizontal,20)
                    
                    Section(header:
                        HStack {
                            Spacer()
                            Text("Favorites").font(.headline)
                            Spacer()
                        }
                        .listSectionSeparatorTint(nil)
                    ) {
                        HStack {
                            Text("Favorite Artist")
                                .padding(.horizontal, 20)
                            TextField("Favorite Artist", text: $userData.favartist)
                        }
                        HStack {
                            Text("Favorite Album")
                                .padding(.horizontal, 20)
                            //Spacer()
                            TextField("Favorite Album", text: $userData.favalbum)
                        }
                    }

                    
                    GeometryReader { geometry in
                        HStack {
                            Spacer()
                            Button(action: {
                                DatabaseService(uid: userId).updateUserData(firstname: userData.firstname, secondname: userData.secondname, birthdate: userData.birthdate, sex: userData.sex, address: userData.address, about: userData.about, favalbum: userData.favalbum, favartist: userData.favartist)
                            }) {
                                Text("Save")
                                    .frame(width: geometry.size.width / 4, height: 30)
                                    .background(Color.gray)
                                    .foregroundColor(.white)
                            }
                            .fixedSize(horizontal: true, vertical: true)
                            Spacer()
                            Button(action: {
                                authenticationService.signOut()
                            }) {
                                Text("Sign Out")
                                    .frame(width: geometry.size.width / 4, height: 30)
                                    .background(Color.gray)
                                    .foregroundColor(.white)
                            }
                            .fixedSize(horizontal: true, vertical: true)
                            Spacer()
                        }
                    }
                }
                .onAppear {
                    // Call function to get user data
                    if !loadedUserData {
                        DatabaseService(uid: userId).getUserData() { userData in
                            if let userData = userData {
                                self.userData.uid = userData.uid
                                self.userData.sex = userData.sex
                                self.userData.firstname = userData.firstname
                                self.userData.secondname = userData.secondname
                                self.userData.birthdate = userData.birthdate
                                self.userData.about = userData.about
                                self.userData.address = userData.address
                                self.userData.favAlbums = userData.favAlbums
                                self.userData.favartist = userData.favartist
                                self.userData.favalbum = userData.favalbum
                                self.userData.image = userData.image
                                loadedUserData = true
                            }
                        }
                    }
                }
                
            }.navigationBarHidden(false)
                .navigationBarBackButtonHidden(true)
                .navigationBarTitle("Profile", displayMode: .inline)
                .navigationBarItems(
                    trailing:
                        HStack {
                            NavigationLink(destination: SettingsView()) {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.red)
                            }
                            NavigationLink(destination: Favourites()) {
                                Image(systemName: "heart")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.red)
                            }
                            NavigationLink(destination: Wrapper()) {
                                Image(systemName: "list.bullet")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.red)
                            }
                        }
                )
        } else {
            Text("User not logged in")
        }
    }

}
