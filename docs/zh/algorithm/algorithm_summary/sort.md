# 排序算法

[leetcode 912 排序数组](https://leetcode.cn/problems/sort-an-array/)

## 快速排序

```C++
class Solution {
private:
    void quickSort(vector<int>& nums, int l, int r) {
        if (l < r) {
            int idx = l + rand() % (r - l + 1);
            int pivot = nums[idx];
            int i = l - 1, j = r + 1;
            while (i < j) {
                do
                    i++;
                while (nums[i] < pivot);
                do
                    j--;
                while (nums[j] > pivot);
                if(i < j)
                    swap(nums[i],nums[j]);
            }
            quickSort(nums, l, j);
            quickSort(nums, j + 1, r);
        }
    }

public:
    vector<int> sortArray(vector<int>& nums) {
        quickSort(nums, 0, nums.size() - 1);
        return nums;
    }
};
```

```C++
#include <iostream>
#include <vector>
using namespace std;

int partition(vector<int>&nums, int low, int high){
    srand(time(NULL));
    int idx = low + rand() % (high - low + 1);
    int pivot = nums[idx];
    
    swap(nums[idx], nums[high]);
    int i = low;
    for(int j = low; j < high; j++){
        if(nums[j] < pivot){
            swap(nums[i], nums[j]);
            i++;
        }
    } 
    swap(nums[i], nums[high]);
    return i;
}

void quickSort(vector<int>& nums, int low, int high){
    if(low < high){
        int pidx = partition(nums, low, high);
        quickSort(nums, low, pidx - 1);
        quickSort(nums, pidx + 1, high);
    }
}

void printArr(vector<int>& nums){
    for(int num : nums)
        cout << num << " ";
    cout << endl;
}

int main(){
    vector<int> nums = {4,5,7,9,8,6,1,3,2};
    quickSort(nums, 0, nums.size() - 1);
    printArr(nums);
}
```

## 归并排序

```C++
class Solution {
private:
    vector<int> tmp;
    void mergeSort(vector<int>& nums,int l,int r){
        if(l < r){
            int mid = (l + r)>> 1;
            mergeSort(nums,l,mid);
            mergeSort(nums,mid+ 1,r);
            int cnt = 0;
            int i = l, j = mid + 1;
            while(i <= mid && j <= r){
                if(nums[i] <= nums[j])
                    tmp[cnt++] = nums[i++];
                else
                    tmp[cnt++] = nums[j++];
            }
            while(i <= mid)
                tmp[cnt++] = nums[i++];
            while(j <= r)
                tmp[cnt++] = nums[j++];
            for(int i = 0; i < r - l + 1;i++)
                nums[l+i] = tmp[i];
        }
    }
public:
    vector<int> sortArray(vector<int>& nums) {
        tmp.resize(nums.size(),0);
        mergeSort(nums,0,nums.size() - 1);
        return nums;
    }
};
```

## 堆排序

```C++
class Solution {
private:
    void heapify(vector<int>& nums, int u, int heapSize) {
        int smallest = u;
        int l = 2 * u + 1, r = 2 * u + 2;
        if (l < heapSize && nums[l] < nums[smallest])
            smallest = l;
        if (r < heapSize && nums[r] < nums[smallest])
            smallest = r;
        if (smallest != u) {
            swap(nums[smallest], nums[u]);
            heapify(nums, smallest, heapSize);
        }
    }
    void buildMinHeap(vector<int>& nums, int heapSize) {
        for (int i = nums.size() / 2; i >= 0; i--)
            heapify(nums, i, heapSize);
    }

public:
    vector<int> sortArray(vector<int>& nums) {
        vector<int> ans;
        int heapSize = nums.size();
        buildMinHeap(nums, heapSize);
        for (int i = heapSize - 1; i >= 0; i--) {
            ans.push_back(nums[0]);
            swap(nums[0], nums[i]);
            heapify(nums, 0, i);
        }
        return ans;
    }
};
```