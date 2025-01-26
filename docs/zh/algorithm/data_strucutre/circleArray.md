# 环形数组

环形数组与动/静态数组不同之处在于：

- 动/静态数组拥有的内存空间逻辑上是有边界的，比如说头部元素的前一个位置不属于该数组。因此动/静态数组插入会涉及数组迁移的操作。
- 环形数组维护的内存空间逻辑上不再有头尾之分（实际上和动/静态数组一样有边界，通过维护头尾指针打破边界），因此头尾插入不会涉及数组迁移，只需要利用头尾指针插入，在这一点与环型链表很像
- 但在数组内部插入，环形数组仍然需要数据迁移

=== "C++"

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