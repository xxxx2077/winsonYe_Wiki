# 控制流语句

## if语句

Go的if语句与C++不同，它能添加一个自定义变量语句（例如下述代码中的`v:="test"`），这个部分是可选的。

自定义变量语句部分拥有一个词法域，该**词法域大于if/else if/else中的花括号词法域**。即下述代码`v:="test"`能在if/else if/else花括号内使用

```go
package main

import "fmt"

func main() {
	x := -1
	if v := "test"; x > 1 {
		fmt.Println(v) // "test"
		v := "test1"
		fmt.Println(v) // "test1"
		fmt.Println(a)
		fmt.Println(b) // undefined: b
		fmt.Println(c) // undefined: c
	} else if x > 0 {
		fmt.Println(v) // "test"
		v := "test2"
		fmt.Println(v) // "test1"
		b := 2
		fmt.Println(a) // undefined: a
		fmt.Println(b)
		fmt.Println(c) // undefined: c
	} else {
		fmt.Println(v) // "test"
		v := "test3"
		fmt.Println(v) // "test1"
		c := 3
		fmt.Println(a) // undefined: a
		fmt.Println(b) // undefined: b
		fmt.Println(c)
	}
}
```

## 其他

以下链接写的蛮详细的了

[控制流语句参考](https://www.topgoer.com/%E6%B5%81%E7%A8%8B%E6%8E%A7%E5%88%B6/)