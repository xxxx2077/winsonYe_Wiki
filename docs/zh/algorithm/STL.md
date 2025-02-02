# STL

## 比较函数

使用容器时经常需要我们自定义比较函数，C++的自定义比较函数是一个非常令人疑惑的领域

**在C++中，比较函数返回`true`表示第一个参数的优先级比第二个参数低，返回`false`则表示第一个参数优先级比第二个优先级高**。这是一种约定俗成，默认认为偏序对`<x,y>`中x比y的优先级低。

C++默认的比较函数有`std::less<T>`和`std::greater<T>`

```C++
bool less(int a, int b) {
    return a < b; // 如果 a < b，返回 true
}
```


```C++
bool greater(int a, int b) {
    return a > b; // 如果 a > b，返回 true
}
```

我们可以模仿这两个函数实现自定义比较函数，例如：

```C++
bool cmp(State& a, State& b) {
    return a.val > b.val; // 如果 a > b，返回 true
}
```

## 优先级队列

```C++
#include<queue>
```

容器定义：

```C++
template<
    class T,
    class Container = std::vector<T>,
    class Compare = std::less<typename Container::value_type>
> class priority_queue;
```

- `T`：队列中存储的元素类型。
- `Container`：底层容器类型，默认为 `std::vector<T>`。
- `Compare`：比较函数对象类型，默认为 `std::less<T>`，即大根堆。（小根堆对应`std::greater<T>`）

### 比较函数

本容器难点在于**比较函数**

>比较函数详细解释见：[比较函数](#比较函数)。
简单来说，就是**比较函数返回`true`表示第一个参数的优先级比第二个参数低**，而优先级队列，就是保证**父节点的优先级比两个子节点高**，不同比较函数对优先级的不同定义导致了不同优先级队列（大根堆、小根堆）的出现。

#### 大根堆

默认情况下，`std::priority_queue` 使用 `std::less<T>` 作为比较函数：

```C++
bool less(int a, int b) {
    return a < b; // 如果 a < b，返回 true
}
```

如果 a < b 返回 true，表示 a 应该排在 b 之后（即 a 的优先级低于 b）。

因此，较大的元素会被推到堆顶，形成 大根堆。

#### 小根堆

如果你希望实现 小根堆，可以使用 std::greater<T>：

```C++
bool greater(int a, int b) {
    return a > b; // 如果 a > b，返回 true
}
```

如果 a > b 返回 true，表示 a 应该排在 b 之后（即 a 的优先级低于 b）。

因此，较小的元素会被推到堆顶，形成 小根堆。

#### 自定义堆

我们自定义一个大根堆为例：

```C++
struct cmp{
	bool operator()(State&a, State&b){
		return a.val < b.val;
	}
};
```

## 二分查找

https://blog.csdn.net/weixin_45031801/article/details/137544229

lower_bound( begin , end , val , less<type>() )
上述代码中加入了 less<type>() 自定义比较函数：适用于从小到大排序的有序序列，从数组/容器的 beign 位置起，到 end-1 位置结束，查找第一个 大于等于 val 的数字
lower_bound( begin , end , val , greater<type>() )
上述代码中加入了 greater<type>() 自定义比较函数：适用于从大到小排序的有序序列，从数组/容器的 beign 位置起，到 end-1 位置结束，查找第一个 小于等于 val 的数字

### upper_bound

前提是有序的情况下，upper_bound返回第一个大于val值的位置。（通过二分查找）

### lower_bound

前提是**有序**的情况下，lower_bound 返回指向第一个值不小于 val 的位置，也就是返回第一个大于等于val值的位置。（通过二分查找）

***\*注意：\****需要注意的是如果例子中（val >= 8）,那么迭代器就会指向last位置，***\*也就是数组尾元素的下一个，不管val多大，迭代器永远指向尾元素的下一个位置\****

```c++
#include <iostream>
#include <algorithm>
#include <vector>
using namespace std;
 
int main()
{
	vector<int> v = { 3,4,1,2,8 };
	// 先排序
	sort(v.begin(), v.end());  // 1 2 3 4 8
 
	// 定义两个迭代器变量
	vector<int>::iterator iter1;
	vector<int>::iterator iter2;
 
	// 在动态数组中寻找 >=3 出现的第一个数 并以迭代器的形式返回
	iter1 = lower_bound(v.begin(), v.end(), 3);  // -- 指向3
	// 在动态数组中寻找 >=7 出现的第一个数 并以迭代器的形式返回
	iter2 = lower_bound(v.begin(), v.end(), 7);  // -- 指向8
 
	cout << distance(v.begin(), iter1) << endl; //下标 2
	cout << distance(v.begin(), iter2) << endl; //下标 4 
	return 0;
}

```

## 其他细节

```C++
while(index--){
}
```

等价于

```C++
for(int i = 0; i < index; i++){
}
```

