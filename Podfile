# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'
# Uncomment this line if you're using Swift
# use_frameworks!

source 'https://github.com/gini/gini-podspecs.git'
source 'https://github.com/CocoaPods/Specs.git'

target 'gini-demo' do
    pod 'GiniVisionSDK'
    pod 'Gini-iOS-SDK'
end

target 'gini-demoTests' do

end

target 'gini-demoUITests' do

end

post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods-gini-demo/Pods-gini-demo-acknowledgements.plist', 'gini-demo/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end