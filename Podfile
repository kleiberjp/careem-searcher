# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'
source 'https://github.com/cocoaPods/specs.git'
inhibit_all_warnings!
use_frameworks!

def reactive
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxCoreData'
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
