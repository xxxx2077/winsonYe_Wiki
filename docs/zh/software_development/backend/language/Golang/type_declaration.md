# 类型Type

## 为什么需要type

type定义了variable存储的value的属性：

- 存储空间大小（numbers of the bits/ numbers of the element...）
- 存储结构/内部如何表示（representation of the value）
- 支持哪些操作符
- 拥有哪些方法

Go提供的type更多是作为底层数据结构。

然而，在日常使用中，我们会对相同底层数据结构赋予不同的意义，比如说`int x`，我们可以说x表示年龄，也可以说表示学生的个数等等。

自己定义type能够帮助我们为类型赋予实际应用意义，而不是底层存储层面的。

举个例子，相同float底层类型可以表示两种不同的温度计量，这两种type虽然底层存储类型（underlying type）相同，但是Go仍将其视为完全不同的type

```go
type Celsius float64
type Fahrenheit float64

var c Celsius
var f Fahrenheit
fmt.Println(c == 0) // "true"
fmt.Println(f >= 0) // "true"
fmt.Println(c == f) // compile error: type mismatch
fmt.Println(c == Celsius(f)) // "true"!
```

## 自定义type

自定义语法为：

```go
type new_name underlying_type
```

意义：

1. 为相同underlying_type赋予不同的实际应用意义，防止程序员犯错（例如程序员不需要考虑哪个float对应什么温度，直接通过type就能辨别）
2. 对复杂的type取别名

    经典例子：`Student`就是给`struct{string, int}`取了个别名type

    ```go
    package main

    import "fmt"

    type Student struct {
        Name string
        Age  int
    }

    func main() {
        var a struct {
            Name string
            Age  int
        }

        a.Name = "Alice"
        a.Age = 18

        var b Student

        b.Name = "Alice"
        b.Age = 18

        fmt.Println(a == b) // true

    }

    ```

    a和b的类型完全相同

3. 在underlying_type提供的方法基础上，增加更多方法，并让这些方法与类型绑定

## type之间的转换

对于类型为T的变量x，如果想转换为类型为S的变量，只需要使用以下语法：

```go
var x T
var v S
v = S(x)
```

有两种转换：

1. 无损转换：两种type之间拥有相同的underlying type/两种type都为指针类型，指向相同type的变量。这时候两种type之间的转换(conversion)只改变type的名字，不改变内部存储的值
2. 有损转换：两种type之间拥有不同的underlying type，**转换不会引起编译错误，但是会导致值精度损失。**

    例如：
    ```go
    package main

    import "fmt"

    func main() {
        var a int
        var b float32
        b = 2.4
        a = int(b)
        fmt.Println(a)
    }
    ```





    

- 


