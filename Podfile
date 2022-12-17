# Uncomment the next line to define a global platform for your project
#source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '12.0'

target 'CoronaApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

 
  # Pods for CoronaApp
  pod 'FSCalendar'
  pod 'CalculateCalendarLogic'
  pod 'Charts' 
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Core'
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift'
  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end
  pod 'MessageKit'
  pod 'MessageInputBar'
  pod 'PKHUD'

  target 'CoronaAppTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'CoronaAppUITests' do
    # Pods for testing
  end

end
