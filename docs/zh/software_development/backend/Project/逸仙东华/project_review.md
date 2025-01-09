# Backend notice

> 本文档介绍后端开发中遇到的问题和解决方法/经验

## Topic 1: 加水印

### Problem 1: 加水印大小自适应问题

实现加水印过程中，我们发现用户的文件页面大小不一（比如在同一个pdf中，存在页面非常大的封面页和页面正常的内容也），不能仅仅通过创建一个水印页面适用于所有页面，否则会造成水印位置偏移等水印效果不好的情况

对于这种情况，我们尝试了多个办法

### Solution 1：单线程创建自适应pdf

> 相关代码在`create_watermark_adapted_singleThread`和`add_watermark_file_singleThread`

我们尝试创建一个多页的水印pdf，该pdf每一页的大小与对应输入pdf的每一页大小相同，从而实现自适应

代码示例如下：

思路为：将多个水印页面合并在一个pdf内

```python
    for i in range(pageNum):
        page = pdf_input.getPage(i)
        page_width = float(page.mediaBox.getWidth())
        page_height = float(page.mediaBox.getHeight())
        pageSize=(page_width,page_height)
        pdf_watermark_data=create_watermark(content,pageSize)
        pdf_watermark_singleFile = PdfFileReader(BytesIO(pdf_watermark_data), strict=False)
        pdf_watermark_singleFilePage = pdf_watermark_singleFile.getPage(0)
        pdf_watermark_singleFilePage.compressContentStreams()
        pdf_watermark_file.addPage(pdf_watermark_singleFilePage)
```

### Problem 2：加水印过慢

解法1能解决自适应水印页面问题，但会造成加水印速度过慢，于是我们想通过多线程加速

### Solution 2：多线程创建自适应pdf

> 相关代码在`create_watermark_adapted_multiThread`和`add_watermark_file_multiThread`

我们通过创建线程池，对创建水印的行为进行并行操作

```python
page_results=pool.map(create_watermark_adapted_multiThread,content_list,page_list)  
```

遗憾的是，我们发现线程池并不会显著加速加水印（仅仅加速了3s，对于60s的总时间来说显然不够）

通过测速，我们发现时间主要消耗：将水印文件和输入文件合并的操作中的addPage函数，由于需要保障输出文件的有序性，addPage无法避免，因此我们也放弃了这种方法

### Solution 3：只考虑两种情况

> 相关代码在`create_watermark`

相比于之前的方法，我们最后为了缩短下载时间选择了不那么全面的解法：我们暂时只考虑两种情况（书籍PDF和普通PDF）

书籍PDF有个显著特点：前两页为封面页，页面比较大；后面为内容页，页面比较小

普通PDF则全部页面大小都相同

因此我们用以下代码解决以上两种情况：

我们只取第一页和第三页，对其大小进行比较，取最小页面大小，从而实现水印兼容

由于水印文件只有一页，所以大大缩短了加水印的时间

```
# 获得封面页尺寸
    page = pdf_input.getPage(0)
    page_width = float(page.mediaBox.getWidth())
    page_height = float(page.mediaBox.getHeight())
    pageSize=(page_width,page_height)

    if pageNum > 3:
        page = pdf_input.getPage(0)
        page_width = min(page_width,float(page.mediaBox.getWidth()))
        page_height = min(page_height,float(page.mediaBox.getHeight()))
        pageSize=(page_width,page_height)
```

### Solution 4: LRU优化下载

我们发现下载文件也是个非常耗时的过程，但这个主要是因为网速太慢。为了优化下载的时间，我们选择使用LRU算法实现下载API。

LRU原理如下链接：

[全面讲解LRU算法-CSDN博客](https://blog.csdn.net/belongtocode/article/details/102989685)



### Solution 5: 等你解决

看看后来人有没有办法能够更好地解决

## Topic 2：`Exception`

### Problem：

如果按下面代码执行，会出现直接触发`except Exception as e`中的`Exception`，导致无法显示正确的报错信息

```python
    try:
            bucket_name = BUCKET_NAME
            # 读取要加水印的文件
            pdf_data = minio_messenger.download(bucket_name, fuuid).read()
            if pdf_data is None:
                raise response_400(data='下载文件失败') 
            pdf_size = len(pdf_data)

            pdf_input = PdfFileReader(BytesIO(pdf_data), strict=False)
            if pdf_input is None:
                raise response_400(data='下载文件读取失败') 
            
            # 编辑水印内容
            mark_content = current_user.nickName+current_user.phone

            if pdf_size <= ignore_watermark*1024*1024:
                # 创建水印
                create_watermark(pdf_input,mark_content,fuuid,current_user.SNo)                              
                return response_200(data='水印已添加')
            else:
                # 对输出文件命名
                output_filename = f'{fuuid}_{current_user.SNo}_output.pdf'
                output_filepath = os.path.join(os.path.dirname(__file__), f'../../watermark/{output_filename}')
                with open(output_filepath,'wb') as output_file:
                    # 将 PdfFileWriter 中的页面写入到 BytesIO 对象
                    output_file.write(pdf_data)
                return response_200(data='不需要添加水印')
    except Exception as e:
        raise response_400(data = str(e))
```

例如：

```python
pdf_data = minio_messenger.download(bucket_name, fuuid).read()
	if pdf_data is None:
       raise response_400(data='下载文件失败') 
```

如果download失败不会返回错误信息'下载文件失败'，而是直接返回系统自己报的错误（通常是英文），表示没有成功raise response

### Solution：

我们添加一个捕获自定义`HTTPException`的代码，当代码遇到特定判断时，会raise response（response核心是返回`HTTPException`），所以这段代码会捕获response，然后将其返回这个response

如果按上面Problem的写法，会导致`Exception`里面有`response_400`，自然不会报`response_400`

```python
    # 不拦截自定义的HTTPException
    except HTTPException as e:
        raise e
```

完整代码如下：

```python
    try:
            bucket_name = BUCKET_NAME
            # 读取要加水印的文件
            pdf_data = minio_messenger.download(bucket_name, fuuid).read()
            if pdf_data is None:
                raise response_400(data='下载文件失败') 
            pdf_size = len(pdf_data)

            pdf_input = PdfFileReader(BytesIO(pdf_data), strict=False)
            if pdf_input is None:
                raise response_400(data='下载文件读取失败') 
            
            # 编辑水印内容
            mark_content = current_user.nickName+current_user.phone

            if pdf_size <= ignore_watermark*1024*1024:
                # 创建水印
                create_watermark(pdf_input,mark_content,fuuid,current_user.SNo)                              
                return response_200(data='水印已添加')
            else:
                # 对输出文件命名
                output_filename = f'{fuuid}_{current_user.SNo}_output.pdf'
                output_filepath = os.path.join(os.path.dirname(__file__), f'../../watermark/{output_filename}')
                with open(output_filepath,'wb') as output_file:
                    # 将 PdfFileWriter 中的页面写入到 BytesIO 对象
                    output_file.write(pdf_data)
                return response_200(data='不需要添加水印')
    # 不拦截自定义的HTTPException
    except HTTPException as e:
        raise e
    # 拦截预料之外的异常
    except Exception as e:
        raise response_400(data = str(e))
```

## Topic 3：`ES search`

### Problem: must和should冲突

这是一开始的写法

我们发现搜索的时候只满足了must的条件，而should似乎被忽略了

```
body = {
                # 当前页数据的起始位置=页码（从0开始）*每页数据条数
                "from": page*10,
                # 每页查询的数据条数
                "size": 10, 
                "query": {
                    "bool": {
                        "must": [
                            { "term": {"fCate": type } }
                        ]                
                        "should": [ 
                             { "match": {"fName": keyword } },
                             { "match": {"fIntro": keyword } },
                             { "match": {"fTag": keyword } }
                        ]}
                    }
                }
```

查网发现，must和should不能同级，正如`a==1&&b==1||b==2`不能用于表示“满足a==1的前提下，b取1或2”，而是改为`a==1&&(b==1||b==2)`；

即must和should不能同级正如&&和||不能同级

### Solution

```python
body = {
                # 当前页数据的起始位置=页码（从0开始）*每页数据条数
                "from": page*10,
                # 每页查询的数据条数
                "size": 10, 
                "query": {
                    "bool": {
                        "must": [
                            { "term": {"fCate": type } },
                            {
                                "bool":{
                                    "should": [ 
                                        { "match": {"fName": keyword } },
                                        { "match": {"fIntro": keyword } },
                                        { "match": {"fTag": keyword } }
                                ]}
                            }
                        ]                
                    }
                }
```

