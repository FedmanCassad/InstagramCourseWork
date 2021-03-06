//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap { Locale(identifier: $0) } ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)

  /// Find first language and bundle for which the table exists
  fileprivate static func localeBundle(tableName: String, preferredLanguages: [String]) -> (Foundation.Locale, Foundation.Bundle)? {
    // Filter preferredLanguages to localizations, use first locale
    var languages = preferredLanguages
      .map { Locale(identifier: $0) }
      .prefix(1)
      .flatMap { locale -> [String] in
        if hostingBundle.localizations.contains(locale.identifier) {
          if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
            return [locale.identifier, language]
          } else {
            return [locale.identifier]
          }
        } else if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
          return [language]
        } else {
          return []
        }
      }

    // If there's no languages, use development language as backstop
    if languages.isEmpty {
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages = [developmentLocalization]
      }
    } else {
      // Insert Base as second item (between locale identifier and languageCode)
      languages.insert("Base", at: 1)

      // Add development language as backstop
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages.append(developmentLocalization)
      }
    }

    // Find first language for which table exists
    // Note: key might not exist in chosen language (in that case, key will be shown)
    for language in languages {
      if let lproj = hostingBundle.url(forResource: language, withExtension: "lproj"),
         let lbundle = Bundle(url: lproj)
      {
        let strings = lbundle.url(forResource: tableName, withExtension: "strings")
        let stringsdict = lbundle.url(forResource: tableName, withExtension: "stringsdict")

        if strings != nil || stringsdict != nil {
          return (Locale(identifier: language), lbundle)
        }
      }
    }

    // If table is available in main bundle, don't look for localized resources
    let strings = hostingBundle.url(forResource: tableName, withExtension: "strings", subdirectory: nil, localization: nil)
    let stringsdict = hostingBundle.url(forResource: tableName, withExtension: "stringsdict", subdirectory: nil, localization: nil)

    if strings != nil || stringsdict != nil {
      return (applicationLocale, hostingBundle)
    }

    // If table is not found for requested languages, key will be shown
    return nil
  }

  /// Load string from Info.plist file
  fileprivate static func infoPlistString(path: [String], key: String) -> String? {
    var dict = hostingBundle.infoDictionary
    for step in path {
      guard let obj = dict?[step] as? [String: Any] else { return nil }
      dict = obj
    }
    return dict?[key] as? String
  }

  static func validate() throws {
    try intern.validate()
  }

  #if os(iOS) || os(tvOS)
  /// This `R.storyboard` struct is generated, and contains static references to 1 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    #endif

    fileprivate init() {}
  }
  #endif

  /// This `R.file` struct is generated, and contains static references to 8 files.
  struct file {
    /// Resource file `new1.jpg`.
    static let new1Jpg = Rswift.FileResource(bundle: R.hostingBundle, name: "new1", pathExtension: "jpg")
    /// Resource file `new2.jpg`.
    static let new2Jpg = Rswift.FileResource(bundle: R.hostingBundle, name: "new2", pathExtension: "jpg")
    /// Resource file `new3.jpg`.
    static let new3Jpg = Rswift.FileResource(bundle: R.hostingBundle, name: "new3", pathExtension: "jpg")
    /// Resource file `new4.jpg`.
    static let new4Jpg = Rswift.FileResource(bundle: R.hostingBundle, name: "new4", pathExtension: "jpg")
    /// Resource file `new5.jpg`.
    static let new5Jpg = Rswift.FileResource(bundle: R.hostingBundle, name: "new5", pathExtension: "jpg")
    /// Resource file `new6.jpg`.
    static let new6Jpg = Rswift.FileResource(bundle: R.hostingBundle, name: "new6", pathExtension: "jpg")
    /// Resource file `new7.jpg`.
    static let new7Jpg = Rswift.FileResource(bundle: R.hostingBundle, name: "new7", pathExtension: "jpg")
    /// Resource file `new8.jpg`.
    static let new8Jpg = Rswift.FileResource(bundle: R.hostingBundle, name: "new8", pathExtension: "jpg")

    /// `bundle.url(forResource: "new1", withExtension: "jpg")`
    static func new1Jpg(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.new1Jpg
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "new2", withExtension: "jpg")`
    static func new2Jpg(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.new2Jpg
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "new3", withExtension: "jpg")`
    static func new3Jpg(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.new3Jpg
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "new4", withExtension: "jpg")`
    static func new4Jpg(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.new4Jpg
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "new5", withExtension: "jpg")`
    static func new5Jpg(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.new5Jpg
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "new6", withExtension: "jpg")`
    static func new6Jpg(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.new6Jpg
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "new7", withExtension: "jpg")`
    static func new7Jpg(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.new7Jpg
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "new8", withExtension: "jpg")`
    static func new8Jpg(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.new8Jpg
      return fileResource.bundle.url(forResource: fileResource)
    }

    fileprivate init() {}
  }

  /// This `R.image` struct is generated, and contains static references to 15 images.
  struct image {
    /// Image `LaunchScreen`.
    static let launchScreen = Rswift.ImageResource(bundle: R.hostingBundle, name: "LaunchScreen")
    /// Image `bigLike`.
    static let bigLike = Rswift.ImageResource(bundle: R.hostingBundle, name: "bigLike")
    /// Image `feed`.
    static let feed = Rswift.ImageResource(bundle: R.hostingBundle, name: "feed")
    /// Image `image-placeholder`.
    static let imagePlaceholder = Rswift.ImageResource(bundle: R.hostingBundle, name: "image-placeholder")
    /// Image `like`.
    static let like = Rswift.ImageResource(bundle: R.hostingBundle, name: "like")
    /// Image `new1.jpg`.
    static let new1Jpg = Rswift.ImageResource(bundle: R.hostingBundle, name: "new1.jpg")
    /// Image `new2.jpg`.
    static let new2Jpg = Rswift.ImageResource(bundle: R.hostingBundle, name: "new2.jpg")
    /// Image `new3.jpg`.
    static let new3Jpg = Rswift.ImageResource(bundle: R.hostingBundle, name: "new3.jpg")
    /// Image `new4.jpg`.
    static let new4Jpg = Rswift.ImageResource(bundle: R.hostingBundle, name: "new4.jpg")
    /// Image `new5.jpg`.
    static let new5Jpg = Rswift.ImageResource(bundle: R.hostingBundle, name: "new5.jpg")
    /// Image `new6.jpg`.
    static let new6Jpg = Rswift.ImageResource(bundle: R.hostingBundle, name: "new6.jpg")
    /// Image `new7.jpg`.
    static let new7Jpg = Rswift.ImageResource(bundle: R.hostingBundle, name: "new7.jpg")
    /// Image `new8.jpg`.
    static let new8Jpg = Rswift.ImageResource(bundle: R.hostingBundle, name: "new8.jpg")
    /// Image `plus`.
    static let plus = Rswift.ImageResource(bundle: R.hostingBundle, name: "plus")
    /// Image `profile`.
    static let profile = Rswift.ImageResource(bundle: R.hostingBundle, name: "profile")

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "LaunchScreen", bundle: ..., traitCollection: ...)`
    static func launchScreen(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.launchScreen, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "bigLike", bundle: ..., traitCollection: ...)`
    static func bigLike(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.bigLike, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "feed", bundle: ..., traitCollection: ...)`
    static func feed(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.feed, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "image-placeholder", bundle: ..., traitCollection: ...)`
    static func imagePlaceholder(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.imagePlaceholder, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "like", bundle: ..., traitCollection: ...)`
    static func like(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.like, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "new1.jpg", bundle: ..., traitCollection: ...)`
    static func new1Jpg(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.new1Jpg, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "new2.jpg", bundle: ..., traitCollection: ...)`
    static func new2Jpg(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.new2Jpg, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "new3.jpg", bundle: ..., traitCollection: ...)`
    static func new3Jpg(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.new3Jpg, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "new4.jpg", bundle: ..., traitCollection: ...)`
    static func new4Jpg(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.new4Jpg, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "new5.jpg", bundle: ..., traitCollection: ...)`
    static func new5Jpg(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.new5Jpg, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "new6.jpg", bundle: ..., traitCollection: ...)`
    static func new6Jpg(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.new6Jpg, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "new7.jpg", bundle: ..., traitCollection: ...)`
    static func new7Jpg(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.new7Jpg, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "new8.jpg", bundle: ..., traitCollection: ...)`
    static func new8Jpg(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.new8Jpg, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "plus", bundle: ..., traitCollection: ...)`
    static func plus(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.plus, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "profile", bundle: ..., traitCollection: ...)`
    static func profile(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.profile, compatibleWith: traitCollection)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.string` struct is generated, and contains static references to 1 localization tables.
  struct string {
    /// This `R.string.localizable` struct is generated, and contains static references to 12 localization keys.
    struct localizable {
      /// en translation: Feed
      ///
      /// Locales: en, ru
      static let feedControllerTitle = Rswift.StringResource(key: "feedControllerTitle", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Follow
      ///
      /// Locales: en, ru
      static let followButtonTitle = Rswift.StringResource(key: "followButtonTitle", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Followers: 
      ///
      /// Locales: en, ru
      static let followersLabelTitle = Rswift.StringResource(key: "followersLabelTitle", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Following: 
      ///
      /// Locales: en, ru
      static let followedLabelTitle = Rswift.StringResource(key: "followedLabelTitle", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Likes: 
      ///
      /// Locales: en, ru
      static let likesCountLabel = Rswift.StringResource(key: "likesCountLabel", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Log out
      ///
      /// Locales: en, ru
      static let logOutButtonTitle = Rswift.StringResource(key: "logOutButtonTitle", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Login
      ///
      /// Locales: en, ru
      static let loginPlaceholder = Rswift.StringResource(key: "loginPlaceholder", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: New post
      ///
      /// Locales: en, ru
      static let newPostControllerTitle = Rswift.StringResource(key: "newPostControllerTitle", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Password
      ///
      /// Locales: en, ru
      static let passwordPlaceholder = Rswift.StringResource(key: "passwordPlaceholder", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Profile
      ///
      /// Locales: en, ru
      static let profileControllerTitle = Rswift.StringResource(key: "profileControllerTitle", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Sign In
      ///
      /// Locales: en, ru
      static let signInButtonTitle = Rswift.StringResource(key: "signInButtonTitle", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)
      /// en translation: Unfollow
      ///
      /// Locales: en, ru
      static let unfollowButtonTitle = Rswift.StringResource(key: "unfollowButtonTitle", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "ru"], comment: nil)

      /// en translation: Feed
      ///
      /// Locales: en, ru
      static func feedControllerTitle(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("feedControllerTitle", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "feedControllerTitle"
        }

        return NSLocalizedString("feedControllerTitle", bundle: bundle, comment: "")
      }

      /// en translation: Follow
      ///
      /// Locales: en, ru
      static func followButtonTitle(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("followButtonTitle", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "followButtonTitle"
        }

        return NSLocalizedString("followButtonTitle", bundle: bundle, comment: "")
      }

      /// en translation: Followers: 
      ///
      /// Locales: en, ru
      static func followersLabelTitle(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("followersLabelTitle", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "followersLabelTitle"
        }

        return NSLocalizedString("followersLabelTitle", bundle: bundle, comment: "")
      }

      /// en translation: Following: 
      ///
      /// Locales: en, ru
      static func followedLabelTitle(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("followedLabelTitle", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "followedLabelTitle"
        }

        return NSLocalizedString("followedLabelTitle", bundle: bundle, comment: "")
      }

      /// en translation: Likes: 
      ///
      /// Locales: en, ru
      static func likesCountLabel(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("likesCountLabel", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "likesCountLabel"
        }

        return NSLocalizedString("likesCountLabel", bundle: bundle, comment: "")
      }

      /// en translation: Log out
      ///
      /// Locales: en, ru
      static func logOutButtonTitle(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("logOutButtonTitle", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "logOutButtonTitle"
        }

        return NSLocalizedString("logOutButtonTitle", bundle: bundle, comment: "")
      }

      /// en translation: Login
      ///
      /// Locales: en, ru
      static func loginPlaceholder(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("loginPlaceholder", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "loginPlaceholder"
        }

        return NSLocalizedString("loginPlaceholder", bundle: bundle, comment: "")
      }

      /// en translation: New post
      ///
      /// Locales: en, ru
      static func newPostControllerTitle(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("newPostControllerTitle", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "newPostControllerTitle"
        }

        return NSLocalizedString("newPostControllerTitle", bundle: bundle, comment: "")
      }

      /// en translation: Password
      ///
      /// Locales: en, ru
      static func passwordPlaceholder(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("passwordPlaceholder", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "passwordPlaceholder"
        }

        return NSLocalizedString("passwordPlaceholder", bundle: bundle, comment: "")
      }

      /// en translation: Profile
      ///
      /// Locales: en, ru
      static func profileControllerTitle(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("profileControllerTitle", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "profileControllerTitle"
        }

        return NSLocalizedString("profileControllerTitle", bundle: bundle, comment: "")
      }

      /// en translation: Sign In
      ///
      /// Locales: en, ru
      static func signInButtonTitle(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("signInButtonTitle", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "signInButtonTitle"
        }

        return NSLocalizedString("signInButtonTitle", bundle: bundle, comment: "")
      }

      /// en translation: Unfollow
      ///
      /// Locales: en, ru
      static func unfollowButtonTitle(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("unfollowButtonTitle", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "unfollowButtonTitle"
        }

        return NSLocalizedString("unfollowButtonTitle", bundle: bundle, comment: "")
      }

      fileprivate init() {}
    }

    fileprivate init() {}
  }

  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }

    fileprivate init() {}
  }

  fileprivate class Class {}

  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    #if os(iOS) || os(tvOS)
    try storyboard.validate()
    #endif
  }

  #if os(iOS) || os(tvOS)
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      #if os(iOS) || os(tvOS)
      try launchScreen.validate()
      #endif
    }

    #if os(iOS) || os(tvOS)
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController

      let bundle = R.hostingBundle
      let name = "LaunchScreen"

      static func validate() throws {
        if UIKit.UIImage(named: "LaunchScreen", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'LaunchScreen' is used in storyboard 'LaunchScreen', but couldn't be loaded.") }
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
      }

      fileprivate init() {}
    }
    #endif

    fileprivate init() {}
  }
  #endif

  fileprivate init() {}
}
