//
//  FileHandler.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/17/22.
//

import Foundation
import SwiftyJSON

class FileHandler {
	// COPYRIGHT: https://stackoverflow.com/questions/60594363/unable-to-write-an-encoded-json-data-object-to-a-local-file-in-swift-5
	// TODO: Add official document to this function.
	func copyFileFromBundleToDocumentsFolder(sourceFile: String, destinationFile: String = "") {
		let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

		if let documentsURL = documentsURL {
			let sourceURL = Bundle.main.bundleURL.appendingPathComponent(sourceFile)

			// Use the same filename if destination filename is not specified
			let destURL = documentsURL.appendingPathComponent(!destinationFile.isEmpty ? destinationFile : sourceFile)

			do {
				try FileManager.default.removeItem(at: destURL)
				print("Removed existing file at destination")
			} catch (let error) {
				print(error)
			}

			do {
				try FileManager.default.copyItem(at: sourceURL, to: destURL)
				print("\(sourceFile) was copied successfully.")
			} catch (let error) {
				print(error)
			}
		}
	}
	
	func getJSONDataFromFile(fileName: String) -> JSON? {
		let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
		
		if let documentsURL = documentsURL {
			let fileURL = documentsURL.appendingPathComponent(fileName)
			
			do {
				let data = try Data(contentsOf: fileURL)

				let json = try JSON(data: data)
				
				return json
			} catch {
				print(error)
			}
		}
		
		return nil
	}
	
	func saveJSONDataToFile(json: Data, fileName: String) {
		let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

		if let documentsURL = documentsURL {
			let fileURL = documentsURL.appendingPathComponent(fileName)

			do {
				try json.write(to: fileURL, options: .atomicWrite)
			} catch {
				print(error)
			}
		}
	}
	
	func listDocumentDirectoryFiles() {
		let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

		if let url = documentsURL {
			do {
				let contents = try FileManager.default.contentsOfDirectory(atPath: url.path)
				print("\(contents.count) files inside the document directory:")
				for file in contents {
					print(file)
				}
			} catch {
				print("Could not retrieve contents of the document directory.")
			}
		}
	}
	
	func fileInDocumentDirectory(file: String) -> Bool {
		let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
		
		if let url = documentURL {
			do {
				let contents = try FileManager.default.contentsOfDirectory(atPath: url.path)
				
				for content in contents {
					if file == content {
						return true
					}
				}
				
			} catch {
				print(error)
			}
		}
		
		return false
	}
}
