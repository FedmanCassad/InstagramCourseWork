//
//  CDPost+CoreDataProperties.swift
//  
//
//  Created by Vladimir Banushkin on 24.09.2021.
//
//

import Foundation
import CoreData


extension CDPost {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDPost> {
        return NSFetchRequest<CDPost>(entityName: "CDPost")
    }

    @NSManaged public var author: String?
    @NSManaged public var authorAvatar: URL?
    @NSManaged public var authorUsername: String?
    @NSManaged public var avatarPNGData: Data?
    @NSManaged public var createdTime: Date?
    @NSManaged public var currentUserLikesThisPost: Bool
    @NSManaged public var id: String?
    @NSManaged public var image: URL?
    @NSManaged public var imagePNGData: Data?
    @NSManaged public var likedByCount: Int16
    @NSManaged public var postDescription: String?
}

extension CDPost {
  func prepareFromCodablePost(post: Post) {
    self.author = post.author
    self.authorAvatar = post.authorAvatar
    self.authorUsername = post.authorUsername
    self.avatarPNGData = post.avatarImageData
    self.createdTime = post.createdTime
    self.currentUserLikesThisPost = post.currentUserLikesThisPost
    self.id = post.id
    self.image = post.image
    self.imagePNGData = post.imageData
    self.likedByCount = Int16(post.likedByCount)
    self.postDescription = post.postDescription
  }
}
