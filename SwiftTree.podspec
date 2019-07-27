#
#  Be sure to run `pod spec lint SwiftTree.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.platform = :ios
  spec.framework = "UIKit"
  spec.ios.deployment_target = '12.0'
  spec.requires_arc = true
  spec.name         = "SwiftTree"
  spec.version      = "1.0.0"
  spec.summary      = "SwiftTree is a lightweight framework to create trees from a string on the basis of AND, OR and NOT gate."
  spec.description  = "SwiftTree is a lightweight framework to create trees from a string on the basis of AND, OR and NOT gate."
  spec.homepage     = "https://github.com/ApoorvSuri/ApoorvSuri"
  spec.license      = "MIT"
  spec.author             = { "Apoorv Suri" => "apoorvsuri2012@gmail.com" }
  spec.source       = { :git => "https://github.com/ApoorvSuri/SwiftTree.git", :tag => "1.0.0" }
  spec.source_files  = "SwiftTree/**/*.{swift}"
  spec.resources = ["*.{xib}"]
  spec.swift_version = "4.2"
  spec.dependency "KebabMenuView"
end
