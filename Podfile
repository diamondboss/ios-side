# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
# Uncomment this line if you're using Swift
# use_frameworks!

target 'DiamondBoss' do

#去掉由pod引入的第三方库的警告, 需要使用更新命令才生效
inhibit_all_warnings!

#把系统的target+selector/委托模式 转为 Block语法,让代码结构更加紧凑
#pod 'BlocksKit'

#对系统原生的AutoLayout的NSLayoutConstraints类的封装,优雅的链式语法,Github排名第三
#pod 'Masonry'

#为滚动控件(UIScrollView,UITableView,UICollectionView)添加头部和脚部刷新UI
pod 'MJRefresh'

#为UI控件提供网络图片加载和缓存功能,AF已经整合了此功能,一般用AF就够了,据专业人士说:SD比AF快0.02秒. 如果同时引入AF和SD, 那么AF的网络图片加载方法会被划线.
pod 'SDWebImage'

#对系统Sqlite的封装,使用SQL语句操作数据库
#pod 'FMDB'

#Github排名第一的网络操作框架,底层是用NSURLSession+NSOperation(多线程)
pod 'AFNetworking'


#侧边栏--参考QQ的侧边栏
#pod 'RESideMenu'
pod 'MBProgressHUD', '~> 1.0.0'
#专门用于转换Array/Dictionary -> 对象模型, 主要用于JSON解析,基本上工作都用这个框架(必会)
#pod 'MJExtension'

#对NSLog进行的封装,效率比NSLog高,大量打印不卡顿,可以分级打印
#pod 'CocoaLumberjack'

#把json里面的数据空值置为nil
pod 'NullSafe', '~> 1.2.2'

#高德地图
pod 'AMap3DMap'
pod 'AMapSearch'

pod 'RongCloudIM/IMKit', '~> 2.8.3'

pod 'GTSDK', '1.6.4.0-noidfa'

pod 'AliyunOSSiOS'


#Gif
pod 'FLAnimatedImage', '~> 1.0'
end

target 'DiamondBossTests' do

end

target 'DiamondBossUITests' do

end
