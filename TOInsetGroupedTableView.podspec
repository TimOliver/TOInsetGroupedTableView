Pod::Spec.new do |s|
  s.name     = 'TOInsetGroupedTableView'
  s.version  = '1.1.0'
  s.license  =  { :type => 'MIT', :file => 'LICENSE' }
  s.summary  = 'An iOS 11 back-port of the grouped inset table view style in iOS 13.'
  s.homepage = 'https://github.com/TimOliver/TOInsetGroupedTableView'
  s.author   = 'Tim Oliver'
  s.source   = { :git => 'https://github.com/TimOliver/TOInsetGroupedTableView.git', :tag => s.version }
  s.platform = :ios, '11.0'
  s.source_files = 'TOInsetGroupedTableView/**/*.{h,m}'
  s.requires_arc = true
end
