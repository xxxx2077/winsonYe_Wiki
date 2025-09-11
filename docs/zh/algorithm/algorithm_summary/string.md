# 字符串API

## 取子串`substr()`

`substr()` 是 C++ 标准库中 `std::string` 类提供的一个成员函数，用于**提取字符串的子串**。它允许你根据指定的位置和长度从原字符串中获取一个新的字符串。

### 函数原型

```cpp
string substr (size_t pos = 0, size_t len = npos) const;
```

- **`pos`**: 子串的起始位置（默认为0）。如果超出字符串的范围，则会抛出 `out_of_range` 异常。
- **`len`**: 子串的长度（默认为 `npos`，表示直到字符串的末尾）。如果指定的长度超过了实际剩余字符数，则只会返回到字符串末尾的部分。

### 参数说明

- `pos`: 子串开始的位置索引。字符串的第一个字符位置是 0。
- `len`: 要提取的子串长度。如果省略或超过实际长度，则会提取从 `pos` 开始直到字符串末尾的所有字符。

### 返回值

返回一个新字符串，它是原字符串从 `pos` 开始、长度为 `len` 的子串。

### 示例代码

#### 示例 1：基本用法

```cpp
#include <iostream>
#include <string>

int main() {
    std::string str = "Hello, World!";
    
    // 提取从位置 7 开始，长度为 5 的子串
    std::string result = str.substr(7, 5);
    std::cout << "Substring: " << result << std::endl; // 输出: World

    // 如果不指定 len 或者 len 大于剩余长度，则提取到字符串末尾
    std::string rest = str.substr(7);
    std::cout << "Rest of the string: " << rest << std::endl; // 输出: World!

    return 0;
}
```

#### 示例 2：处理异常情况

如果你尝试使用一个超出字符串长度的起始位置，将会抛出 `std::out_of_range` 异常。因此，在不确定输入的情况下，最好进行边界检查：

```cpp
#include <iostream>
#include <string>

int main() {
    std::string str = "Hello";
    
    try {
        // 尝试使用超出范围的 pos 值
        std::string sub = str.substr(10);
        std::cout << "This will not be printed." << std::endl;
    } catch (const std::out_of_range& e) {
        std::cerr << "Error: " << e.what() << std::endl; // 捕获并处理异常
    }

    return 0;
}
```

#### 示例 3：结合其他功能

可以将 `substr()` 与其他字符串操作结合起来使用，比如查找特定字符或子串的位置：

```cpp
#include <iostream>
#include <string>

int main() {
    std::string text = "The quick brown fox jumps over the lazy dog.";
    
    // 查找第一个空格的位置
    size_t pos = text.find(' ');
    
    if (pos != std::string::npos) {
        // 提取从开头到第一个空格之前的子串
        std::string firstWord = text.substr(0, pos);
        std::cout << "First word: " << firstWord << std::endl; // 输出: The
    }

    return 0;
}
```

### 注意事项

1. **越界访问**：确保 `pos` 在字符串的有效范围内。否则，将引发 `std::out_of_range` 异常。
2. **长度参数**：如果 `len` 超过了从 `pos` 到字符串末尾的实际长度，`substr()` 只会返回从 `pos` 到字符串末尾的部分。
3. **性能考虑**：`substr()` 创建了一个新的字符串对象，对于非常大的字符串和频繁调用的情况，可能需要考虑内存和性能影响。

## 分割字符串

给出一个字符串，单词与单词之间以空格隔开，取出字符串中的单词

```C++
#include <iostream>
#include <sstream>

using namespace std;

int main(){
    string input = "hello world from C++ !";
    istringstream iss(input);
    vector<string> tokens;
    string token;
    while(getline(iss, token, ' ')){
        if(!token.empty()){
            tokens.push_back(token);
        }
    }
    for(auto token : tokens){
        cout << token << endl;
    }
}
```

进一步拓展，不只是空格，给定分割词，对字符串进行分割

```C++
#include <iostream>
#include <sstream>

using namespace std;

vector<string> splitString(const string& input, char delimiter){
    istringstream iss(input);
    vector<string> tokens;
    string token;
    while(getline(iss, token, delimiter)){
        if(!token.empty()){
            tokens.push_back(token);
        }
    }
    return tokens;
}

int main(){
    string input = "hello world from C++ !";
    vector<string> tokens = splitString(input, ' ');
    for(auto token : tokens){
        cout << token << endl;
    }

    string input2 = "hello,world,from,C++,!";
    tokens = splitString(input2, ',');
    for(auto token : tokens){
        cout << token << endl;
    }
}
```

## 将大写字母转换为小写字母：`std::tolower`

函数定义在 `<cctype>` 头文件中

### 函数原型：
```cpp
int tolower(int c);
```

- 如果 `c` 是大写字母（A-Z），返回对应的小写形式；
- 否则返回 `c` 本身。

### 示例代码：

```cpp
#include <iostream>
#include <string>
#include <cctype> // tolower, isalpha

int main() {
    std::string str = "Hello, WORLD!";

    for (char& ch : str) {
        ch = std::tolower(static_cast<unsigned char>(ch));
    }

    std::cout << "转换后: " << str << std::endl;

    return 0;
}
```

### 输出：
```
转换后: hello, world!
```

📌 **注意**：  
- `std::tolower` 接受的是 `int` 类型参数，通常传入 `unsigned char` 强制转换后的值。
- 避免直接传入 `char`，因为 `char` 可能是负数，在某些平台上会导致未定义行为。

---

## 判断一个字符是否为字母：`std::isalpha`

函数定义在 `<cctype>` 头文件中

### 函数原型：
```cpp
int isalpha(int c);
```

- 如果 `c` 是字母（A-Z 或 a-z），返回非零值（true）；
- 否则返回 0（false）。

### 示例代码：

```cpp
#include <iostream>
#include <string>
#include <cctype>

int main() {
    std::string str = "Ab1cD2";

    for (char ch : str) {
        if (std::isalpha(static_cast<unsigned char>(ch))) {
            std::cout << ch << " 是字母" << std::endl;
        } else {
            std::cout << ch << " 不是字母" << std::endl;
        }
    }

    return 0;
}
```

### 输出：
```
A 是字母
b 是字母
1 不是字母
c 是字母
D 是字母
2 不是字母
```

## 📌 补充说明：C++11 后的字符串处理建议

如果你使用的是现代 C++（如 C++11 或以上），可以结合 `std::transform` 来简化字符串转换过程：

```cpp
#include <algorithm> // std::transform

std::transform(str.begin(), str.end(), str.begin(),
    [](unsigned char c){ return std::tolower(c); });
```

## 判断一个字符是否为字母或数字：`std::isalnum`

`isalnum` 是 C++ 标准库中的一个函数，定义在 <cctype> 头文件中。它用于检查传递给它的字符是否是字母（a-z 或 A-Z）或数字（0-9）。换句话说，`isalnum` 用来判断一个字符是否属于字母数字字符。

函数原型

```cpp
int isalnum(int c);
```

- 参数：c 是要检查的字符，通常是一个 unsigned char 类型的值或 EOF。
- 返回值：
  - 如果 c 是字母（A-Z, a-z）或数字（0-9），则返回非零值（表示 true）。
  - 如果 c 不是字母也不是数字，则返回 0（表示 false）。

## string类型与int类型相互转换

### int 转换为 string
使用 std::to_string

```cpp
#include <string>
#include <iostream>

int main() {
    int num = 123;
    std::string str = std::to_string(num);
    std::cout << str << std::endl; // 输出: 123
    return 0;
}
```

优点：简洁、安全、无需手动管理内存。

### string 转换为 int
使用 std::stoi（C++11）
将字符串转换为整数，返回 int 类型。

```cpp
#include <string>
#include <iostream>

int main() {
    std::string str = "456";
    int num = std::stoi(str);
    std::cout << num << std::endl; // 输出: 456
    return 0;
}
```