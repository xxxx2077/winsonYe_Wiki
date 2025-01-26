# 队列和栈

与数组和链表相比，队列和栈在增删改查API上进行了约束：

- 队列只允许：队尾插入，队头取出
- 栈只允许：栈顶弹出，栈顶压入

## 栈

=== "C++"

```C++
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

## 队列

### 单侧队列

=== "C++"

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
```

### 双端队列

=== "C++"

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