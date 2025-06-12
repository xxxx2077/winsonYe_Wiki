# 赋值

## 核心特性

只需要记住以下式子：

```go
i, j = j, i
```

该表达式计算顺序如下：

1. 先计算等号右边的所有表达式的值
2. 再值对应赋予等号左边的变量

因此以上式子等价于

```go
t := i
i = j
j = t
```

作用是交换i和j的值

## 其他特性

等号左边可以有多个值

![picture 0](assets_IMG/assignment/IMG_20250612-120045622.png)  

可以用下划线省略某个值

![picture 1](assets_IMG/assignment/IMG_20250612-120055415.png)  
