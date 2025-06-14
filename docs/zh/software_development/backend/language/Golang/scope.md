# 作用域

为什么会有作用域？

编译器遇到一个名字，会寻找其对应的declaration，将名字与declaration绑定。如果找到，则通过declaration得知这个名字对应的信息（是变量还是函数还是...）；如果没有找到，则认为这个名字不可用（因为名字没有对应的declaration）

## 作用域与生命周期的区别

作用域（scope）：编译期，名字的有效范围（程序文本范围）/可见性（visibility）

PS: 词法域（lexical scope）指文本层面的范围，比如说程序第x行到第y行。作用域可以用词法域表示。

生命周期（lifetime）：运行时，变量存在的有效时间段，这段时间，该变量能被其他变量引用

## 作用域特性

> 作用域指的是名字的有效范围（程序文本范围）

### 作用域作用范围

通常来说，花括号包围的范围，我们称之为词法块（lexical block）

词法块对应一个单独的作用域，词法块内的declaration无法被外部词法块使用

作用域范围从大到小：

- 程序内置类型，名字当然也是程序全局有效的（universe scope），例如`int`，`true`
- 包级别变量（函数外部声明的变量，package-level variable），分两种情况：
  - 首先无论首字母大小写，名字有效范围至少为包内的所有文件；
  - 如果首字母大写，则名字有效范围可以更大，因为其能被其他包使用
- 导入的包名字，只能在当前文件使用，其他文件由于没有导入，无法使用（例如fmt包）
- break/continue/goto仅在函数内有效

### 显式作用域与隐式作用域

显式作用域：花括号包围的词法块

隐式作用域：例如for语句由三个词法域：条件测试部分和循环后的迭代部分（i++），当然也包含循环体词法域。

```go
if x := f(); x == 0 {
    fmt.Println(x)
} else if y := g(x); x == y {
    fmt.Println(x, y)
} else {
    fmt.Println(x, y)
}
fmt.Println(x, y) // compile error: x and y are not visible here
```

!!! tip 

    Go的控制语句有点不同，详见[控制流语句](./control-flow_statesment.md)

### 作用域优先级

词法域可以嵌套

编译器遇到一个名字，从内到外寻找declaration