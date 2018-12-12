source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'
use_frameworks!

target 'FA-NOC-iOS' do

  	pod 'RxSwift', '~> 4.0'
    pod 'RxCocoa', '~> 4.0'
    pod 'RxAnimated'
    pod 'RxDataSources'
    pod 'RxGesture'
    pod 'RxKeyboard'
    pod 'RxOptional'
    pod 'RxFlow'
    pod 'NSObject+Rx'
    pod 'RxAlamofire'

    pod 'Kingfisher'
    pod 'SwiftyJSON'
    pod 'ObjectMapper'

    pod 'Hero'
    pod 'Hue'
    pod 'PKHUD'
    pod 'SwiftMessages'
    pod 'Atributika'
    pod 'BadgeSwift'
    pod 'NewPopMenu'
    pod 'SkeletonView'
    pod 'SnapKit'
    pod 'Floaty'
    pod 'LGButton'

    pod 'AsyncSwift'
    pod 'SwiftDate'
    pod 'DifferenceKit'

    pod 'WeakableSelf'
    pod 'SwiftSoup'


  target 'FA-NOC-iOSTests' do
    inherit! :search_paths
    
    pod 'Quick'
    pod 'Nimble'
    pod 'Mockingjay'
    pod 'Swinject'
  end

  target 'FA-NOC-iOSUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'RxSwift'
            target.build_configurations.each do |config|
                if config.name == 'Debug'
                    config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
                end
            end
        end
    end
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
