# 数组

数组的本质在于：数组是一段连续的内存空间

这个本质决定了数组拥有以下性质：

- 我们能够通过索引在$O(1)$时间复杂度内随机访问数组内元素
- 在数组内插入元素：

  1. 首先需要判断元素个数size和内存空间capacity的大小关系 

    - 如果插入后size > capacity（等价于插入前size == capacity），说明已用完这段内存空间，那么数组需要**扩容**
    - 如果插入后size < capacity/4（等价于插入前size == capacity/4），说明当前元素个数远小于这段内存空间，为了节省内存空间，数组可以**缩容**

  2. 然后需要判断插入元素的位置index： 

    - 判断index是否合法，对于插入，index >= 0 && index <= size **（插入index可以等于size）**
    - 如果插入在**尾部**，不影响之前元素的位置，直接插入，时间复杂度为$O(1)$
    - 如果插入在**头部或中间**，会影响当前插入位置之后的所有元素，需要进行数据搬移（给当前插入位置腾出空间），时间复杂度为$O(n)$，之后再进行插入，时间复杂度为$O(1)$，总时间复杂度为$O(n)$ 
  
- 在数组内删除元素：

  1. 首先需要判断元素个数size和内存空间capacity的大小关系 
   
    - 如果删除后size < capacity/4（等价于插入前size == capacity/4），说明当前元素个数远小于这段内存空间，为了节省内存空间，数组可以**缩容**

  2. 然后需要判断删除元素的位置index： 
    
    - 判断index是否合法，对于删除，index >= 0 && index < size **（删除index不可以等于size）**
    - 如果删除在**尾部**，不影响之前元素的位置，直接插入，时间复杂度为$O(1)$
    -  如果删除在**头部或中间**，会影响当前插入位置之后的所有元素，需要进行数据搬移（给当前插入位置腾出空间），时间复杂度为$O(n)$，之后再进行插入，时间复杂度为$O(1)$，总时间复杂度为$O(n)$ 


!!! tip "关于扩容和缩容"

    **扩容**：申请一块比当前数组内存更大（通常为2倍）的空间，之后将当前数组的元素复制到新数组中，该过程时间复杂度为$O(n)$

    **缩容**：申请一块比当前数组内存更小（通常为2分之一）的空间，之后将当前数组的元素复制到新数组中，该过程时间复杂度为$O(n)$

## 数组API

```C++
template<typename T>
class Array{
    // 尾部增 O(1)
    void addLast(T element);
    // 头部/中部增 O(n)
    void add(int index, T element);
    // 尾部删 O(1)
    T removeLast();
    // 头部或中部删 O(n)
    T remove();
    // 改 O(1)
    void set(int index, T element);
    // 查 O(1)
    T get(int index); 
};
```

!!! tip 

    以下文字摘自[数组总结](https://labuladong.online/algo/data-structure-basic/array-basic/#%E6%80%BB%E7%BB%93)

    >有读者可能问，刚才不是还探讨过数组的扩容操作吗，扩容涉及到新数组空间的开辟和数据的复制，时间复杂度是 $O(N)$，这个复杂度为什么没有算到「增」的复杂度里面呢？
    这个问题很好，但并不是每次增加元素的时候都会触发扩容，所以扩容的复杂度要用「均摊时间复杂度」来分析，这个概念我在[时空复杂度分析方法](https://labuladong.online/algo/essential-technique/complexity-analysis/) 中有详细的讲解，这里就不展开了。
    还有个问题初学者要注意，我们说数组的查、改复杂度是 $O(1)$，这个仅仅适用于给定索引的情况。如果反过来，比方说给你一个值，让你去找这个值在数组中对应的索引，那你只能遍历整个数组去寻找对吧，这个复杂度就是 $O(N)$ 了。
    所以说要搞清楚原理，而不要去背概念。原理懂了，概念你自己都能推导出来的。


## 静态数组

静态数组，顾名思义，不会发生自动扩缩容，也就是说，数组是一段固定的内存空间

例如C++中的静态数组

```C++
int arr[4];
```

## 动态数组

动态数组，顾名思义，自动发生扩缩容，数组是一段动态的内存空间

### 动态数组应用
例如C++中的动态数组vector

=== "C++"

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

=== "go"

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

### 动态数组实现

当然，我们也可以自己实现一个动态数组

=== "C++"

    ```C++
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

