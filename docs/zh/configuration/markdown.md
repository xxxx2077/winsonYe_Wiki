# Markdown

A tutorial for Markdown & Markdown(Mkdocs of Material)

好吧，我是一个很懒的人，把链接贴出来算了。

## 基础语法

[Markdown基础语法](https://markdown.com.cn/basic-syntax/ "markdown教程")

[Markdown拓展语法](https://markdown.com.cn/extended-syntax/fenced-code-blocks.html "Markdown拓展语法")

!!! note

    其实拓展语法最有用的仅仅是代码块如何写，也就是：
    ```markdown
        ```json
        {
            "firstName":"Jack",
            "age":25
        }
        ```
    ``` 

**创建文章内锚点**
```markdown
## 这是第一个标题

我要说一句话 [话的内容1](#话)

// 如果锚点目标是标题，直接使用`#<标题名>`

## 话

我要说第二句话 [话的内容2](#sentence)

第二句话是：<a id="sentence">这是一句话</a>

```

效果如下：

**创建文章内锚点**
## 这是第一个标题

我要说一句话 [话的内容1](#话)

// 如果锚点目标是标题，直接使用`#<标题名>`

## 话

我要说第二句话 [话的内容2](#sentence)

第二句话是：<a id="sentence"></a>这是一句话

## Markdown for Mkdocs

!!! quote

    [官方链接](https://squidfunk.github.io/mkdocs-material/reference/admonitions/)

!!! warning "踩坑指南"

    mkdocs采用的是python-markdown解释器，它的语法为[python-markdown syntax](https://daringfireball.net/projects/markdown/syntax#precode)

    里面的解析会涉及很多问题，和平常的markdown不一样

    详情见[mkdocs踩坑大全](#mkdocs踩坑大全)

    
我列举几个我常用的

### card

```Markdown
    !!! note
        this is a note
```
效果为：

!!! note

    this is a note

添加标题：

!!! note "Here is a title"

    this is a note

没有标题：

!!! note ""

    this is a note

可展开形式：

??? note

    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et euismod
    nulla. Curabitur feugiat, tortor non consequat finibus, justo purus auctor
    massa, nec semper lorem quam in massa.

???+note

    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et euismod
    nulla. Curabitur feugiat, tortor non consequat finibus, justo purus auctor
    massa, nec semper lorem quam in massa.

同理其他有：

!!! abstract

    This is a abstract

!!! info

    This is a info

!!! tip

    This is a tip

!!! success

    This is a success

!!! question

    This is a question

!!! warning

    This is a warning

!!! danger

    This is a danger

!!! bug

    This is a bug

!!! example

    This is an example

!!! quote

    This is a quote

### code block

!!! note "多种语言代码块"

    ```markdown
    === "C"

        ```C
        void hello(){
            printf("hello,world\n");
        }
        ```

    === "C++"

        ```C++
        void hello(){
            cout << "hello,world" << endl;
        }
        ```
    ```

效果为：

=== "C"

    ```C
    void hello(){
        printf("hello,world\n");
    }
    ```

=== "C++"

    ```C++
    void hello(){
        cout << "hello,world" << endl;
    }
    ```

!!! note "代码高亮"

    ```markdown

        === "指定某几行"

            ```C++ title="这是这段代码的标题" hl_lines="1 3"
            void hello(){
                cout << "hello,world" << endl;
            }
            ```

        === "指定某几行之间"
        

            ```C++ title="这是这段代码的标题" hl_lines="2-3"
            void hello(){
                cout << "hello,world" << endl;
            }
            ```

        === "显示行号"

            形如`linenums="<startnum>",startnum表示起始行数

            ```C++ linenum = "1" // (1)
            void hello(){
                cout << "hello,world" << endl;
            }
            ```

            1. 这里的“1”表示的是代码块的起始数字

    ```

=== "指定某几行"

    ```C++ title="这是这段代码的标题" hl_lines="1 3"
    void hello(){
        cout << "hello,world" << endl;
    }
    ```

=== "指定某几行之间"


    ```C++ title="这是这段代码的标题" hl_lines="2-3"
    void hello(){
        cout << "hello,world" << endl;
    }
    ```


=== "显示行号"


    ```C++ linenums="1" 
    void hello(){
        cout << "hello,world" << endl; //(1)
    }
    ```

    1. this is a comment.



### mkdocs踩坑大全

#### 有序列表/无序列表嵌套

!!! tip "嵌套方法"

    一级列表和二级列表之间需要相隔一行，二级列表之间也要相隔一行


!!! bug

    有序列表/无序列表不能嵌套超过两层


!!! example 

    例如：

    ```markdown
    1.  line1
        
        -   item1。
        
        -   item2
            
            1. item_line1

            2. item_line2   
            
            3. item_line3
        
        -   item3
    ```
    效果如下：

    1.  line1
        
        -   item1。
        
        -   item2
            
            1. item_line1

            2. item_line2   
            
            3. item_line3
        
        -   item3

    你会发现item_line*都变成了代码块，这是因为python-markdown的脑残设定（规定2个tab/8个空格产生代码块），然后我们的有序/无序列表嵌套导致了2个tab/8个空格，因此产生了代码块

!!! success "solution"

    为了避免这种情况，我们能做的只有：减少嵌套层数，控制在两层以内，避免产生2个tab/8个空格
