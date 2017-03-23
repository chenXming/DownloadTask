# DownloadVideo
基于大神WHC的多线程下载解决方案。我这边发现了几个Bug，做了下修改，所以只是拾人牙慧。Demo已经可以满足工程级别的下载需求了（支持断点续传、多任务并发下载、暂停、取消、删除任务）你可以下载下来做满足自己业务需求的更改。<br>使用的主要方法：<br>
```OC
/**
 * 说明: 执行下载任务
 * @param strUrl 下载地址
 * @param savePath 下载缓存路径
 * @param saveFileName 下载保存文件名
 * @param responseBlock 下载响应回调
 * @param processBlock 下载过程回调
 * @param didFinishedBlock 下载完成回调
 */

- (nullable WHC_DownloadOperation *)download:(nonnull NSString *)strUrl
                                    savePath:(nonnull NSString *)savePath
                                saveFileName:(nullable NSString *)saveFileName
                                    response:(nullable WHCResponse) responseBlock
                                     process:(nullable WHCProgress) processBlock
                                 didFinished:(nullable WHCDidFinished) finishedBlock;

```
设置并发下载任务数：
```OC
//默认下载并发数量 在这里修改(WHC_HttpManager类)
const NSInteger kWHCDefaultDownloadNumber = 1;
```
感觉好用的话给个star吧^_^。大神的Github地址：[WHC](https://github.com/netyouli)
