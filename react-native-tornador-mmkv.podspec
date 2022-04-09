# react-native-tornador-mmkv.podspec

require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-tornador-mmkv"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-tornador-mmkv
                   DESC
  s.homepage     = "https://github.com/yaaliuzhipeng/react-native-tornador-mmkv"
  # brief license entry:
  s.license      = "MIT"
  # s.license    = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { "yaaliuzhipeng" => "yaaliuzhipeng@outlook.com" }
  s.platforms    = { :ios => "11.0" }
  s.source       = { :git => "https://github.com/yaaliuzhipeng/react-native-tornador-mmkv.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,c,cc,cpp,m,mm,swift}"

  # Any private headers that are not globally unique should be mentioned here.
  # Otherwise there will be a nameclash, since CocoaPods flattens out any header directories
  # See https://github.com/firebase/firebase-ios-sdk/issues/4035 for more details.
  s.preserve_paths = "ios/**/*.h"

  s.requires_arc = true

  s.dependency "React"
  s.dependency "MMKV", "1.2.13"
  # s.dependency "..."
end

