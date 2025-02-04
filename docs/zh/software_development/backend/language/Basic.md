# Before learning a new language

本节内容介绍如何快速学习一个语言

## 变量

### 声明和定义

> **声明（Declaration）**
>
> 声明是告诉编译器某种标识符的存在及其类型，但不一定分配内存或提供实现。例如，你可以声明一个变量、函数或类型，而不立即定义它。
>
> **定义（Definition）**
>
> 定义不仅声明了标识符，还为其分配了存储空间或提供了具体的实现。对于变量，这意味着为它分配内存；对于函数，这意味着提供其实现。
>

该语言如何声明一个变量/函数，如何定义一个变量/函数，声明和定义是否同时发生？

【例】

C++语言中声明和定义可以不同时发生

```C++
extern int a; //只声明不定义
int a; //声明 + 定义
```

Go语言中声明和定义同时发生，即使没有显式定义，Go也会默认赋予零值

```go
var a int // 声明 + 隐式定义（零值）
a := 2 // 声明 + 显式定义
```

