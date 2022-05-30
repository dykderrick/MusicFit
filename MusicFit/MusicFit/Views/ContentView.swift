//
//  ContentView.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/7/22.
//

import MediaPlayer
import StoreKit
import SwiftUI

struct ContentView: View {
	@ObservedObject var musicManager: AppleMusicManager
	@ObservedObject var workoutManager: WorkoutManager
	@ObservedObject var musicPlayer: MusicPlayer
	let fileHandler: FileHandler
	let intentHandler: ContentViewIntentHandler
	let musicFitPlaylistManager: MusicFitPlaylistManager
	@State private var selection = 0
	
    var body: some View {
		TabView(selection: $selection) {
			NowView(workoutManager: workoutManager, musicPlayer: musicPlayer)
				.tag(0)
				.tabItem {
					VStack {
						Image(systemName: "music.note")  // TODO: Change image
						Text("Now")
					}
				}
			
			PlaylistView(musicManager: musicManager, musicPlayer: musicPlayer, musicFitPlaylistManager: musicFitPlaylistManager)
				.tag(1)
				.tabItem {
					VStack {
						Image(systemName: "text.append")
						Text("Playlist")
					}
				}
			
			SearchView()
				.tag(2)
				.tabItem {
					VStack {
						Image(systemName: "magnifyingglass")
						Text("Search")
					}
				}
			
			MeView()
				.tag(3)
				.tabItem {
					VStack {
						Image(systemName: "person.fill")
						Text("Me")
					}
				}
		}
		.accentColor(Color(hex: "#25E495"))
		.onAppear() {
			// Copy Bundle file MusicFitPlaylists.json to App Documents directory.
			intentHandler.setMusicFitPlaylistMetadata(fileHandler)
			
			// Make sure all playlists previously set are available. If not available, set to "".
			intentHandler.setMusicFitPlaylistsAvailability(musicManager)
			
			SKCloudServiceController.requestAuthorization { (status) in
				if status == .authorized {
					musicManager.getUserToken { userToken in
						print(userToken)
						
						/*
						musicManager.createPlaylistWithCatelogSongs(userToken, playlistName: "test playlist", playlistDescription: "test description", playlistFolderId: "p.playlistsroot", songCatelogIds: ["1450695739", "1440811598"]) { playlist in
							print(playlist)
						}
						 */
						
						/*
						musicManager.getSongRating(userToken, id: "1544494722") { rating in
							print(rating)
						}
						 */
						
						/*
						musicManager.createLibraryPlaylistFolder(userToken, folderName: "test folder") { isCreated, folderId in
							print(isCreated)
							print(folderId)
						}
						 */
						
						print("RESTING TEST: \(musicFitPlaylistManager.getMusicFitPlaylistId(musicFitStatus: .Resting))")
						
                        
                        musicManager.getAllLibraryPlaylists(userToken) { playlists in
                            print(playlists)
                        }

						/*
						musicManager.fetchStorefrontID(userToken: userToken) { storefrontID in
							print(storefrontID)
							musicManager.searchAppleMusic(userToken, storefrontID, "Taylor Swift") { songs in
								print(songs)
							}
						}
						 */
					}
				}
			}
		}
    }
}

// https://stackoverflow.com/questions/56874133/use-hex-color-in-swiftui
// TODO: Add formal docs to this function.
extension Color {
	init(hex: String) {
		let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
		var int: UInt64 = 0
		Scanner(string: hex).scanHexInt64(&int)
		let a, r, g, b: UInt64
		switch hex.count {
		case 3: // RGB (12-bit)
			(a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
		case 6: // RGB (24-bit)
			(a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
		case 8: // ARGB (32-bit)
			(a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
		default:
			(a, r, g, b) = (1, 1, 1, 0)
		}

		self.init(
			.sRGB,
			red: Double(r) / 255,
			green: Double(g) / 255,
			blue:  Double(b) / 255,
			opacity: Double(a) / 255
		)
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		let musicManager = AppleMusicManager()
		let fileHandler = FileHandler()
		let musicFitPlaylistManager = MusicFitPlaylistManager(musicManager: musicManager, fileHandler: fileHandler)
		let intentHandler = ContentViewIntentHandler(musicFitPlaylistManager: musicFitPlaylistManager)
		let workoutManager = WorkoutManager()
		let musicPlayer = MusicPlayer()
		
		
		ContentView(musicManager: musicManager, workoutManager: workoutManager, musicPlayer: musicPlayer, fileHandler: fileHandler, intentHandler: intentHandler, musicFitPlaylistManager: musicFitPlaylistManager)
			.preferredColorScheme(.dark)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
		
		ContentView(musicManager: musicManager, workoutManager: workoutManager, musicPlayer: musicPlayer, fileHandler: fileHandler, intentHandler: intentHandler, musicFitPlaylistManager: musicFitPlaylistManager)
			.preferredColorScheme(.light)
			.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
}
