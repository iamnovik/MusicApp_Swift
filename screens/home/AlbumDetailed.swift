//
//  AlbumDetailed.swift
//  music_app
//
//  Created by Novik Vladislav on 18.04.24.
//
import SwiftUI
import FirebaseStorage

struct AlbumDetailedView: View {
    @EnvironmentObject var authenticationService: AuthenticationService
    let album: Album
    let folderPath: String
    let userData: UserData?

    @State private var detailedFilesUrls: [String] = []
    @State private var isFavorite: Bool

    init(album: Album, folderPath: String, userData: UserData?) {
        self.album = album
        self.folderPath = folderPath
        self.userData = userData
        self._isFavorite = State(initialValue: album.isFav)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    
                    PreviewImage(path: folderPath + "preview.jpg")
                        .frame(width: 130, height: 190, alignment: .center)
                    Text(album.title)
                        .font(.title)
                        .foregroundColor(.red)
                        //.padding(.top)

                    Text(album.artist)
                        .font(.headline)
                        .foregroundColor(.red)

                    Text("\(album.year)")
                        .font(.headline)
                        .foregroundColor(.red)

                   // Spacer()

                    Button(action: toggleFavorite) {
                        Text(isFavorite ? "Удалить из избранного" : "Добавить в избранное")
                            .foregroundColor(.black)
                            .padding()
                            .background(isFavorite ? Color.green : Color(red: 0.93, green: 0, blue: 0.2))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .contentShape(Rectangle())
                    .padding()
                    if detailedFilesUrls.isEmpty {
                        ProgressView()
                    } else {
                        CarouselSlider(urls: detailedFilesUrls)
                            .frame (height: 300, alignment: .center)
                    }

                }
               // .padding()
                
            }
            .onAppear {
                fetchDetailedFilesUrls()
            }
            .navigationBarHidden(true)
            
        }
    }


    private func fetchDetailedFilesUrls() {
        Task {
            do {
                detailedFilesUrls = try await getDetailedFilesUrls(from: folderPath)
            } catch {
                print("Failed to fetch detailed files URLs: \(error)")
            }
        }
    }

    private func toggleFavorite() {
        if let userData = userData {
            if isFavorite {
                userData.favAlbums.removeAll(where: { $0 == album.uid })
            } else {
                userData.favAlbums.append(album.uid)
            }
            DatabaseService(uid: userData.uid).updateUserfavAlbums(favAlbums: userData.favAlbums)
            isFavorite.toggle()
        }
    }

    private var backButton: some View {
        Button(action: {
            // Handle back action
        }) {
            Image(systemName: "chevron.backward")
                .foregroundColor(.black)
        }
    }
    
    func getDetailedFilesUrls(from firebasePath: String) async throws -> [String] {
           do {
               var result: [String] = []
               let storageRef = Storage.storage().reference(withPath: firebasePath)
               let files = try await storageRef.listAll()

               for file in files.items {
                   let downloadURL = try await file.downloadURL()
                   result.append(downloadURL.absoluteString)
               }

               return result
           } catch {
               throw error
           }
       }
}

struct CarouselSlider: View {
    let urls: [String]

    var body: some View {
        TabView {
            ForEach(urls, id: \.self) { url in
                AsyncImage(url: URL(string: url)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height:300)
                            //.cornerRadius(10)
                    case .failure(let error):
                        Text("Failed to load image: \(error.localizedDescription)")
                    case .empty:
                        ProgressView()
                    @unknown default:
                        EmptyView()
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}
