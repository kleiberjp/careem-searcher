# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'
source 'https://github.com/cocoaPods/specs.git'
inhibit_all_warnings!
use_frameworks!

def reactive
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxCoreData'
    pod 'RxAlamofire'
end

def ui
    pod 'IGListKit'
    pod 'Nuke'
end

def testing
    pod 'RxBlocking'
    pod 'RxTest'
end


target 'CareemSearcher' do
   reactive
   ui

  target 'CareemSearcherTests' do
    inherit! :search_paths
    reactive
    testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.1'
            config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
            config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
            config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
        end
    end
end
