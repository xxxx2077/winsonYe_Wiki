# STL

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

