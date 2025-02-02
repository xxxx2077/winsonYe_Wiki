# JZ22 链表中倒数最后k个节点

```C++
/**
 * struct ListNode {
 *	int val;
 *	struct ListNode *next;
 *	ListNode(int x) : val(x), next(nullptr) {}
 * };
 */
class Solution {
public:
    /**
     * 代码中的类名、方法名、参数名已经指定，请勿修改，直接返回方法规定的值即可
     *
     * 
     * @param pHead ListNode类 
     * @param k int整型 
     * @return ListNode类
     */
    ListNode* FindKthToTail(ListNode* pHead, int k) {
        // write code here
        ListNode* fast = pHead, *slow = pHead;
        for(int i = 0; i < k; i++){
            // 这一步是因为题目说明了：如果该链表长度小于k，返回长度为0的链表
            if(fast == nullptr)
                return nullptr;
            else
                fast = fast->next;
        }
        while(fast != nullptr && slow != nullptr){
            fast = fast->next;
            slow = slow->next;
        }
        return slow;
    }
};
```