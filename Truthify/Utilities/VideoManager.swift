//
//  VideoManager.swift
//  Truthify
//
//  Created by Jacob Lucas on 1/13/23.
//

import Foundation
import FirebaseStorage

class VideoManager {
    
    static let instance = VideoManager()
    
    private var REF_STOR = Storage.storage()
    
    func uploadVideo(postID: String, video: URL, handler: @escaping (_ success: Bool) -> ()) {
        
        let path = getVideoPath(postID: postID)
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.uploadVideo(path: path, video: video) { (success) in
                DispatchQueue.main.async {
                    handler(success)
                }
            }
        }
    }
    
    private func getVideoPath(postID: String) -> StorageReference {
        let postPath = "posts/\(postID)/1"
        let storagePath = REF_STOR.reference(withPath: postPath)
        return storagePath
    }
    
    private func uploadVideo(path: StorageReference, video: URL, handler: @escaping (_ success: Bool) -> ()) {
        
        do {
            let data = try Data(contentsOf: video)
            let metadata = StorageMetadata()
            metadata.contentType = "video/mp4"
            
            path.putData(data, metadata: metadata) { (_, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
                handler(true)
            }
        } catch {
            print(error)
            handler(false)
        }
       
    }
    
    func downloadVideo(postID: String, handler: @escaping (_ video: URL?) -> ()) {
        // Get the path where the image is saved
        let path = getVideoPath(postID: postID)

        // Download the image from path
        DispatchQueue.global(qos: .userInteractive).async {
            self.downloadVideoFromStorage(path: path) { (returnedVideo) in
                DispatchQueue.main.async {
                    handler(returnedVideo)
                }
            }
        }
    }
    
    func downloadVideoFromStorage(path: StorageReference, handler: @escaping (_ video: URL) -> ()) {
        path.downloadURL { (returnedURL, error) in
            if let error = error {
                print("Error retrieving video from Storage Reference: \(error.localizedDescription)")
            }
            
            if let url = returnedURL {
                handler(url)
            }
        }
    }
    
}
