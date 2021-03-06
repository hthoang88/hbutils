#
#  Be sure to run `pod spec lint hbutils.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "hbutils"
  spec.version      = "1.0.0"
  spec.summary      = "This is the utilities project of Hoang Ho"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  spec.description  = <<-DESC
The UYLPasswordManager class provides a simple wrapper around Apple Keychain
    Services on iOS devices. The class is designed to make it quick and easy to
    create, read, update and delete keychain items. Keychain groups are also
    supported as is the ability to set the data migration and protection attributes
    of keychain items.
                   DESC

  spec.homepage     = "https://github.com/hthoang88/hbutils"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See https://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  spec.license      = { :type => "MIT", :file => "LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  spec.author             = { "Hoang" => "hthoang88@gmail.com" }
  # Or just: spec.author    = "Hoang"
  # spec.authors            = { "Hoang" => "email@address.com" }
  # spec.social_media_url   = "https://twitter.com/Hoang"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  spec.platform     = :ios, "9.0"

  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  spec.source       = { :git => "https://github.com/hthoang88/hbutils.git", :tag => "v#{spec.version}" }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

spec.subspec 'BaseClasses' do |ss|
    ss.platform = :ios, '9.0'
    ss.ios.source_files = 'Classes/BaseClasses/*.{h,m}'
end

spec.subspec 'Categories' do |ss|
    ss.platform = :ios, '9.0'
    ss.ios.source_files = 'Classes/Categories/*.{h,m}'
end

spec.subspec 'Extobjc' do |ss|
    ss.platform = :ios, '9.0'
    ss.ios.source_files = 'Classes/Extobjc/*.{h,m}'
end

spec.subspec 'FastEasyMapping' do |ss|
    ss.platform = :ios, '9.0'
    ss.ios.source_files = "Classes/FastEasyMapping/**/*.{h,m}"
end

spec.subspec 'Others' do |ss|
    ss.platform = :ios, '9.0'
    ss.ios.source_files = 'Classes/Others/*.{h,m}'
end

spec.subspec 'SIAlertView' do |ss|
    ss.platform = :ios, '9.0'
    ss.ios.source_files = "Classes/SIAlertView/*.{h,m}"
end

  # spec.source_files  = "Classes", "Classes/*.{h,m}", "Classes/*/*.{h,m}"

  # spec.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  spec.resource  = "Classes/SIAlertView/*.bundle"
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # spec.vendored_frameworks = 'GoogleMobileAds'
  # spec.xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => 'HBUtils/VendoredFrameworks' }
  # spec.framework  = "GoogleMobileAds"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"
    spec.dependency 'MagicalRecord'
    spec.dependency 'PureLayout'
    spec.dependency 'AFNetworking', '3.1.0'
    spec.dependency 'MZFormSheetPresentationController', '~> 2.4.2'
    spec.dependency 'MBProgressHUD', '~> 0.9.1'
    spec.dependency 'SDWebImage'
    spec.dependency 'UIActivityIndicator-for-SDWebImage'
    spec.dependency 'UIScrollView-InfiniteScroll'
    spec.dependency 'WYPopoverController'
    spec.dependency 'iRate'
end
