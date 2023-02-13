//
//  CacheManager.swift
//  Truthify
//
//  Created by Jacob Lucas on 2/7/23.
//

import Foundation
import SwiftUI

//class VideoFileManager {
//    
//    static let instance = VideoFileManager()
//    let folderName = "downloaded_videos"
//    
//    private init() {
//        createFolderIfNeeded()
//    }
//    
//    func createFolderIfNeeded() {
//        guard let url = getFolderPath() else { return }
//        
//        if !FileManager.default.fileExists(atPath: url.path) {
//            do {
//                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
//                print("Created folder")
//            } catch let error {
//                print("Error creating folder: \(error)")
//            }
//        }
//    }
//    
//    private func getFolderPath() -> URL? {
//        return FileManager
//            .default
//            .urls(for: .cachesDirectory, in: .userDomainMask)
//            .first?
//            .appendingPathComponent(folderName)
//    }
//    
//    private func getVideoPath(key: String) -> URL? {
//        guard let folder = getFolderPath() else {
//            return nil
//        }
//        return folder.appendingPathComponent(key + "mp4")
//        
//    }
//    
//    func add(key: String, value: NSData) {
//        guard let path = getVideoPath(key: key) else { return }
//        
//        do {
//            try value.write(to: path)
//        } catch let error {
//            print("Error saving to file manager: \(error)")
//        }
//    }
//    
//    func get(key: String) -> URL? {
//        guard let path = getVideoPath(key: key),
//              FileManager.default.fileExists(atPath: path.path) else {
//            return nil
//        }
//        return path
//    }
//    
//}

//public enum Result<T> {
//    case success(T)
//    case failure(NSError)
//}

//class CacheManager {
//
//    static let shared = CacheManager()
//    private let fileManager = FileManager.default
//    private lazy var mainDirectoryUrl: URL = {
//        let documentsUrl = self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
//        return documentsUrl
//    }()
//
//    func getFileWith(stringUrl: String, completionHandler: @escaping (Result<URL>) -> Void ) {
//        let file = directoryFor(stringUrl: stringUrl)
//
//        //return file path if already exists in cache directory
//        guard !fileManager.fileExists(atPath: file.path)  else {
//            completionHandler(Result.success(file))
//            return
//        }
//
//        DispatchQueue.global().async {
//            if let videoData = NSData(contentsOf: URL(string: stringUrl)!) {
//                videoData.write(to: file, atomically: true)
//
//                DispatchQueue.main.async {
//                    completionHandler(Result.success(file))
//                }
//            } else {
//                DispatchQueue.main.async {
//                    print("Error caching")
//                }
//            }
//        }
//    }
//
//    private func directoryFor(stringUrl: String) -> URL {
//        let fileURL = URL(string: stringUrl)!.lastPathComponent
//        let file = self.mainDirectoryUrl.appendingPathComponent(fileURL)
//        return file
//    }
//}
