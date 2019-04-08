# YLControllerName
显示当前控制器的类名，如果有子类控制器，附加显示最顶部子类控制器名。
## 使用方法 
1. Pod 安装  
`pod search YLControllerName`  
如果搜索不到，请先执行  
`pod setup`  
如果还没有搜索成功终端输入  
`rm ~/Library/Caches/CocoaPods/search_index.json`   
删除成功后再执行  
`pod search YLControllerName`  
podfile 文件填写  
`pod 'YLControllerName', :configuration => 'Debug'`  
2. 直接拖到项目里面
