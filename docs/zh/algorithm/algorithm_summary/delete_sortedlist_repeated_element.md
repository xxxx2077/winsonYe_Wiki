# 删除有序数组/链表的重复元素

把重复的元素看成是一个节点，那么删除重复元素，就相当于删除一个元素

注意会不会删除头节点，如果有这种可能，那么引入dummyNode

---

「通用框架」是：

1. slow指向删除节点的前一个节点，也就是未重复链表的最后一个节点；fast指向迭代的节点
2. fast->val与fast->next->val比较，从而判断重复的元素。这种做法最后会让fast指向最后一个重复元素，根据题意是否要保留重复元素，选择是否要添加一步fast = fast->next
3. 步骤2之后的fast为删除节点的下一个节点，slow->next = fast实现删除
4. **注意slow维护的是新链表，因此需要slow->next断开链表末尾**

```C++
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode() : val(0), next(nullptr) {}
 *     ListNode(int x) : val(x), next(nullptr) {}
 *     ListNode(int x, ListNode *next) : val(x), next(next) {}
 * };
 */
class Solution {
public:
    ListNode* deleteDuplicates(ListNode* head) {
        ListNode* dummyNode = new ListNode(-1);
        dummyNode->next = head;
        ListNode* slow = dummyNode, *fast = head;
        while(fast != nullptr){
            if(fast->next != nullptr && fast->val == fast->next->val){
                while(fast->next != nullptr && fast->val == fast->next->val){
                    fast = fast->next;
                }
                // fast指向最后一个重复元素
                // 如果题目不需要保留重复元素，则添加以下代码，让fast再指向下一个元素
                // fast = fast->next
            }else{
                slow->next = fast;
                slow = slow->next;
                fast = fast->next;
            }
        }
        // 注意断开链表末尾
        slow->next = nullptr;
        return dummyNode->next;
    }
};
```

有时候也可以根据题意不使用通用框架，例如[【leetcode 83】 删除排序链表中的重复元素](../leetcode/83%20删除排序链表中的重复元素.md)保留一个重复元素，那么头节点不会被删除，所以可以不使用dummyNode