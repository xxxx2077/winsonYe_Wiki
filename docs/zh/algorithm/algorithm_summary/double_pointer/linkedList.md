# 链表

## 遍历链表

一般我们拥有链表头head就拥有了整个链表，遍历链表时，我们通常保留链表头，创建一个新的指针p指向head，然后开始遍历。否则，我们将丢失head信息，也就丢失链表信息。

如果只是遍历一次链表之后不再使用该链表，则可以直接使用head作为遍历指针p

```C++
// ListNode* head
ListNode* p = head;
while(p != nullptr){
    p = p->next;
}
```

## 虚拟头节点

**为什么需要虚拟头节点：** 链表的增和删都需要使用目标节点curNode的前一个节点preNode和下一个节点nextNode，当目标节点恰好是头节点，其没有preNode，需要额外处理。而引入虚拟头节点后，让头节点也有了preNode，所有情况都可以统一处理，不需要额外讨论

同样地，创造新链表也需要保留链表头信息，因此创建过程也需要新指针p

```C++
ListNode* dummyNode = new ListNode();
ListNode* p = dummyNode;
if(condition)
    p->next = newNode;
p = p->next;
```

**相关题目：**

- 链表合二为一：[【leetcode 21】合并两个有序链表](../leetcode/21%20合并两个升序链表.md)
- 原链表一分为二：[【leetcode 86】分隔链表](../leetcode/86)
- 链表合k为一：[【leetcode 23】合并k个有序链表](../leetcode/23%20合并K个升序链表.md)
    

## 链表拼接

原链表的节点接到新链表上，而不是 new 新节点来组成新链表的话，需要注意两个操作：

1. 断开节点和原链表之间的链接（[为什么需要断开节点与原链表之间的链接](https://labuladong.online/algo/essential-technique/linked-list-skills-summary/#%E5%8D%95%E9%93%BE%E8%A1%A8%E7%9A%84%E5%88%86%E8%A7%A3:~:text=%3B%0A%20%20%20%20%7D%0A%7D%3B-,%E6%88%91%E7%9F%A5%E9%81%93%E6%9C%89%E5%BE%88%E5%A4%9A%E8%AF%BB%E8%80%85%E4%BC%9A%E5%AF%B9%E8%BF%99%E6%AE%B5%E4%BB%A3%E7%A0%81%E6%9C%89%E7%96%91%E9%97%AE%EF%BC%9A,-//%20%E4%B8%8D%E8%83%BD%E7%9B%B4%E6%8E%A5%E8%AE%A9)）。但凡遇到这种情况，就把原链表的节点断开，这样就不会出错了。

    例如：

    ```C++
    ListNode* tmp = head->next;
    head->next = nullptr;
    ```

2. 原链表继续遍历

    例如：
    ```C++
    p1->next = head;
    p1 = p1->next; //这一步不能漏掉
    ```

**举个例子：**

- [【leetcode 86】分隔链表](../leetcode/86%20分隔链表.md)

## 双指针

利用双指针之间的距离，实现一次遍历获得链表的不同位置

通常开始时，p1与p2之间相距k，k为目的位置，

之后，p1和p2同时移动

结束时，p1指向链表末尾，p2为目的位置

### 求链表倒数第k个节点

**求倒数第k个节点：因为p1指向链表末尾，所以p2和p1相距k**

首先，我们先让一个指针 p1 指向链表的头节点 head，然后走 k 步

![picture 0](https://labuladong.online/algo/images/linked-list-two-pointer/1.jpeg)

现在的 p1，只要再走 n - k 步，就能走到链表末尾的空指针了对吧？

趁这个时候，再用一个指针 p2 指向链表头节点 head：

![picture 1](https://labuladong.online/algo/images/linked-list-two-pointer/2.jpeg)

接下来就很显然了，让 p1 和 p2 同时向前走，p1 走到链表末尾的空指针时前进了 n - k 步，p2 也从 head 开始前进了 n - k 步，停留在第 n - k + 1 个节点上，即恰好停链表的倒数第 k 个节点上：

![picture 2](https://labuladong.online/algo/images/linked-list-two-pointer/3.jpeg)

**相关题目：**

- [【剑指offer 26】 链表倒数第k个节点](../剑指offer/JZ22%20链表中倒数最后k个节点.md)
- [【leetcode 19】删除链表的倒数第N个节点](../leetcode/19%20删除链表的第N个节点.md)

### 快慢指针

#### 求链表的中点

求链表中点其实就是求倒数第n/2个节点，但是n我们并不知道，所以不能使用[求链表倒数第k个节点](#求链表倒数第k个节点)

在这种情况下，我们可以使用「快慢指针」

我们让两个指针 slow 和 fast 分别指向链表头结点 head。

每当慢指针 slow 前进一步，快指针 fast 就前进两步，这样，当 fast 走到链表末尾的下一个元素（nullptr）时，slow 就指向了链表中点。

```C++
ListNode* fast = head, * slow = head;
// 注意不要遗漏fast->next != nullptr
// 这两个条件使得fast指向链表尾部的下一个元素(nullptr)
while(fast != nullptr && fast->next != nullptr){
    fast = fast->next->next;
    slow = slow->next;
}
return slow;
```

**相关题目：**

- [【leetcode 876】链表的中间节点](../leetcode/876%20链表的中间节点.md)

#### 判断链表是否包含环

每当慢指针 slow 前进一步，快指针 fast 就前进两步。

如果 fast 最终能正常走到链表末尾，说明链表中没有环；如果 fast 走着走着竟然和 slow 相遇了，那肯定是 fast 在链表中转圈了，说明链表中含有环。

```C++
class Solution {
public:
    bool hasCycle(ListNode *head) {
        // 快慢指针初始化指向 head
        ListNode *slow = head, *fast = head;
        // 快指针走到末尾时停止
        while (fast != nullptr && fast->next != nullptr) {
            // 慢指针走一步，快指针走两步
            slow = slow->next;
            fast = fast->next->next;
            // 快慢指针相遇，说明含有环
            if (slow == fast) {
                return true;
            }
        }
        // 不包含环
        return false;
    }
};
```

**相关题目：**

- [【leetcode 141】环形链表](../leetcode/141%20环形链表.md)

#### 获得环的起点

第一次循环就是[判断是否有环](#判断链表是否包含环)，如果有环，那么接着获得环的起点（[「获得环的起点」原理](https://labuladong.online/algo/essential-technique/linked-list-skills-summary/#%E5%88%A4%E6%96%AD%E9%93%BE%E8%A1%A8%E6%98%AF%E5%90%A6%E5%8C%85%E5%90%AB%E7%8E%AF:~:text=%E4%B8%BA%E4%BB%80%E4%B9%88%E8%A6%81%E8%BF%99%E6%A0%B7%E5%91%A2%EF%BC%9F%E8%BF%99%E9%87%8C%E7%AE%80%E5%8D%95%E8%AF%B4%E4%B8%80%E4%B8%8B%E5%85%B6%E4%B8%AD%E7%9A%84%E5%8E%9F%E7%90%86%E3%80%82)），为此进行第二次循环：判断有环后，让slow指针重新指向头节点，fast和slow指针同时移动一步，直到两者相遇，就是环的起点。

!!! note

    慢指针在进入环之后，慢指针会在一圈内与快指针相遇，这才能证明 k - m 是 head 与环起点的距离。

    关于慢指针会在一圈与快指针相遇，通过数学归纳法可证明，

    1. 快指针与慢指针之间差一步时，继续走，慢指针前进一步，快指针前进2步，两者相遇，
    2. 快指针与慢指针之间差两步时，继续走，慢指针前进一步，快指针前进2步，两者距离差一步，转化为第一种情况
    3. 快指针之间差N步，继续走，慢指针前进一步，快指针前进两步，两者之间相差N-1步

    所以，慢指针要走多少步会相遇？走N次，由于初始距离N必然小于环的周长，所以对于慢指针来说，一圈内就能与快指针相遇

```C++
class Solution {
public:
    ListNode* detectCycle(ListNode* head) {
        ListNode* fast = head;
        ListNode* slow = head;
        while (fast != nullptr && fast->next != nullptr) {
            fast = fast->next->next;
            slow = slow->next;
            if (fast == slow) break;
        }
        // 上面的代码类似 hasCycle 函数
        if (fast == nullptr || fast->next == nullptr) {
            // fast 遇到空指针说明没有环
            return nullptr;
        }

        // 重新指向头结点
        slow = head;
        // 快慢指针同步前进，相交点就是环起点
        while (slow != fast) {
            fast = fast->next;
            slow = slow->next;
        }
        return slow;
    }
};
```

**相关题目：**

- [【leetcode 142】 环形链表II](../leetcode/142%20环形链表II.md)

#### 两个链表是否相交

[两个链表是否相交讲解](https://labuladong.online/algo/essential-technique/linked-list-skills-summary/#%E4%B8%A4%E4%B8%AA%E9%93%BE%E8%A1%A8%E6%98%AF%E5%90%A6%E7%9B%B8%E4%BA%A4)

**相关题目：**

- [【leetcode 160】 相交链表](../leetcode/160%20相交链表.md)