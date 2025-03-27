# 二分查找

二分查找主要用于**有序数组**查找元素或最小/大值

[二分查找算法介绍](https://labuladong.online/algo/essential-technique/binary-search-framework/)

[二分查找应用](https://labuladong.online/algo/frequency-interview/binary-search-in-action/)

这里仅给出部分结论，详情请看以上两篇文章

## 查找元素

=== "左闭右闭"

    ```C++
    class Solution {
    public:
        int search(vector<int>& nums, int target) {
            int left = 0, right = nums.size() - 1;
            while(left <= right){
                int mid = left + (right - left) / 2;
                if(target == nums[mid]){
                    return mid;
                }else if(target < nums[mid]){
                    right = mid - 1;
                }else if(target > nums[mid]){
                    left = mid + 1;
                }
            }
            return -1;
        }
    };
    ```

=== "左闭右开“

    ```C++
    class Solution {
    public:
        int search(vector<int>& nums, int target) {
            int left = 0, right = nums.size();
            while(left < right){
                int mid = left + (right - left) / 2;
                if(target == nums[mid]){
                    return mid;
                }else if(target < nums[mid]){
                    right = mid;
                }else if(target > nums[mid]){
                    left = mid + 1;
                }
            }
            return -1;
        }
    };
    ```

## 查找左边界

```C++
// 找左边界
int left_bound(vector<int>& nums, int target){
    int left = 0, right = nums.size();
    while(left < right){
        int mid = left + (right - left) / 2;
        if(target == nums[mid]){
            right = mid;
        }else if(target < nums[mid]){
            right = mid;
        }else if(target > nums[mid]){
            left = mid + 1;
        }
    }
    // 其实只需要判断left >= nums.size()
    // 因为left只增不减，while结束条件为left == right, 因此left最大为nums.size()
    if(left < 0 || left >= nums.size())
        return -1;
    return nums[left] == target ? left : -1;
}
```

如果 target 不存在，搜索左侧边界的二分搜索返回的索引是大于 target 的最小索引。

## 查找右边界

```C++
// 找右边界
int right_bound(vector<int>& nums, int target){
    int left = 0, right = nums.size();
    while(left < right){
        int mid = left + (right - left) / 2;
        if(target == nums[mid]){
            left = mid + 1;
        }else if(target < nums[mid]){
            right = mid;
        }else if(target > nums[mid]){
            left = mid + 1;
        }
    }
    // 其实只需要判断left - 1 >= nums.size()
    // 因为left只增不减，while结束条件为left == right, 因此left - 1最大为nums.size()
    if(left - 1 < 0 || left - 1 >= nums.size())
        return -1;
    return nums[left - 1] == target ? left - 1 : -1;
}
```
如果 target 不存在，搜索右侧边界的二分搜索返回的索引是小于 target 的最大索引。