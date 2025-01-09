# C++

## 面向对象

面向对象基本三要素：封装、继承、多态

- 封装：隐藏对象内部细节，实现模块化
  - 实现方式：通过控制访问权限public , protected,  private
- 继承：通过继承实现功能的扩展
  - 继承方式：public, protected, private控制最高访问权限
  - 接口继承：通过纯虚函数实现抽象类，抽象类就是接口
- 多态：一个接口，多种形态

面向过程和面向对象的区别和联系

- 面向过程：将事情分解为若干个步骤，每个步骤用函数实现，然后按照一定的顺序执行函数
  - 流程化，编程步骤明确
  - 代码重用性低，扩展能力差
- 面向对象：将事务抽象为对象，给对象赋予属性和方法，将事情拆分成不同模块，每个模块由对应的对象执行相应的动作
  - 代码重用率高，扩展能力好
  - 低耦合，易维护
  - 开销大（因为要增加很多无用的或者只负责读or写的操作）
  - 性能差（增加了多层逻辑抽象）



### 多态实现原理

![image-20240928214128527](/Users/t/Desktop/xxxx2077.github.io/docs/software_development/backend/C++.assets/image-20240928214128527.png)

#### 静态绑定

函数重载，编译时确定

```c++
// 静态绑定
#include <iostream>
using namespace std;

class A{
public:
    int sum(int a, int b){
        return a + b;
    }
    double sum(double a, double b){
        return a + b;
    }
};

int main(){
    A* a = new A();
    cout << a->sum(1,2) << endl;
    cout << a->sum(3.2,4.0) << endl;
}

```

`objdump -t 程序名`查看符号表

![image-20240928204549115](/Users/t/Desktop/xxxx2077.github.io/docs/software_development/backend/C++.assets/image-20240928204549115.png) 

由上图可见，sum函数名经修饰后分别为`__ZN1A3sumEdd`和`__ZN1A3sumEii`

数字为字符长度，dd和ii分别对应类型名称

#### 动态绑定

> 可参考：https://blog.csdn.net/qq_36359022/article/details/81870219

运行时根据类的类型决定函数的行为



每个含有虚函数的类都会在**编译阶段**由编译器为该类创建一个虚函数表，在类起始位置存放指向虚函数表地址的指针vptr，该指针称为虚函数表指针

虚函数表是一个一维数组，元素为虚函数的函数指针

关系梳理为：

```C++
vptr 为虚函数表指针
*vptr 为虚函数表地址（虚函数表数组名）
*vptr[0] 为虚函数表第一个元素
```

子类拷贝基类的虚函数表，对其进行覆盖重写，并添加自己的虚函数

```C++
// 动态绑定
#include <iostream>
using namespace std;

class Base{
public:
    virtual void func(){
        cout << "Base::func" << endl;
    }
};

class Derive: public Base{
public:
    virtual void func(){
        cout << "Derive::func" << endl;
    }
};

int main(){
    Base* basePtr = new Base();
    Base* derivePtr = new Derive();
    // long* 是特殊的指针，因为指针是8字节的，long也是8字节的
    // 所以long*可以用于存放指针的指针

    // 编译器会在对象开始的位置放置个指向该类的虚函数表指针vptr
    // Step1 : (long*) basePtr将类指针转换为long*，方便取虚函数表指针
    // Step2 : *(long*) basePtr对类指针解引用，获取vptr
    // Step3 : 将vptr转换为long*，方便使用
    long*  base_vptr = (long*) * (long*) basePtr;
    // 定义函数指针
    typedef void (*Func) (void);
    Func base_func = (Func)base_vptr[0];
    base_func();

    long*  derive_vptr = (long*) * (long*) derivePtr;
    Func derive_func = (Func)derive_vptr[0];
    derive_func();
    
    // basePtr->func();
    // derivePtr->func();
}

```

输出结果

![image-20240928210621628](/Users/t/Desktop/xxxx2077.github.io/docs/software_development/backend/C++.assets/image-20240928210621628.png)

## 实战

### 最简单的编译命令

```C++
g++ [option] source.cpp -o target.cpp
```
