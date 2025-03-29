# C++ 输入处理

## 数据范围

$10^9$ < int < $10^{10}$

超过需要使用long

## 字符串

### 1. 给定带空格字符串，跳过空格读取单词

例如输入为"Hello world"，分别打印"Hello", "world"

```C++
#include <iostream>
#include <string>
#include <sstream>
using namespace std;

int main(){
    string s = "I am a boy";
    istringstream iss(s);
    cout << iss.str() << endl;
    string word;
    while(iss >> word){
        cout << word << endl;
    }
}
// output
// I am a boy
// I
// am
// a
// boy
```

当使用 >> 运算符从 istringstream 对象中提取数据时，它遵循与标准输入流 (cin) 相同的行为规则。这意味着它会自动跳过任何前导空白字符（包括空格、制表符、换行符等），并读取直到下一个空白字符为止的所有字符作为一个单词。因此，无论单词之间有多少个空格，istringstream 都只会识别出一个单词并将其存储在变量 word 中。

!!! info "istringstream & ostringstream & stringstream"

    **istringstream**
    
    功能：专门用于从字符串中读取数据。
    特点：只提供输入操作（类似 cin），你可以从一个字符串中提取数据到变量中。
    使用场景：当你需要解析一个已有的字符串，并根据某种格式从中提取信息时非常有用。

    ```C++
    #include <sstream>
    #include <string>

    std::string str = "123 456";
    int a, b;
    std::istringstream iss(str);
    iss >> a >> b; // a=123, b=456
    ```

    **ostringstream**

    功能：专门用于向字符串写入数据。
    特点：只提供输出操作（类似 cout），你可以将数据插入到一个字符串流中，然后将其转换为字符串。
    使用场景：当你需要构建一个复杂的字符串，尤其是当这个字符串由多个部分组成时很有用。

    ```C++
    #include <sstream>
    #include <string>

    std::ostringstream oss;
    oss << "Name: " << "Alice" << ", Age: " << 28;
    std::string result = oss.str(); // 结果是 "Name: Alice, Age: 28"
    ```

    **stringstream**

    功能：同时支持从字符串读取数据和向字符串写入数据。
    特点：提供了双向操作（即既可以从字符串中提取数据，也可以向字符串中插入数据），结合了 istringstream 和 ostringstream 的功能。
    使用场景：当你需要对同一个字符串进行读写操作时特别有用。
    
    ```C++
    #include <sstream>
    #include <string>

    std::stringstream ss;
    ss << "Hello, "; // 写入
    ss << "world!";  // 继续写入
    std::string str = ss.str(); // 获取最终字符串 "Hello, world!"

    // 清除流状态并重置内容
    ss.clear();
    ss.str("");

    // 现在可以用来读取
    ss << "42"; // 再次写入
    int number;
    ss >> number; // 提取整数 42
    ```

### 2. 去除前后空格

C++ string库有以下函数：

- `find_first_of`和`find_first_not_of`
- `find_last_of`和`find_last_not_of`

以上函数返回size_t类型，即索引。如果不存在，则返回`string::npos`常量(size_t的最大值)

=== "gpt写法"

    ```C++
    #include <iostream>
    #include <string>
    #include <sstream>
    using namespace std;

    string trim(const string& str){
        size_t first = str.find_first_not_of(' ');
        if(string::npos == first)
            return "";
        size_t last = str.find_last_not_of(' ');
        return str.substr(first, last - first + 1);
    }

    int main(){
        string s = "   hello, world    ";
        cout << trim(s) << endl;
    }
    ```

=== "我自己双指针写法"

    ```C++
    int left = 0, right = s.size() - 1;
    while(s[left] == ' ') left++;
    while(s[right] == ' ') right--;
    return s.substr(left, right - left + 1);
    ```

如果你想要处理不仅仅是空格，还包括制表符、换行符等其他类型的空白字符，可以修改`find_first_not_of`和`find_last_not_of`的参数为一个包含所有你认为是空白字符的集合。例如：

```C++
const std::string WHITESPACE = " \n\r\t\f\v";
size_t first = str.find_first_not_of(WHITESPACE);
size_t last = str.find_last_not_of(WHITESPACE);
```

这样就可以同时去除包括空格在内的其他类型的空白字符。

