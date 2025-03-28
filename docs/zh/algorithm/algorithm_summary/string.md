# C++字符串的处理

## 1. 给定带空格字符串，跳过空格读取单词

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

## 2. 去除前后空格

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

