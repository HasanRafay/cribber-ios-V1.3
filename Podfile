source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target 'Cribber' do
    pod 'SVProgressHUD'
    pod 'Alamofire', '~> 2.0'
    pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON'
    pod 'SDWebImage'
    pod 'Locksmith'
    pod 'libPhoneNumber-iOS'
    pod 'HTTPStatusCodes'
    pod 'Parse'
    pod 'NewRelicAgent'
    pod 'Reachability'
    pod 'SnapKit'
    pod 'Google/Analytics'
    pod 'TTTAttributedLabel'
    pod 'SevenSwitch', '~> 2.0'
end

target 'CribberTests' do

end

post_install do |installer|
    app_plist = "Cribber/Cribber-Info.plist"
    plist_buddy = "/usr/libexec/PlistBuddy"
    version = `#{plist_buddy} -c "Print CFBundleShortVersionString" #{app_plist}`.strip
    puts "Updating CocoaPods' version numbers to #{version}"

    installer.pods_project.targets.each do |target|
        `#{plist_buddy} -c "Set CFBundleShortVersionString #{version}" "Pods/Target Support Files/#{target}/Info.plist"`
    end
end
