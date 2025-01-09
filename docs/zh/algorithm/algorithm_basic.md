# 算法基础

## 数据结构

任何数据结构都是在数组和链表两种存储结构基础上演化的

### 数组

数组的核心思想在于，数组是一块连续内存。

这意味着：

- 我们能够根据元素大小通过计算地址得到每个元素的地址，即随机访问元素，时间复杂度为$O(1)$
- 在数组中间添加或删除会涉及数组元素的迁移，时间复杂度为$O(n)$
- 我们不能随便使用数组内存之外的其他内存，因此当数组内存不够用需要扩容（当数组内存过剩（size == cap/4）可以缩容）

#### 动态数组

##### 使用动态数组

**C++**

```C++
#include <iostream>
#include <vector>
using namespace std;

void printArr(const vector<int>& arr){
    for(auto const& num :arr){
        cout << num << " ";
    }
    cout << endl;
}

int main(){
    vector<int> arr;
    // 在尾部插入元素
    // O(1)
    for(int i = 0; i < 10; i++){
        arr.push_back(i);
    }
    printArr(arr);

    // 在头部插入元素
    // O(n)
    arr.insert(arr.begin(),444);
    printArr(arr);

    // 在index = 5处插入元素
    // O(n)
    arr.insert(arr.begin() + 5, 555);
    printArr(arr);

    // 在头部删除元素
    // O(1)
    arr.erase(arr.begin());
    printArr(arr);

    // 在尾部删除元素
    // O(1)
    arr.pop_back();
    printArr(arr);

    // 在index = 5处删除元素
    // O(n)
    arr.erase(arr.begin()+5);
    printArr(arr);
  
 		// 根据元素值查找索引，时间复杂度 O(N)
    int index = -1;
    for(int i = 0; i < arr.size();i++){
        if(arr[i] == 666){
            index = i;
            break;
        }
    }   
}
```



**go**

```go
package main

import "fmt"

func main() {
	arr := make([]int, 0)
	// 在尾部插入元素
	// O(1)
	for v := range 10 {
		arr = append(arr, v)
	}

	fmt.Println(arr)

	// 在头部插入元素
	// O(n)
	arr = append([]int{111}, arr[0:]...)
	fmt.Println(arr)

	// 在index = 5处插入元素
	// O(n)
	// ...此处表示展开切片元素
	arr = append(arr[:5], append([]int{777}, arr[5:]...)...)
	fmt.Println(arr)

	// 在头部删除元素
	// O(n)
	arr = arr[1:]
	fmt.Println(arr)

	// 在index = 5处删除元素
	// O(n)
	// ...此处表示展开切片元素
	arr = append(arr[:5], arr[6:]...)
	fmt.Println(arr)

	// 在尾部删除元素
	// O(n)
	arr = arr[:len(arr)-1]
	fmt.Println(arr)
  
  // 根据索引查询元素，时间复杂度 O(1)
	a := arr[0]

	// 根据索引修改元素，时间复杂度 O(1)
	arr[0] = 100

	// 根据元素值查找索引，时间复杂度 O(N)
	index := -1
	for i, v := range arr {
		if v == 666 {
			index = i
			break
		}
	}
}

```

##### 实现动态数组

C++

```c++
#include <iostream>
using namespace std;

template<typename T>
class MyArray{
    private:
        T* data;
        T size;
        T cap;
        const int INIT_CAP = 1;
    public:
        MyArray(){
            this->data = new T[INIT_CAP];
            this->size = 0;
            this->cap = INIT_CAP;
        }
        MyArray(int Capacity){
            this->data = new T[Capacity];
            this->size = 0;
            this->cap = Capacity;
        }

        void addLast(T element){
            if(this->size == this->cap)
                resize(this->cap * 2);
            data[size++] = element;
        }
        
        void add(int index, T element){
            if(this->size == this->cap)
                resize(this->cap * 2);
            for(int i = size ;i > index; i--) {
                data[i] = data[i - 1];
            }
            data[index] = element;
            size++;
        }

        T removeLast(){
            if(size == 0)
                throw std::out_of_range("NoSuchElementException");
            if(size == cap/4)
                resize(this->cap / 2);
            int tmp = data[size - 1];
            data[size - 1] = NULL;
            size--;
            return tmp; 
        }

        T remove(int index){
            checkElementIndex(index);
            if(size == cap/4)
                resize(this->cap / 2);
            for(int i = index; i < size - 1; i++){
                data[i] = data[i + 1];
            }
            int tmp = data[size - 1];
            data[size - 1] = NULL;
            size--;
            return tmp;
        }

        T get(int index){
            checkElementIndex(index);
            return data[index];
        }

        T set(int index, T element){
            checkElementIndex(index);
            int tmp = data[index];
            data[index] = element;
            return tmp;
        }

        void resize(int capacity){
            T* newData = new T[capacity];
            for(int i = 0; i < size; i++){
                newData[i] = data[i];
            }
            delete[] data;
            this->data = newData;
            this->cap = capacity;
        }
        
        void checkElementIndex(int index){
            if(!isElementIndex(index)){
                throw std::out_of_range("Index out of range");
            }
        }

        void checkPositionIndex(int index){
            if(!isPositionIndex(index)){
                throw std::out_of_range("Index out of range");
            }
        }

        void display(){
            cout << "size: " << size << ",cap: " << cap << endl;
            for(int i = 0; i < size; i++){
                cout << data[i] << " ";
            }
            cout << endl;
        }

        bool isElementIndex(int index){
            return index >= 0 && index < size;
        }

        bool isPositionIndex(int index){
            return index >= 0 && index <= size;
        }

        ~MyArray(){
            delete[] data;
        }
};

int main(){
    MyArray<int> arr;
    for(int i = 0; i < 10; i++)
        arr.addLast(i);
    arr.display();
    arr.add(2,222);
    arr.display();
    cout << "get: " << arr.get(2) << endl;
    arr.display();

    arr.set(2,2222222);
    arr.display();

    arr.removeLast();
    arr.display();

    arr.remove(2);
    arr.display();
}
```



#### 环形数组

环形数组与动/静态数组不同之处在于：

- 动/静态数组拥有的内存空间逻辑上是有边界的，比如说头部元素的前一个位置不属于该数组。因此动/静态数组插入会涉及数组迁移的操作。
- 环形数组维护的内存空间逻辑上不再有头尾之分（实际上和动/静态数组一样有边界，通过维护头尾指针打破边界），因此头尾插入不会涉及数组迁移，只需要利用头尾指针插入，在这一点与环型链表很像
- 但在数组内部插入，环形数组仍然需要数据迁移

**环形数组C++实现**

```C++
#include <iostream>
#include <stdexcept>
#include <ostream>

template<typename T>
class CycleArray {
    std::unique_ptr<T[]> arr;
    int start;
    int end;
    int size;
    int capacity;

    // 自动扩缩容辅助函数
    void resize(int newCapacity) {
        // 创建新的数组
        std::unique_ptr<T[]> newArr = std::make_unique<T[]>(newSize);
        // 将旧数组的元素复制到新数组中
        for (int i = 0; i < size; ++i) {
            newArr[i] = arr[(start + i) % capacity];
        }
        arr = std::move(newArr);
        // 重置 start 和 end 指针
        start = 0;
        end = size;
        capacity = newCapacity;
    }

public:
    CycleArray() : CycleArray(1) {
    }

    explicit CycleArray(int capacity) : start(0), end(0), size(0), capacity(capacity) {
        arr = std::make_unique<T[]>(capacity);
    }

    // 在数组头部添加元素，时间复杂度 O(1)
    void addFirst(const T &val) {
        // 当数组满时，扩容为原来的两倍
        if (isFull()) {
            recapacity(capacity * 2);
        }
        // 因为 start 是闭区间，所以先左移，再赋值
        start = (start - 1 + capacity) % capacity;
        arr[start] = val;
        size++;
    }

    // 删除数组头部元素，时间复杂度 O(1)
    void removeFirst() {
        if (isEmpty()) {
            throw std::runtime_error("Array is empty");
        }
        // 因为 start 是闭区间，所以先赋值，再右移
        arr[start] = T();
        start = (start + 1) % capacity;
        size--;
        // 如果数组元素数量减少到原大小的四分之一，则减小数组大小为一半
        if (size > 0 && size == capacity / 4) {
            resize(capacity / 2);
        }
    }

    // 在数组尾部添加元素，时间复杂度 O(1)
    void addLast(const T &val) {
        if (isFull()) {
            resize(capacity * 2);
        }
        // 因为 end 是开区间，所以是先赋值，再右移
        arr[end] = val;
        end = (end + 1) % capacity;
        size++;
    }

    // 删除数组尾部元素，时间复杂度 O(1)
    void removeLast() {
        if (isEmpty()) {
            throw std::runtime_error("Array is empty");
        }
        // 因为 end 是开区间，所以先左移，再赋值
        end = (end - 1 + capacity) % capacity;
        arr[end] = T();
        size--;
        // 缩容
        if (size > 0 && size == capacity / 4) {
            resize(capacity / 2);
        }
    }

    // 获取数组头部元素，时间复杂度 O(1)
    T getFirst() const {
        if (isEmpty()) {
            throw std::runtime_error("Array is empty");
        }
        return arr[start];
    }

    // 获取数组尾部元素，时间复杂度 O(1)
    T getLast() const {
        if (isEmpty()) {
            throw std::runtime_error("Array is empty");
        }
        // end 是开区间，指向的是下一个元素的位置，所以要减 1
        return arr[(end - 1 + capacity) % capacity];
    }

    bool isFull() const {
        return size == capacity;
    }

    int getSize() const {
        return size;
    }

    bool isEmpty() const {
        return size == 0;
    }
};
```



### 链表

链表的核心思想在于，链表通过指针串联分散在不同地方的内存（与数组区分）

这意味着：

- 链表不需要关注内存上限（不需要思考size和cap的关系，因为cap理论上是无限的，实际受到总内存限制）的问题，因此没有扩容缩容的说法
- 链表不是连续内存，因此无法随机访问，访问元素需要时间复杂度$O(n)$
- 在头部插入元素不需要数据迁移，时间复杂度$O(1)$；尾部插入元素如果没有tail指针，那么需要遍历到尾元素（时间复杂度$O(n)$），再插入元素（时间复杂度$O(1)$）。但引入tail指针后，尾部插入元素（时间复杂度$O(1)$）

单链表

C++实现单链表

```c++
#include <iostream>
#include <vector>
using namespace std;

template<typename T>
struct LinkedNode{
    T val;
    LinkedNode* next;
    LinkedNode(){
        this->next = nullptr;
    }
    LinkedNode(T val){
        this->val = val;
        this->next = nullptr;
    }

};

template<typename T>
LinkedNode<T>* CreateNode(vector<T> &arr){
    if(arr.empty())
        return nullptr;
    LinkedNode<T>* head = new LinkedNode<T>(arr[0]);
    LinkedNode<T>* cur = head;
    for(int i = 1; i < arr.size(); i++){
        cur->next = new LinkedNode<T>(arr[i]);
        cur = cur->next;
    }
    return head;
}

int main(){
    vector<int> arr = {1,2,3,4,5};
    LinkedNode<int> *head = CreateNode(arr);
    while(head != nullptr){
        cout << head->val << " ";
        head = head->next;
    }
}
```

#### 实现双向链表

C++实现双向链表

```c++
#include <iostream>
using namespace std;

template<typename T>
class DoubleLinkedList{
    private:
        struct LinkedNode{
            T val;
            LinkedNode *prev;
            LinkedNode *next;
            LinkedNode(){}
            LinkedNode(T val):val(val),prev(nullptr),next(nullptr){}
        };
        // 虚拟头尾节点
        LinkedNode* head;
        LinkedNode* tail;
        int size;

        bool isPositionIndex(int index){
            return index >= 0 && index <= size;
        }

        bool isElementIndex(int index){
            return index >= 0 && index < size;
        }

        void checkPositionIndex(int index){
            if(!isPositionIndex(index))
                throw std::out_of_range("Index:" + to_string(index) + ", size:" + to_string(size));
        }
        void checkElementIndex(int index){
            if(!isPositionIndex(index))
                throw std::out_of_range("Index:" + to_string(index) + ", size:" + to_string(size));
        }

        LinkedNode* getNode(int index){
            LinkedNode* cur = head->next;
            for(int i = 0; i < index; i++){
                cur = cur->next;
            }
            return cur;
        }
    public:
        DoubleLinkedList(){
            head = new LinkedNode();
            tail = new LinkedNode();
            head->next = tail;
            tail->prev = head;
            size = 0;
        }

        void addFirst(T value){
            LinkedNode* newHead = new LinkedNode(value);
            newHead->prev = nullptr;
            newHead->next = head;
            head->prev = newHead;
            head = newHead;
            size++;
        }

        void addLast(T value){
            LinkedNode* newTail = new LinkedNode(value);
            LinkedNode* lastNode = tail->prev;
            newTail->next = tail;
            newTail->prev = lastNode;
            lastNode->next = newTail;
            tail->prev = newTail;
            size++;
        }

        void add(int index, T value){
            checkPositionIndex(index);
            if(index == 0){
                addFirst(value);
                return;
            }
            if(index == size){
                addLast(value);
                return;
            }
            LinkedNode* cur = getNode(index - 1);
            LinkedNode* newNode = new LinkedNode(value);
            newNode->next = cur->next;
            newNode->prev = cur;
            cur->next->prev = newNode;
            cur->next = newNode;
            size++;
        }

        T removeFirst(){
            if(size == 0)
                std::out_of_range("No elements to remove");
            LinkedNode* deleteNode = head->next;
            head->next = deleteNode->next;
            deleteNode->next->prev = head;
            T deleteNodeVal = deleteNode->val;
            delete deleteNode;
            size--;
            return deleteNodeVal;
        }

        T removeLast(){
            if(size == 0)
                std::out_of_range("No elements to remove");
            LinkedNode* deleteNode = tail->prev;
            LinkedNode* tmp = deleteNode->prev;
            tmp->next = tail;
            tail->prev = tmp;
            T deleteNodeVal = deleteNode->val;
            delete deleteNode;
            size--;
            return deleteNodeVal;
        }
        
        T remove(int index){
            checkElementIndex(index);
            LinkedNode* deleteNode = getNode(index);
            LinkedNode* tmp = deleteNode->prev;
            tmp->next = deleteNode->next;
            deleteNode->next->prev = tmp;
            T deleteNodeVal = deleteNode->val;
            delete deleteNode;
            size--;
            return deleteNodeVal;
        }
        
        T get(int index){
            LinkedNode* node = getNode(index);
            return node->val;
        }

        bool empty(){
            return size == 0;
        }

        void display(){
            cout << "size: " << size << endl;
            for(LinkedNode* cur = head->next; cur != tail; cur = cur->next){
                cout << cur->val << " ";
            }
            cout << endl;
        }
        ~DoubleLinkedList(){
            delete head;
            delete tail;
        }
};

int main(){
    DoubleLinkedList<int> doubleLinkedList = DoubleLinkedList<int>();
    for(int i = 1; i <= 10; i++){
        doubleLinkedList.addLast(i);
    }
    doubleLinkedList.display();
    doubleLinkedList.addFirst(0);
    doubleLinkedList.display();
    doubleLinkedList.add(2,33333);
    doubleLinkedList.display();

    doubleLinkedList.removeFirst();
    doubleLinkedList.display();
    doubleLinkedList.removeLast();
    doubleLinkedList.display();
    doubleLinkedList.remove(2);
    doubleLinkedList.display();
}
```

### 队列和栈

与数组和链表相比，队列和栈在增删改查API上进行了约束：

- 队列只允许：队尾插入，队头取出
- 栈只允许：栈顶弹出，栈顶压入

```C++
// 队列的基本 API
template <typename E>
class MyQueue {
public:
    // 向队尾插入元素，时间复杂度 O(1)
    void push(const E& e);

    // 从队头删除元素，时间复杂度 O(1)
    E pop();

    // 查看队头元素，时间复杂度 O(1)
    E peek() const;

    // 返回队列中的元素个数，时间复杂度 O(1)
    int size() const;
};

// 栈的基本 API
template <typename E>
class MyStack {
public:
    // 向栈顶插入元素，时间复杂度 O(1)
    void push(const E& e);

    // 从栈顶删除元素，时间复杂度 O(1)
    E pop();

    // 查看栈顶元素，时间复杂度 O(1)
    E peek() const;

    // 返回栈中的元素个数，时间复杂度 O(1)
    int size() const;
};
```

#### 双端队列

```C++
template<typename E>
class MyDeque {
public:
    // 从队头插入元素，时间复杂度 O(1)
    void addFirst(E e);

    // 从队尾插入元素，时间复杂度 O(1)
    void addLast(E e);

    // 从队头删除元素，时间复杂度 O(1)
    E removeFirst();

    // 从队尾删除元素，时间复杂度 O(1)
    E removeLast();

    // 查看队头元素，时间复杂度 O(1)
    E peekFirst();

    // 查看队尾元素，时间复杂度 O(1)
    E peekLast();
};
```



### 哈希表

数组通过索引在 O(1)的时间复杂度内查找到对应元素，索引是一个**非负整数**。

哈希表通过 `key` 在 O(1)的时间复杂度内查找到这个 `key` 对应的 `value`。**`key` 的类型可以是数字、字符串等多种类型。**

哈希表的底层实现就是一个数组（我们不妨称之为 `table`）。它先把这个 `key` 通过一个哈希函数（我们不妨称之为 `hash`）转化成数组里面的索引，然后增删查改操作和数组基本相同：

```C++
// 哈希表伪码逻辑
class MyHashMap {

private:
    vector<void*> table;

public:
    // 增/改，复杂度 O(1)
    void put(auto key, auto value) {
        int index = hash(key);
        table[index] = value;
    }

    // 查，复杂度 O(1)
    auto get(auto key) {
        int index = hash(key);
        return table[index];
    }

    // 删，复杂度 O(1)
    void remove(auto key) {
        int index = hash(key);
        table[index] = nullptr;
    }

private:
    // 哈希函数，把 key 转化成 table 中的合法索引
    // 时间复杂度必须是 O(1)，才能保证上述方法的复杂度都是 O(1)
    int hash(auto key) {
        // ...
    }
};
```

需要注意的几个点：

- 哈希表key唯一，value不唯一（类比数组索引和元素值）

- 哈希函数：把任意长度的输入（key）转化成固定长度的输出（索引）。哈希函数需要保证：

  - **哈希函数的复杂度为O(1)。**如果你设计的这个哈希函数复杂度是 O(N)，那么哈希表的增删查改性能就会退化成 O(N)
  - **输入相同的 `key`，输出也必须要相同。**

- 哈希冲突：如果两个不同的 `key` 通过哈希函数得到了相同的索引

  - **哈希冲突是一定会出现的。**因为这个 `hash` 函数相当于是把一个无穷大的空间映射到了一个有限的索引空间，所以必然会有不同的 `key` 映射到同一个索引上。

  - **解决哈希冲突的方法**

    - 拉链法（纵向）：哈希表的底层数组并不直接存储 `value` 类型，而是存储一个链表，当有多个不同的 `key` 映射到了同一个索引上，这些 `key -> value` 对儿就存储在这个链表中，这样就能解决哈希冲突的问题。
    - 线性探查法（开放寻址法）（横向）：一个 `key` 发现算出来的 `index` 值已经被别的 `key` 占了，那么它就去 `index + 1` 的位置看看，如果还是被占了，就继续往后找，直到找到一个空的位置为止

  - 那么为什么会频繁出现哈希冲突：

    1. 哈希函数设计的不好，导致 `key` 的哈希值分布不均匀，很多 `key` 映射到了同一个索引上。
    2. 哈希表里面已经装了太多的 `key-value` 对了，这种情况下即使哈希函数再完美，也没办法避免哈希冲突。

    对于第一个问题没什么好说的，开发编程语言标准库的大佬们已经帮你设计好了哈希函数，你只要调用就行了。

    对于第二个问题是我们可以控制的，即避免哈希表装太满，这就引出了「负载因子」的概念。

> 「负载因子」
>
> 负载因子是一个哈希表装满的程度的度量。一般来说，负载因子越大，说明哈希表里面存储的 `key-value` 对越多，哈希冲突的概率就越大，哈希表的操作性能就越差。
>
> **负载因子的计算公式也很简单，就是 `size / table.length`**。其中 `size` 是哈希表里面的 `key-value` 对的数量，`table.length` 是哈希表底层数组的容量。
>
> 你不难发现，用拉链法实现的哈希表，负载因子可以无限大，因为链表可以无限延伸；用线性探查法实现的哈希表，负载因子不会超过 1。
>
> 像 Java 的 HashMap，允许我们创建哈希表时自定义负载因子，不设置的话默认是 `0.75`，这个值是经验值，一般保持默认就行了。
>
> **当哈希表内元素达到负载因子时，哈希表会扩容**。和之前讲解 [动态数组的实现](https://labuladong.online/algo/data-structure-basic/array-implement/) 是类似的，就是把哈希表底层 `table` 数组的容量扩大，把数据搬移到新的大数组中。`size` 不变，`table.length` 增加，负载因子就减小了。

**为什么不能依赖哈希表的遍历顺序**

首先，由于 `hash` 函数要把你的 `key` 进行映射，所以 `key` 在底层 `table` 数组中的分布是随机的，不像数组/链表结构那样有个明确的元素顺序。

其次，刚才讲了哈希表达到负载因子时会怎样？会扩容对吧，也就是 `table.length` 会变化，且会搬移元素。

那么这个搬移数据的过程，是不是要用 `hash` 函数重新计算 `key` 的哈希值，然后放到新的 `table` 数组中？

**而这个 `hash` 函数，它计算出的值依赖 `table.length`。也就是说，哈希表自动扩容后，同一个 `key` 的哈希值可能变化，即这个 `key-value` 对儿存储在 `table` 的索引也变了，所以遍历结果的顺序就和之前不一样了**。

#### 面试常考问题：

**1、为什么我们常说，哈希表的增删查改效率都是 O(1)**？

因为哈希表底层就是操作一个数组，其主要的时间复杂度来自于哈希函数计算索引和哈希冲突。只要保证哈希函数的复杂度在 O(1)*O*(1)，且合理解决哈希冲突的问题，那么增删查改的复杂度就都是 O(1)。

**2、哈希表的遍历顺序为什么会变化**？

因为哈希表在达到负载因子时会扩容，这个扩容过程会导致哈希表底层的数组容量变化，哈希函数计算出来的索引也会变化，所以哈希表的遍历顺序也会变化。

**3、哈希表的增删查改效率一定是 O(1)吗**？

不一定，正如前面分析的，只有哈希函数的复杂度是 O(1)，且合理解决哈希冲突的问题，才能保证增删查改的复杂度是 O(1)。

哈希冲突好解决，都是有标准答案的。关键是哈希函数的计算复杂度。如果使用了错误的 `key` 类型，比如前面用 `ArrayList` 作为 `key` 的例子，那么哈希表的复杂度就会退化成 O(N)。

**4、为啥一定要用不可变类型作为哈希表的 `key`**？

因为哈希表的主要操作都依赖于哈希函数计算出来的索引，如果 `key` 的哈希值会变化，会导致键值对意外丢失，产生严重的 bug。

## 二分查找

#### 查找大于等于x 的第一个数

a[mid] >= target说明要寻找的数在[l, mid]中

a[mid] < target说明要寻找的数在(mid, n - 1]中

```C++
// 区间[l, r]被划分成[l, mid]和[mid + 1, r]时使用：
int bsearch_1(int l, int r)
{
    while (l < r)
    {
        int mid = l + r >> 1;
        if (a[mid] < target) l = mid + 1;    // check()判断mid是否满足性质
        else r = mid ;
    }
    return l;
}
```

#### 查找小于等于x 的最后一个数

a[mid] >= target说明要寻找的数在[l, mid]中

a[mid] < target说明要寻找的数在(mid, n - 1]中

```C++
// 区间[l, r]被划分成[l, mid - 1]和[mid, r]时使用：
int bsearch_2(int l, int r)
{
    while (l < r)
    {
        int mid = l + r + 1 >> 1;
        if (a[mid] > target) r = mid - 1;
        else l = mid;
    }
    return l;
}
```

#### 记忆口诀

大于等于x：

- r = mid
- 因为是大于，所以l 是 mid + 1

小于等于x：

- l = mid
- 因为是小于，所以r 是mid - 1

## 动态规划

动态规划可根据以下两个维度思考：

1. 状态表示
   - 集合
   - 属性
2. 状态计算
3. 时间复杂度计算：状态数 * 状态转移计算次数

### 背包问题

给出N个物品的体积$v_i$和价值$w_i$，以及背包的总容量V

求解将哪些物品装入背包，可使这些物品的总体积不超过背包容量，且总价值最大。

输出最大价值。

#### 01背包问题

> 模板题：https://www.acwing.com/problem/content/2/

**特点：**每件物品只能使用一次

**状态计算：**

由于每个物品只能使用一次，那么分类讨论为：

1. 第i个物品不装进书包：`f[i][j]=f[i - 1][j]`
2. 第i个物品装进书包：`f[i][j] =f[i - 1][j - v[i]] + w[i]` 

`f[i][j]取以上结果的最大值max即可，即f[i][j] = max(f[i - 1][j], f[i - 1][j - v[i]] + w[i])`

##### 朴素版

采用二维数组`f[i][j]`作为状态表达式，表示**前i个物品背包容积为j的所有选择**

```c++
#include <iostream>
using namespace std;

const int N = 1010, V = 1010;
//  f[N][V] 状态表达式
//  集合：f[i][j] 表示 前i个物品背包容积为j的所有选择
//  属性：所有选择的价值最大值
int f[N][V];

// v[i] 记录每个物品的体积，w[i] 记录每个物品的价值
int v[N],w[N];

int main(){
    int n, m;
    cin >> n >> m;
    //  输入    
    for(int i = 1; i <= n; i++){
        cin >> v[i] >> w[i];
    }
    
    //  开始求解
    //  f[0][0~m]都是0，因为第0个物品没有价值可言
    //  从第1个物品开始计算
    for(int i = 1; i <= n; i++){
        //  遍历每个容积
        for(int j = 0; j <= m; j++){
            //  如果不选第i个物品
            f[i][j] = f[i - 1][j];
            //  如果选择第i个物品
            //  判断当前容积是否能容纳第i个物品
            if(j >= v[i])   
                // f[i - 1][j - v[i]]表示选择第i个物品的前提下，第i - 1个物品的价值最大值
                f[i][j] = max(f[i][j], f[i - 1][j - v[i]] + w[i]);
        }
    }
    
    //  输出结果，f[n][m]表示前n个物品容积为m的价值最大值，即我们问题的解
    cout << f[n][m] << endl;
}
```

**时间复杂度：**$O(NV)\approx O(n^2)$

**空间复杂度：**$O(NV)\approx O(n^2)$

##### 优化版

优化思路：

1. 计算`f[i]`都是依靠`f[i - 1]`，因此本质上只需要一维数组，这种称为滚动数组（滚动数组：二维数组计算的时候`f[i]`只依托于`f[i - 1]`等有限个前驱数组）
2. 遍历容积都是从`j == 0`开始，但是又有判断`j >= v[i]`才会计算`f[i][j] = max(f[i][j], f[i - 1][j - v[i]] + w[i]);`因此可以直接从`j == v[i]`开始

**值得注意的是：**

由于滚动数组只有一维，因此`f[i - 1][j]`实际上以上一次存储的`f[j]`来表示

如果从左往右计算，那么计算`f[i][j]`时，由于`j - v[i] <= j`，`f[j - v[i]]`在`f[j]`的左侧，即已经被计算过

此时`f[j - v[i]]`表示的是`f[i][j - v[i]]`而不是`f[i - 1][j - v[i]]`，与题意不符

因此我们需要从右往左计算，保证计算顺序`f[j]`早于`f[j - v[i]]`

```c++
#include <iostream>
using namespace std;

const int N = 1010, V = 1010;
//  f[V] 状态表达式
//  集合：遍历第i次，f[j] 表示 前i个物品背包容积为j的所有选择
//  属性：所有选择的价值最大值
int f[V];

// v[i] 记录每个物品的体积，w[i] 记录每个物品的价值
int v[N],w[N];

int main(){
    int n, m;
    cin >> n >> m;
    //  输入    
    for(int i = 1; i <= n; i++){
        cin >> v[i] >> w[i];
    }
    
    //  开始求解
    //  f[0~m]都是0，因为第0个物品没有价值可言
    //  从第1个物品开始计算
    for(int i = 1; i <= n; i++){
        //  遍历每个容积
        for(int j = m; j >= v[i]; j--){
            f[j] = max(f[j], f[j - v[i]] + w[i]);
        }
    }
    
    //  输出结果，已经遍历了n次，f[m]表示前n个物品容积为m的价值最大值，即我们问题的解
    cout << f[m] << endl;
}
```

**时间复杂度：**$O(NV)\approx O(n^2)$

**空间复杂度：**$O(V)\approx O(n)$

#### 完全背包问题

> 模板题：https://www.acwing.com/problem/content/3/

**特性：**每种物品都有无限件可用。

**状态计算：**

以物品的个数作为分类讨论条件：

1. 第i个物品取0个：`f[i - 1][j] = f[i][j - 0*v[i]]+0*w[i]`
2. 第i个物品取1个：`f[i][j - 1*v[i]]+1*w[i]`
3. ....
4. 第i个物品取k个：`f[i][j - k*v[i]]+k*w[i]`
5. ....

保证`k * v[i] <= j`的前提，把以上状态全部取个max得到结果

##### 最初版

```c++
#include <iostream>
using namespace std;

const int N = 1010, V = 1010;
int f[N][V];
int v[N], w[N];

int main(){
    int n, m;
    cin >> n >> m;
    for(int i = 1; i <= n; i++)
        cin >> v[i] >> w[i];
    for(int i = 1; i <= n; i++){
        for(int j = 0; j <= m; j++){
            for(int k = 0; k * v[i] <= j; k++){
                f[i][j] = max(f[i][j], f[i - 1][j - k * v[i]] + k * w[i]);
            }
        }
    }
    
    cout << f[n][m] << endl;
}
```

**时间复杂度：**$O(NV*\frac{V}{v})\approx O(n^3)$

**空间复杂度：**$O(NV)\approx O(n^2)$

该方法时间复杂度过于高，基本不使用



##### 普通优化版

```
f[i][j] 
= max(f[i - 1][j], f[i - 1][j - v[i]] + w[i], f[i - 1][j - 2 * v[i]] + 2 * w[i],f[i - 1][j - 3 * v[i]] + 2 * w[i]， ..., f[i - 1][j - k * v[i]] + k * w[i]     ,...)

f[i][j - v[i]] 
= max(             f[i - 1][j - v[i]]       , f[i - 1][j - 2 *v[i]] + w[i],      f[i - 1][j - 3 * v[i]] + 2 * w[i], ..., f[i - 1][j - (k + 1) * v[i]] + k * w[i],...)

可以发现
`f[i][j] 
= max(f[i - 1][j], f[i][j - v[i]] + w[i])`
```

我们得到新的状态计算方程：

`f[i][j] = max(f[i - 1][j], f[i][j - v[i]] + w[i])`

**注意：**

完全背包问题的状态方程与01背包问题不同

- 01背包问题的状态计算方程为`f[i][j] = max(f[i - 1][j], f[i - 1][j - v[i]] + w[i])`，这里是 i - 1
- 完全背包问题的状态计算方程为`f[i][j] = max(f[i - 1][j], f[i][j - v[i]] + w[i])`， 这里是 i

```C++
#include <iostream>
using namespace std;

const int N = 1010, V = 1010;
int f[N][V];
int v[N], w[N];

int main(){
    int n, m;
    cin >> n >> m;
    for(int i = 1; i <= n; i++)
        cin >> v[i] >> w[i];
    for(int i = 1; i <= n; i++){
        for(int j = 0; j <= m; j++){
            f[i][j] = f[i - 1][j];
            if(j >= v[i])
                f[i][j] = max(f[i][j], f[i][j - v[i]] + w[i]);
        }
    }
    
    cout << f[n][m] << endl;
}
```

**时间复杂度：**$O(NV)\approx O(n^2)$

**空间复杂度：**$O(NV)\approx O(n^2)$

与01背包问题类似，该方法还能优化为一维数组版



##### 最终优化版

优化思路与01背包问题大致相同

**唯一不同点在于：**

本次是从左往右遍历容积j（01背包是从右往左），这是因为状态计算方程不同：

- 01背包问题的状态计算方程为`f[i][j] = max(f[i - 1][j], f[i - 1][j - v[i]] + w[i])`，这里是 i - 1
- 完全背包问题的状态计算方程为`f[i][j] = max(f[i - 1][j], f[i][j - v[i]] + w[i])`， 这里是 i

`f[i][j - v[i]]`与`f[i][j]`在同一行，优化为一维数组后，为`f[j - v[i]]`，在`f[j]`的左边，计算顺序：`f[j - v[i]]`先于`f[j]`

所以从左往右遍历

```c++
#include <iostream>
using namespace std;

const int N = 1010, V = 1010;
int f[V];
int v[N], w[N];

int main(){
    int n, m;
    cin >> n >> m;
    for(int i = 1; i <= n; i++)
        cin >> v[i] >> w[i];
    for(int i = 1; i <= n; i++){
        // 从左往右遍历
        for(int j = v[i]; j <= m; j++){
            f[j] = max(f[j], f[j - v[i]] + w[i]);
        }
    }
    
    cout << f[m] << endl;
}
```



#### 多重背包问题

> 模板题：
>
> - 不限时版：https://www.acwing.com/problem/content/4/
> - 限时版：https://www.acwing.com/problem/content/5/

**特性：**每个物品最多选择s[i]件

##### 朴素版

最基础的想法：枚举物品选择的件数k

```c++
#include <iostream>
using namespace std;

const int N = 1010, V = 1010;
int f[N][V];
int v[N], w[N], s[N];

int main(){
    int n, m;
    cin >> n >> m;
    for(int i = 1; i <= n; i++){
        cin >> v[i] >> w[i] >> s[i];
    }
    for(int i = 1; i <= n; i++){
        for(int j = 0; j <= m; j++){
            for(int k = 0; k <= s[i] && k * v[i] <= j; k++){
                f[i][j] = max(f[i][j], f[i - 1][j - k * v[i]] + k * w[i]);
            }
        }
    }
    
    cout << f[n][m] << endl;
}
```

**时间复杂度：**$O(NVs)\approx O(n^3)$

**空间复杂度：**$O(NV)\approx O(n^2)$



##### 优化版

与完全背包问题不同，多重背包多了一项，因此不能采用完全背包问题的做法

```
f[i][j] 
= max(f[i - 1][j], f[i - 1][j - v[i]] + w[i], f[i - 1][j - 2 * v[i]] + 2 * w[i],f[i - 1][j - 3 * v[i]] + 2 * w[i]， ..., f[i - 1][j - k * v[i]] + k * w[i]     ,..., f[i - 1][j - s[i] * v[i]] + s[i] * w[i])

f[i][j - v[i]] 
= max(             f[i - 1][j - v[i]]       , f[i - 1][j - 2 * v[i]] + w[i],     f[i - 1][j - 3 * v[i]] + 2 * w[i], ..., f[i - 1][j - (k + 1) * v[i]] + k * w[i],..., f[i - 1][j - s[i] * v[i]] + (s[i] - 1) * w[i], f[i - 1][j - (s[i] + 1) * v[i]] + s[i] * w[i])

与01背包不同，不能再写成：
f[i][j] 
= max(f[i - 1][j], f[i][j - v[i]] + w[i])

因为f[i][j - v[i]]比f[i][j]多了一项f[i - 1][j - (s[i] + 1) * v[i]] + s[i] * w[i]，多出来的一项记作d
所以f[i][j - v[i]] = max(B, d)， B为d前面若干项

f[i][j] = max(f[i - 1][j], f[i][j - v[i]] + w[i])
f[i][j - v[i]] = max(B , d)
-> f[i][j] = max(f[i - 1][j], max(B , d) + w[i])
无法计算B，因此这种方法不可取
```



> 回顾多重背包朴素版解法存在的问题：需要枚举每个物品的件数，而且这一步不能像完全背包问题那样优化，导致时间复杂度过高
>
> 而01背包不需要枚举每个物品的件数，因为物品最多只有1件
>
> 我们能否将多重背包问题转换为01背包问题？

优化版采用二进制分组表示法，将物品的件数k分解为若干个二进制组，那么枚举k变成了枚举每个组是否需要

因此多重背包问题转换为了01背包问题的解法

接下来我们看如何将k转换为二进制组

**优化解法**

理论前提：

- 任何数都能由二进制1，2，4，8，...，表示，例如$11=(1011)_2=8+0+2+1$

根据该前提，我们得出物品的件数s也能由二进制表示，枚举物品件数变成了枚举二进制组的个数

时间复杂度由$O(n^3)$缩减为$O(n^2log(s))$，s为物品的件数，$log(s)$为二进制组的个数



`f[i][j]`状态数$i$由$n$个变成$n*log_2(s)$

log2可这么求

```c++
#include <cmath>
using namespace std;

int main(){
  	int n;
		cin >> n;
  	cout << log2(n) << endl;
}
```

实际代码中，我们直接将求得log2结果与物品数上限N相乘得到新的N，这个N表示总状态数上限

```c++
#include <iostream>
using namespace std;

const int N = 11010, V = 2010;
int v[N], w[N];
int f[V];

int main(){
    int n, m;
    cin >> n >> m;
    // cnt为分组序数
    // cnt一定要放在循环外面，因为cnt是所有分组的序号
    int cnt = 0;
    // 对每个物品进行二进制组分组
    for(int i = 1; i <= n; i++){
        int a, b, s;
        // a为v[i], b为w[i], s为s[i]
        cin >> a >> b >> s;
        // k为分组内数量
        int k = 1;
        // 对s进行分二进制组
        while(k <= s){
            // 第cnt个组含有k个件数
            cnt++;
            // 计算第cnt个组的体积，每件物品体积相同，都为a
            v[cnt] = a * k;
            // 计算第cnt个组的价值，每件物品价值相同，都为b
            w[cnt] = b * k;
            s -= k;
            k *= 2;
        }
        // 剩余的s不能继续分为二进制组
        if(s > 0){
            cnt++;
            v[cnt] = a * s;
            w[cnt] = b * s;
        }
    }
    
    // 状态数由 n 变成了 n * log2(n)
    n = cnt;
    // 01背包问题
    for(int i = 1; i <= n; i++){
        for(int j = m; j >= v[i]; j--){
            f[j] = max(f[j], f[j - v[i]] + w[i]);
        }
    }
    
    cout << f[m] << endl;
}
```



#### 分组背包问题

> 模板题：https://www.acwing.com/problem/content/9/

**特性：**每组物品有若干个，同一组内的物品最多只能选一个。

由选择某个物品变成了两步：

1. 首先选择分组
2. 选择了分组之后要在组内选择一个物品

即进行两次01背包问题，第一次01背包问题将物品当成组，第二次在组内进行01背包问题

##### 朴素版

```c++
#include <iostream>
using namespace std;

const int N = 110, V = 110, S = 110;
int v[N][S], w[N][S], s[N];
int f[N][V];

// i表示第i组，k表示第i组内的第k件物品，j表示背包容积
int main(){
    int n, m;
    cin >> n >> m;
    for(int i = 1; i <= n; i++){
        cin >> s[i];
        for(int k = 1; k <= s[i]; k++)
            cin >> v[i][k] >> w[i][k];
    }
    
    for(int i = 1; i <= n; i ++){
        for(int j = 0; j <= m; j++){
            f[i][j] = f[i - 1][j];
            // 枚举背包内的每个物品
            for(int k = 1; k <= s[i]; k++){
                // 注意这里的v[i][k]和w[i][k]，而不是v[i][j]和w[i][j]
                if(v[i][k] <= j)
                    f[i][j] = max(f[i][j], f[i - 1][j - v[i][k]] + w[i][k]);
            }
        }
    }
    
    cout << f[n][m] << endl;
}
```

##### 优化版

与01背包问题优化思路完全一致

```c++
#include <iostream>
using namespace std;

const int N = 110, V = 110, S = 110;
int v[N][S], w[N][S], s[N];
int f[V];

// i表示第i组，k表示第i组内的第k件物品，j表示背包容积
int main(){
    int n, m;
    cin >> n >> m;
    for(int i = 1; i <= n; i++){
        cin >> s[i];
        for(int k = 1; k <= s[i]; k++)
            cin >> v[i][k] >> w[i][k];
    }
    
    for(int i = 1; i <= n; i ++){
        // 枚举背包内的每个物品
        for(int j = m; j >= 0; j--){
            for(int k = 1; k <= s[i]; k++){
                if(v[i][k] <= j)
                    // 注意这里的v[i][k]和w[i][k]，而不是v[i][j]和w[i][j]
                    f[j] = max(f[j], f[j - v[i][k]] + w[i][k]);
            }
        }
        
    }
    
    cout << f[m] << endl;
}
```



### 线性DP

线性DP即递推方程具有明显的线性关系，有一维线性和二维线性

背包问题也属于线性DP

#### 数字三角形

> https://www.acwing.com/problem/content/900/

`f[i][j]`表示走到第i行第j列的元素的路径之和

##### 朴素版

从上往下遍历

状态方程`f[i][j] += max(f[i - 1][j - 1], f[i - 1][j])`

```C++
#include <iostream>
using namespace std;

// 三角形的整数可以为负数，要取max，因此边界值为负无穷（-INF）
const int N = 510, INF = 0x3f3f3f3f;
// 状态表达式，到达第i行第j列的元素时所有路径的集合，对应的值为路径数字之和最大值
int f[N][N];
int n;

int main(){
    cin >> n;
    // 处理边界条件
    for(int i = 0; i <= n; i++)
        //注意是 i + 1
        for(int j = 0; j <= i + 1; j++)
            f[i][j] = -INF;
    // 输入三角形
    for(int i = 1; i <= n; i++)
        for(int j = 1; j <= i; j++)
            cin >> f[i][j];
    // 从第二行开始计算状态方程
    for(int i = 2; i <= n; i++){
        for(int j = 1; j <= i; j++){
            f[i][j] += max(f[i - 1][j - 1], f[i - 1][j]);
        }
    }
    
    // 这里res一定要设置为负无穷，因为数字之和可能为负数
    int res = -INF;
    // 遍历三角形底层取得最大值
    for(int j = 1; j <= n; j++)
        res = max(res, f[n][j]);
    
    cout << res << endl;
}
```

**时间复杂度：**$O(n^2)$

**空间复杂度：**$O(n^2)$

缺点是需要处理边界条件

##### 优化版

从下往上遍历

优化点：由于最终汇聚于一点，因此少了一次for循环，并且不需要处理边界条件

```C++
#include <iostream>
using namespace std;

const int N = 510;
int f[N][N];
int n;

int main(){
    cin >> n;
    for(int i = 1; i <= n; i++)
        // 这里注意是j <= i 而不是j <= n
        for(int j = 1; j <= i; j++)
            cin >> f[i][j];
    for(int i = n; i >= 1; i--){
        for(int j = n; j >= 1; j--){
            f[i][j] += max(f[i + 1][j], f[i + 1][j + 1]);
        }
    }
    
    cout << f[1][1] << endl;
}
```

**时间复杂度：**$O(n^2)$

**空间复杂度：**$O(n^2)$

#### 最长上升子序列

##### 朴素版

```C++
#include <iostream>
using namespace std;

const int N = 1010;

// 状态表达式，f[i]表示第i个元素结尾的所有单调递增子序列的集合
// f[i]的值表示这些集合的序列最长度
int f[N];
// 存储序列
int a[N];
int n;

int main(){
    cin >> n;
    for(int i = 1; i <= n; i++)
        cin >> a[i];
    // res用于获取每个元素结尾的最大单调递增子序列长度
    int res = 1;
    for(int i = 1; i <= n; i++){
        f[i] = 1;
        // 遍历前j个元素，每个元素结尾的最大单调递增子序列长度为f[j]
        for(int j = 1; j < i; j++){
            // 如果第i个元素比第j个元素大，说明第i个元素可以加入该递增子序列，则长度加1
            if(a[i] > a[j]) f[i] = max(f[i], f[j] + 1);
        }
        res = max(res, f[i]);
    }
    
    cout << res << endl;
}
```

**时间复杂度：**$O(n^2)$

**空间复杂度：**$O(n)$



##### 优化版

动态规划 + 二分查找

```C++
#include <iostream>
using namespace std;

const int N = 1010;
// tails[i]记录序列尾部元素, len表示当前序列的长度
int tails[N], len;
int a[N];
int n;

int main(){
    cin >> n;
    for(int i = 1; i <= n; i++)
        cin >> a[i];
    // 初始化tails
    tails[++len] = a[1];
    // 从第二个元素开始遍历
    for(int i = 2; i <= n; i++){
        // 如果当前元素比序列尾部元素大，说明该元素可直接纳入该序列，序列长度加一
        if(a[i] > tails[len]) 
            tails[++len] = a[i];
        // 如果当前元素比序列尾部元素小，根据元素之间差距越小序列长度越可能长的原理
        // 找到序列中比当前元素大的第一个元素，将其取代为当前元素a[i]
        // 序列长度不变
        else{
            int l = 1, r = len;
            while(l < r){
                int mid = (l + r) >> 1;
                if(tails[mid] >= a[i]) 
                    r = mid;
                else 
                    l = mid + 1;
            }
            tails[l] = a[i];
        }
    }
    // 最后输出len，len为最长子序列长度
    cout << len << endl;
}
```

**时间复杂度：**$O(nlog(n))$

**空间复杂度：**$O(n)$

#### 最长公共子序列

##### 朴素版

题解详见：https://www.acwing.com/solution/content/8111/

```C++
#include <iostream>
using namespace std;

const int N = 1010, M = 1010;
int f[N][M];
int n, m;
char a[N], b[M];

int main(){
    cin >> n >> m >> a + 1 >> b + 1;
    for(int i = 1; i <= n; i++){
        for(int j = 1; j <= m; j++){
            f[i][j] = max(f[i - 1][j], f[i][j - 1]);
            if(a[i] == b[j]) f[i][j] = max(f[i][j], f[i - 1][j - 1] + 1);
        }
    }
    
    cout << f[n][m] << endl;
}
```

## 区间DP

https://www.acwing.com/problem/content/284/

```

```



## 小技巧

### memset

> 详见https://blog.csdn.net/Supreme7/article/details/115431235

```
#include <cstring>
void *memset(void *str, int c, size_t n)
```

给前n个字节赋值c	

常用

- 初始化为0:：memset(a,-1,sizeof(a))
- 初始化为-1：memset(a,0,sizeof(a))
- 初始化为无穷大：memset(a,0x3f,sizeof(a))

### 无穷大

> 详见 https://blog.csdn.net/qq_40816078/article/details/82459599#:~:text=准确的说：%20inf

一般设置无穷大为INF=0x3f3f3f3f

初始化为无穷大：memset(a,0x3f,sizeof(a))

## STL容器

### 优先级队列

https://blog.csdn.net/weixin_36888577/article/details/79937886