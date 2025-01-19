# 链表

链表的核心思想在于，链表通过指针串联分散在不同地方的内存（与数组区分）

这意味着：

- 链表不需要关注内存上限（不需要思考size和cap的关系，因为cap理论上是无限的，实际受到总内存限制）的问题，因此没有扩容缩容的说法
- 链表不是连续内存，因此无法随机访问，访问元素需要时间复杂度$O(n)$
- 在头部插入元素不需要数据迁移，时间复杂度$O(1)$；尾部插入元素如果没有tail指针，那么需要遍历到尾元素（时间复杂度$O(n)$），再插入元素（时间复杂度$O(1)$）。但引入tail指针后，尾部插入元素（时间复杂度$O(1)$）

## 单链表

=== "C++"

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

## 双向链表

=== "C++"

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