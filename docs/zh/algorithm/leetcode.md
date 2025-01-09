# Leetcode

## 刷前指引

本笔记记录本人刷题思路

### 刷题网站推荐

以下网站提供了比较系统的刷题题单以及刷题思路讲解

- 代码随想录（配合B站视频食用）[https://programmercarl.com/](https://programmercarl.com/)
- labuladong的算法笔记 [https://labuladong.online/algo/home/](https://labuladong.online/algo/home/)

### 华为推荐题型List

递归：leetcode70、112、509
分治：leetcode23、169、240
单调栈：leetcode84、85、739、503
并查集：leetcode547、200、684
滑动窗口：leetcode209、3、1004、1208
前缀和：leetcode724、560、437、1248
差分：leetcode1094、121、122
拓扑排序：leetcode210
字符串：leetcode5、20、43、93
二分查找：leetcode33、34
BFS：leetcode127、139、130、529、815
DFS&回溯：leetcode934、685、1102、531、533、113、332、337
动态规划：leetcode213、123、62、63、361、1230
贪心：leetcode55、435、621、452
字典树：leetcode820、208、648



## 数组

### 704 二分查找

```c++
class Solution {
public:
    int search(vector<int>& nums, int target) {
        int n = nums.size();
        // 定义搜索范围为左闭右开
        // 初始搜索范围为[o,n)
        int l = 0, r = n;
        // 因为是左闭右开，所以l == r时[l,r)没有意义
        // 因此是l < r 不是l <= r
        while(l < r){
            // 二分搜索核：取中间索引
            int mid = l + r >> 1;
            // 如果target < nums[mid] 说明右边界r需要更新，更新为mid
            // 不是r == mid - 1，因为这是左闭右开区间，target一定不在mid上
            if(target < nums[mid]) r = mid;
            // 如果target > nums[mid] 说明左边界l需要更新，更新为mid + 1
            // l == mid + 1，因为左闭右开区间，target可能为在mid + 1
            else if(target > nums[mid]) l = mid + 1;
            // 如果target == nums[mid]，mid为我们需要的索引，返回
            else    return mid;
        }
        return -1;
    }
};
```

时间复杂度：O(log n)

空间复杂度：O(1)



### 27 移除元素

本题重点：数组删除第i个元素的方法：将i之后的元素依次左移1位

#### 暴力做法

```C++
class Solution {
public:
    int removeElement(vector<int>& nums, int val) {
        int size = nums.size();
        for(int i = 0; i < size; i++){
            // 找到数值等于val的元素
            if(val == nums[i]){
                // 数组删除第i个元素的方法：将i之后的元素依次左移1位
                for(int j = i + 1; j < size; j++){
                    nums[j - 1] = nums[j];
                }
                // 删除第i个元素，第i个元素变成新元素，下一次依然从i开始遍历
                i--;
                // 删除元素后，数组大小减1
                size--;
            }
        }
        // 数组剩余的都是不等于val的元素
        // 因此返回数组大小即可
        return size;
    }
};
```

时间复杂度：$O(n^2)$

空间复杂度：$O(1)$



#### 双指针法

```C++
class Solution {
public:
    int removeElement(vector<int>& nums, int val) {
        // 慢指针指向新数组末尾元素的下一个位置（插入的位置）
        // 新数组元素：数值不等于val的元素
        int slowIndex = 0;
        // 快指针指向从左到右数值不等于val的第一个元素
        for(int fastIndex = 0; fastIndex < nums.size(); fastIndex++){
            if(val != nums[fastIndex]){
                // 如果fastIndex指向的元素不等于val，需要将其加入到新数组中
                nums[slowIndex] = nums[fastIndex];
                slowIndex++;
            }
        }
        // 慢指针指向新数组末尾元素的下一个位置
        // 因为元素索引从0开始，所以slowIndex就是元素个数
        return slowIndex;
    }
};
```

时间复杂度：$O(n)$

- 只遍历了一次数组

空间复杂度：$O(1)$



### 977 有序数组的平方

#### 暴力做法

每个数平方之后再使用`sort()`排序

```C++
class Solution {
public:
    vector<int> sortedSquares(vector<int>& nums) {
        for(int i = 0; i < nums.size(); i++){
            nums[i] *= nums[i];
        }
        sort(nums.begin(),nums.end());
        return nums;
    }
};
```

时间复杂度： $O(n + nlogn)$

空间复杂度： $O(n)$



#### 双指针法

观察数组，我们可以发现，位于数组两端的数的绝对值比中间大，因此它们的平方值也比中间大

因此我们可以从两端向中间遍历比较，将较大值放入新数组中

```C++
class Solution {
public:
    vector<int> sortedSquares(vector<int>& nums) {
        int n = nums.size();
        // 新数组末尾元素的位置
        int k = n - 1;
        // 新开一个数组
        vector<int> res(n, 0);
        // 左闭右闭区间[0,k]
        int left = 0, right = k;
        // 左闭右闭区间[left,right]
        while(left <= right){
            int leftSquare = nums[left] * nums[left];
            int rightSquare = nums[right] * nums[right];
            if(leftSquare > rightSquare){
                // 题目要求数组非递减顺序，因此较大值放在数组末尾
                res[k--] = leftSquare;
                left++;
            }
            else{
                res[k--] = rightSquare;
                right--;
            }
        }
        return res;
    }
};
```

时间复杂度： $O(n + nlogn)$

空间复杂度： $O(n)$



### 209 长度最小的子数组

#### 暴力做法（不能通过）

```C++
class Solution {
public:
    int minSubArrayLen(int target, vector<int>& nums) {
        int len = INT_MAX;
        for(int i = 0; i < nums.size(); i++){
            int sum = 0;
            for(int j = i; j < nums.size(); j++){
                sum += nums[j];
                if(sum >= target)
                    len = min(len, j - i + 1);
            }
        }
        return len == INT_MAX ? 0 : len;
    }
};
```

时间复杂度：$O(n^2)$

空间复杂度：$O(1)$



#### 双指针法

```C++
class Solution {
public:
    const int INF = 0x3f3f3f3f;
    int minSubArrayLen(int target, vector<int>& nums) {
        int leftIndex = 0;
        int len = INF;
        int sum = 0;
        // 移动滑动窗口出口
        for(int rightIndex = leftIndex; rightIndex < nums.size(); rightIndex++){
            sum += nums[rightIndex];
            // 移动滑动窗口入口
            while(sum >= target){
                len = min(len, rightIndex - leftIndex + 1);
                // 关键步骤，不要忘记！
                sum -= nums[leftIndex];
                leftIndex++;
            }
        }
        return len == INF ? 0 : len;
    }
};
```

时间复杂度：O(n)

- rightIndex移动了n次，leftIndex移动了n次，共移动2n次

空间复杂度：O(1)

### 54 螺旋矩阵

和螺旋矩阵II n行n列 不同，螺旋矩阵这道题是m行n列，这意味着：

- 我们如果按螺旋矩阵左闭右开区间不一定能遍历完所有元素，例如对于1行2列[1,2]，按螺旋矩阵II的做法只能遍历元素1 -> 采用左闭右闭区间
- 我们需要定义四个变量：起始行和终止行，起始列和终止列
- 并且我们无法确定遍历的次数，因为行列长度不同 -> 采用while(true)

本题思路大致如下图：

![fig1](/Users/t/Desktop/xxxx2077.github.io/docs/algorithm/leetcode.assets/54_fig1.png)

```C++
class Solution {
public:
    vector<int> spiralOrder(vector<vector<int>>& matrix) {
        if(matrix.size() == 0 || matrix[0].size() == 0)
            return {};

        vector<int> ans;
        int startCol = 0, endCol = matrix[0].size() - 1; // 记录行的开头与结尾
        int startRow = 0, endRow = matrix.size() - 1; // 记录列的开头与结尾

        while(true)
        {
            // 从左往右
            for(int i = startCol; i <= endCol; i++)
                ans.push_back(matrix[startRow][i]);
            if(++startRow > endRow) break;

            // 从上往下
            for(int i = startRow; i <= endRow; i++)
                ans.push_back(matrix[i][endCol]);
            if(--endCol < startCol) break;

            // 从右往左
            for(int i = endCol; i >= startCol; i--)
                ans.push_back(matrix[endRow][i]);
            if(--endRow < startRow) break;

            // 从下往上
            for(int i = endRow; i >= startRow; i--)
                ans.push_back(matrix[i][startCol]);
            if(++startCol > endCol) break;
        }
        return ans;
    }
};
```

时间复杂度：O(mn)，其中 m 和 n 分别是输入矩阵的行数和列数。矩阵中的每个元素都要被访问一次。

空间复杂度：O(1)。除了输出数组以外，空间复杂度是常数。



### 59 螺旋矩阵II

> 思路参考：[https://programmercarl.com/0059.%E8%9E%BA%E6%97%8B%E7%9F%A9%E9%98%B5II.html#%E6%80%9D%E8%B7%AF](https://programmercarl.com/0059.%E8%9E%BA%E6%97%8B%E7%9F%A9%E9%98%B5II.html#%E6%80%9D%E8%B7%AF)

```C++
class Solution {
public:
    vector<vector<int>> generateMatrix(int n) {
       vector<vector<int>> res(n, vector<int>(n, 0));
       // 确定每一圈的起点(startx, starty)
       int startx = 0, starty = 0; 
       // 确定遍历的圈数
       // 计算方法：以第一圈为例，走完第一圈，第一行和最后一行都被遍历过，对称遍历
       // 因此遍历完整的圈数量为n/2次
       // 如果n是奇数，最后会剩下中心点mid未遍历，额外处理
       int loop = n / 2;
       // 我们规定每个圈分为四次遍历，每次遍历左闭右开区间（不包含每行/每列最后一个元素）
       // offset表示右边界收缩个数
       // 用于计算每行/每列遍历长度 n - offset
       int offset = 1;
       // count为待填充元素值
       int count = 1;
       while(loop--){
            // 提前定义坐标，接下来遍历的时候，每次坐标计算都需要使用上一次坐标位置
            int i = startx, j = starty;
            // 上行遍历长度n - offset,遍历区间为[starty, n - offset)
            // 这里条件为j < n - offset 因为是左闭右开区间
            for(j; j < n - offset; j++){
                res[i][j] = count++;
            }
            // 右列遍历长度n - offset,遍历区间为[startx, n - offset)
            // 这里条件为i < n - offset 因为是左闭右开区间
            for(i; i < n - offset; i++){
                res[i][j] = count++;
            }
            // 下行遍历长度n - offset,遍历区间为[n - offset, starty)
            // 这里条件为j > starty 因为是左闭右开区间
            for(j; j > starty; j--){
                res[i][j] = count++;
            }
            // 左列遍历长度n - offset,遍历区间为[n - offset, startx)
            // 这里条件为i > startx 因为是左闭右开区间
            for(i; i > startx; i--){
                res[i][j] = count++;
            }
            // 遍历一圈完成，更新参数
            // 更新下一个起点（沿右下对角线）
            startx++;
            starty++;
            // 更新下一次遍历长度（每走一圈，遍历长度减1）
            // 为什么减1: 因为每走一圈待遍历区间的左边界和右边界都会收缩
            // offset表示待遍历区间的右边界收缩个数
            // 我们的左边界永远不会被遍历，因为每次我们都设定左边界为新的startx/starty
            // 因此只有右边界就被遍历过了，需要减1，对应offset + 1
            offset++;
       }
       if(n % 2 != 0){
            int mid = n / 2;
            res[mid][mid] = count;
       }
       return res;
    }
};
```

时间复杂度 $O(n^2)$: 模拟遍历二维矩阵的时间

空间复杂度 $O(1)$



### 区间和

> 链接
>
> https://kamacoder.com/problempage.php?pid=1070

本题就是前缀和模板



### 53 最大子数组和

#### 前缀和

看到连续子数组的和会想到使用前缀和

但是不同的地方在于，我们需要保证连续子数组的和最大，也就是说假设区间`[j,i]`的和最大，`sum[i] - sum[j - 1]`最大

当我们遍历到`i`时，`sum[i]`可以i通过`sum[i] = sum[i - 1] + num[i]`获得，因此我们可以将其看作是定值

那么想要和最大，就需要`sum[j - 1]`最小，方法也很简单，只需要遍历的时候维护一个最小值前缀和`preMin`即可



**值得注意的是，计算顺序不能乱**，必须是：

1. 计算前缀和pre
2. 计算连续子数组和ans
3. 更新最小前缀和

如果Step2 和 Step3顺序交换，那么会出现`sum[i] - sum[j]`的情况，对应的区间是空的，而本题要求子数组至少含有一个元素

```C++
class Solution {
public:
    int maxSubArray(vector<int>& nums) {
        int pre = 0;
        // preMin初始化需要为0
        // 保证第一个元素的ans为pre
        int preMin = 0;
        // ans可能为负数，因此需要定义为最小值
        int ans = INT_MIN;
        for(int num : nums){
            // 更新前缀和
            pre += num;
            ans = max(ans, pre - preMin);
            preMin = min(preMin, pre);
        }
        return ans;
    }
};
```

- 时间复杂度：O(*n*)，其中 *n* 为 *nums* 的长度。
- 空间复杂度：O(1)。仅用到若干额外变量

#### 动态规划

思路也很简单：

- 因为连续子数组的和是否取当前元素，取决于本元素前的元素的连续子数组的和，这符合动态规划
- `dp[i]`表示`nums[i]`结尾的子数组的和的最大值
- 递推公式`dp[i] = max(dp[i - 1], 0) + nums[i]`
  - 如果前一个元素为负数，那么加上这个元素之后，连续子数组的和只会更小
  - 只有前一个元素为非负数，加上这个元素之后，连续子数组的和才会更大
- 初始化：`dp[0]`表示`nums[0]`结尾的子数组的和的最大值，也就是`nums[0]`
- 遍历顺序：从左到右

```C++
class Solution {
public:
    int maxSubArray(vector<int>& nums) {
        int n = nums.size();
        vector<int> dp(n);
        dp[0] = nums[0];
        int ans = dp[0];
        for(int i = 1; i < n; i++){
            dp[i] = max(dp[i - 1], 0) + nums[i];
            ans = max(ans,dp[i]);
        }
        return ans;
    }
};
```



### 56 合并区间

以下两种做法思路是一样的，第一种是我自己写的，第二种是别人的题解

> 我觉得第二种更不容易写错，建议第二种

#### 做法一

这种做法的思路是：

1. 对区间左端点进行排序
2. 通过取前一个区间的start和end，与当前区间的start和end进行比较，如果当前区间的start比前一个区间的end小，合并当前区间和前一个区间
3. 如果当前区间的start比前一个区间的end大，将前一个区间放入答案

我们来思考最后两个区间

当遍历结束到最后一个区间，有两种情况：

- 前一个区间的终点比当前区间的起点大，合并两个区间，`end = max(end,intervals[i][1])`; -> 此时合并后的区间没有放入答案
- 前一个区间的终点比当前区间的起点小，将前一个区间放入答案，更新`start = intervals[n - 1][0]`和`end = intervals[n - 1][1]`; -> 此时最后一个区间没有放入答案

因此，我们需要多加一步，将最后的区间放入答案`ans.push_back({start, end});`

```C++
class Solution {
public:
    vector<vector<int>> merge(vector<vector<int>>& intervals) {
        int n = intervals.size();
      	// 对区间左端点进行排序
        sort(intervals.begin(), intervals.end());
      	// 前一个区间[start, end]的初始化
        int start = intervals[0][0];
        int end = intervals[0][1];
        vector<vector<int>> ans;
        for (int i = 1; i < n; i++) {
          	// 如果前一个区间的终点比当前区间的起点大，说明要合并两个区间
            if (intervals[i][0] <= end)
                end = max(end,intervals[i][1]);
          	// 否则，将前一个区间纳入答案，更新前一个区间[start, end]
            else {
                ans.push_back({start, end});
                start = intervals[i][0];
                end = intervals[i][1];
            }
        }
      	// 以上处理了前n - 1个区间，还有最后一个区间没有放入答案
        ans.push_back({start, end});
        return ans;
    }
};
```



#### 做法二

做法二聚焦于当前的区间，前一个区间放在ans的末端（把ans视作栈，`ans.back()`就是栈顶，通过更新`ans.back()`完成合并区间）

放入答案的方式是将当前区间放入ans（做法一是将前一个区间放入ans）

```C++
class Solution {
public:
    vector<vector<int>> merge(vector<vector<int>>& intervals) {
        sort(intervals.begin(), intervals.end());
        vector<vector<int>> ans;
        for(auto interval : intervals){
            if(!ans.empty() && ans.back()[1] >= interval[0])
                ans.back()[1] = max(ans.back()[1], interval[1]);
            else
                ans.push_back(interval);
        }
        return ans;
    }
};
```



### 189 轮转数组

k没有说一定比数组长度小，所以需要做取余处理`k = k % nums.size();`

#### 做法一

```C++
class Solution {
public:
    void rotate(vector<int>& nums, int k) {
        int n = nums.size();
        vector<int> newArr(n);
        for(int i = 0; i < n; i++){
            int idx = (i + k) % n;
            newArr[idx] = nums[i];
        }
        nums.assign(newArr.begin(), newArr.end());
    }
};
```

时间复杂度：$O(n)$

空间复杂度：$O(n)$

#### 做法二

> 我也想不出怎么解释这个思路的来源，只能死记了

思路见[https://leetcode.cn/problems/rotate-array/solutions/2784427/tu-jie-yuan-di-zuo-fa-yi-tu-miao-dong-py-ryfv/?envType=study-plan-v2&envId=top-100-liked](https://leetcode.cn/problems/rotate-array/solutions/2784427/tu-jie-yuan-di-zuo-fa-yi-tu-miao-dong-py-ryfv/?envType=study-plan-v2&envId=top-100-liked)

```C++
class Solution {
public:
    void rotate(vector<int>& nums, int k) {
        k = k % nums.size();
        reverse(nums.begin(), nums.end());
        reverse(nums.begin(), nums.begin() + k);
        reverse(nums.begin() + k, nums.end());
    }
};
```

时间复杂度：$O(n)$

空间复杂度：$O(1)$



### 238 除自身以外数组的乘积

#### 暴力解法（超时）

```C++
class Solution {
public:
    vector<int> productExceptSelf(vector<int>& nums) {
        int n = nums.size();
        vector<int> ans;
        for(int i = 0; i < n; i++){
            int res = 1;
            for(int j = 0; j < i; j++){
                res *= nums[j];
            }
            for(int j = i + 1; j < n; j++){
                res *= nums[j];
            }
            ans.push_back(res);
        }
        return ans;
    }
};
```

时间复杂度：$O(n^2)$

空间复杂度：$O(n)$



#### 动态规划

类似于前缀和的思路，我们计算前缀乘积和后缀乘积

那么`nums[i]`除自身以外的乘积为`pre[i] * suf[i]`

```C++
class Solution {
public:
    vector<int> productExceptSelf(vector<int>& nums) {
        int n = nums.size();
        vector<int> pre(n + 1, 1);
        vector<int> suf(n + 1, 1);
        vector<int> ans;
        for(int i = 1; i < n; i++)
            pre[i] = pre[i - 1] * nums[i - 1];
        for(int i = n - 2; i >= 0; i--)
            suf[i] = suf[i + 1] * nums[i + 1];
        for(int i = 0; i < n; i++){
            int res = pre[i] * suf[i];
            ans.push_back(res);
        }
        return ans;
    }
};
```

时间复杂度：$O(n)$

空间复杂度：$O(n)$



#### 双指针

思路：

在动态规划做法中，我们使用了前缀乘积和后缀乘积，我们知道前缀和可以优化为一个变量，前缀乘积和后缀乘积同理

- 前缀乘积：i从左到右遍历，pre *= nums[i]
- 后缀乘积：j从右到左遍历，suf *= nums[j]
- 在$O(n)$时间复杂度内完成，意味着i和j在一个循环内移动，也就是异侧双指针
- 我们将问题分解：
  - 元素nums[i]右边元素的乘积，也就是ans[i] *= suf
  - 元素nums[i]左边元素的乘积，也就是ans[i] *= pre
  - 在一个循环内完成，因此有ans[left] *= pre，ans[right] *= suf （left从0到n - 1，right从n - 1到0），也就是left和right分别遍历一遍数组就能完成计算

```C++
class Solution {
public:
    vector<int> productExceptSelf(vector<int>& nums) {
        int n = nums.size();
        vector<int> ans(n,1);
        int pre = 1, suf = 1;
      	// left < n && right >= 0可简化为left < n 或 right >= 0
        for(int left = 0, right = n - 1; left < n && right >= 0; left++, right--){
            ans[left] *= pre;
            ans[right] *= suf;
            pre *= nums[left];
            suf *= nums[right];
        }
        return ans;
    }
};
```

时间复杂度：$O(n)$

空间复杂度：$O(1)$



### 41 缺失的第一个正数

题目要求$O(n)$的时间复杂度和$O(1)$的空间复杂度，这意味着：

- $O(1)$的空间复杂度 -> 只能在数组本身操作，不能使用 “把所有元素放入哈希表，再遍历查询”的方法
- $O(n)$的时间复杂度 -> 不能使用“先排序再二分查找“的方法

以下方法名为”原地哈希“，将值为1的元素放到索引0，值为2的元素放到索引1，值为i的元素放到索引i - 1...因此有nums[i] = i + 1

具体做法：

1. 计算当前元素值对应的索引idx，idx = nums[i] - 1
2. 找到索引对应的元素nums[idx]
3. 交换nums[i]和nums[idx]
4. 交换后，nums[i]为新值，需要继续重复以上做法，直到满足nums[i] == i + 1

当然，要注意以下条件：

- 本题求的是正整数，因此值为负数的元素可忽略
- n为数组长度，这意味着：n + 1是一定缺失的（如果某个元素大于等于n + 1，我们最后也会返回n + 1）
  - 如果找不到前n个缺失的正整数，那么缺失的就是n + 1（n为数组长度）
  - 如果某个元素值大于等于n + 1，那么也可以忽略，不用哈希

```C++
class Solution {
public:
    int firstMissingPositive(vector<int>& nums) {
        int n = nums.size();
        for(int i = 0; i < n; i++){
            while(nums[i] != i + 1){
                // 如果当前数是负数，不需要哈希
                // 如果当前数为 n + 1， 不需要哈希，因为在前面的 n 个元素都找不到的情况下，我们才返回 n + 1
                // 如果当前数和想要交换的数相同，需要跳出循环，否则会死循环
                if(nums[i] <= 0 || nums[i] > n || nums[i] == nums[nums[i] - 1])
                    break;
                // 交换两个数
                int idx = nums[i] - 1;
                nums[i] = nums[idx];
                nums[idx] = idx + 1;
              	// 等价于
              	// int idx = nums[i] - 1;
              	// swap(nums[idx], nums[i]);
            }
        }
        // 遍历一遍数组找到不符合的正整数
        for(int i = 0;i < n;i++){
            if(nums[i] != i + 1)
                return i + 1;
        }
        // 如果没有，则返回n + 1
        return n + 1;
    }
};
```

$O(n)$的时间复杂度 

$O(1)$的空间复杂度 



### 总结

> 数组总结补充参考
>
> https://programmercarl.com/%E6%95%B0%E7%BB%84%E6%80%BB%E7%BB%93%E7%AF%87.html#%E6%80%BB%E7%BB%93

#### 数组的双指针法

##### 同侧双指针

> 对应题目
>
> - 27
> - 209

同侧双指针：指指针slowIndex和fastIndex都从左到右遍历

这类方法通常应用于以下for循环的优化

```C++
for(int i = 0; i < nums.size(); i++){
		for(int j = i; j < nums.size(); j++){
			//算法步骤
	}
}
```

在以上for循环中，先移动j满足题意后，再移动i

移动i的过程重复了移动j的过程

例如：

- 第一次i=0，假设j到达5满足题意停止
- 第二次i=1，j要重新从0出发，重新经历[0,5]的过程才能到达新元素nums[6]

重新经历[0,5]这一过程是多余的，可以被优化的，因此我们引入双指针

**在双指针中**

- 第一次slowIndex = 0（对应i = 0），fastIndex = 0（对应j = 0）, fastIndex到达5满足题意停止
- 接下来不需要重新经历[0,5]的过程，只需要将slowIndex加一（对应i=1）

模板

```c++
for(int fastIndex = 0; i < nums.size(); i++){
		while(//题意){
				slowIndex++;
		}
}
```



##### 异侧双指针

> 题目：
>
> - 977

从数组两边往中间遍历，用于对数组两侧元素依次执行算法操作

```C++
int leftIndex = 0, rightIndex = nums.size() - 1;
while(leftIndex <= rightIndex){
		if(nums[leftIndex]满足...){
				/...
				leftIndex++;
		}
		if(nums[rightIndex]满足...){
				/...
				rightIndex--;
		}
}
```



## 链表

### 203 移除链表元素

移除链表元素本质上步骤为：

1. 找到待移除元素curNode的前驱节点prevNode和后继节点nextNode(curNode->next)
2. prevNode->next = curNode->next 
3. 释放内存delete curNode

有两种做法：原链表操作和引入哑节点

- 原链表操作意味着需要分两步操作

  1. 因为头部节点没有前驱节点，因此需要额外处理。处理方法很简单：

     ```C++
     ListNode* tmp = head;
     head = head->next
     delete tmp;
     ```

  2. 其他节点正常处理

- 引入哑节点

  - 引入哑节点有个好处是，所有节点（包括头节点）能够采用统一的操作，因为它让头节点也拥有了前驱节点

#### 原链表操作

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
    ListNode* removeElements(ListNode* head, int val) {
        if(!head)
            return head;
        while(head && head->val == val){
            ListNode* tmp = head;
            head = head->next;
            delete tmp;
        }
        
        //到这一步，head有两种可能，nullptr 或者 head->val != val
        ListNode* cur = head;
        // cur可能为nullptr，因此需要判断cur是否为nullptr再取cur->next
        // cur->next可能为空，所以需要判断cur->next是否为nullptr再取cur->next->val
        while(cur && cur->next){
            if(cur->next->val == val){
                ListNode* tmp = cur->next;
                cur->next = cur->next->next;
                delete tmp;
            }
            else
                cur = cur->next;
        }

        return head;
    }
};
```



#### 引入哑节点

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
    ListNode* removeElements(ListNode* head, int val) {
        // 为了保证操作的统一性，引入哑节点
        ListNode* dummyNode = new ListNode(-1,head);
        ListNode* cur = dummyNode;
        // 边界条件：判断要删除的节点是否为空
        while(cur->next != nullptr){
            if(cur->next->val == val){
                ListNode* tmp = cur->next;
                cur->next = tmp->next;
                delete tmp;
            }
            // 这里要注意：一定要用else
            // 因为删了节点之后，cur->next改变了，需要先判断cur->next是否为空再取cur->next->val
            else
                cur = cur->next;
        }
        head = dummyNode->next;
        delete dummyNode;
        return head;
    }
};
```



### 707 设计链表

dummyNode对应索引为-1，之后的节点才是真节点，索引从0开始

**for循环遍历方法**

`i`对应真节点的索引

因此`i == 0`时，`cur = cur->next`执行一次到达索引0的元素

- 遍历到指定index的元素：`for(int i = 0; i <= index; i++)`
- 遍历到指定index元素的前一个元素：`for(int i = 0; i < index; i++)`

```C++
class MyLinkedList {
private:
    ListNode *dummyNode;
    int size;
public:
    MyLinkedList() {
        dummyNode = new ListNode();
        size = 0;
    }
    
    int get(int index) {
        if(index < 0 || index >= size)
            return -1;
        ListNode* cur = dummyNode;
        for(int i = 0; i <= index; i++){
            cur = cur->next;
        }
        return cur->val;
    }
    
    void addAtHead(int val) {
        ListNode* newHead = new ListNode(val);
        newHead->next = dummyNode->next;
        dummyNode->next = newHead;
        size++;
    }
    
    void addAtTail(int val) {
        ListNode* newNode = new ListNode(val);
        ListNode* cur = dummyNode;
        while(cur->next){
            cur = cur->next;
        }
        cur->next = newNode;
        size++;
    }
    
    void addAtIndex(int index, int val) {
        if(index < 0 || index > size)  
            return;        
        ListNode* cur = dummyNode;
        for(int i = 0; i < index; i++){
            cur = cur->next;
        }
        ListNode* newNode = new ListNode(val,cur->next);
        cur->next = newNode;
        size++;
    }
    
    void deleteAtIndex(int index) {
        if(index < 0 || index >= size)
            return;
        ListNode* cur = dummyNode;
        for(int i = 0; i < index; i++){
            cur = cur->next;
        }
        ListNode* tmp = cur->next;
        cur->next = cur->next->next;
        delete tmp;
        size--;
    }
};

/**
 * Your MyLinkedList object will be instantiated and called as such:
 * MyLinkedList* obj = new MyLinkedList();
 * int param_1 = obj->get(index);
 * obj->addAtHead(val);
 * obj->addAtTail(val);
 * obj->addAtIndex(index,val);
 * obj->deleteAtIndex(index);
 */
```

时间复杂度: 涉及 `index` 的相关操作为 O(index), 其余为 O(1)

空间复杂度: O(n)



### 206 反转链表

#### 迭代版

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
    ListNode* reverseList(ListNode* head) {
        ListNode* prev = nullptr;
        ListNode* cur = head;
        while(cur){
            ListNode* next = cur->next;
            cur->next = prev;
            prev = cur;
            cur = next;
        }
      	// cur指向nullptr, prev指向原链表最后一个元素（新链表头节点）
        return prev;
    }
};
```

**复杂度分析**

- 时间复杂度：*O*(*n*)，其中 *n* 是链表的长度。需要遍历链表一次。
- 空间复杂度：*O*(1)。

#### 递归版

**和迭代法同一思路的递归版**

核心思路：

- 通过递归函数依次将链表节点压栈，使算法到达链表最后一个节点再进行反转操作
- 每次递归函数执行同一反转操作，但是返回的是反转后的函数头
- 反转操作cur->next = prev（与迭代法相同）

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
private:
    ListNode* reverse(ListNode* prev, ListNode* cur){
        // 当cur为空，说明已经到达最后一个链表节点
        // 此时最后一个链表节点为prev，它就是反转后的头节点
        if(!cur)
            return prev;
        ListNode* newHead = reverse(cur, cur->next);
        cur->next = prev;
        return newHead;
    }
public:
    ListNode* reverseList(ListNode* head) {
        return reverse(nullptr,head);
    }
};
```

这是另一种递归版

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
    ListNode* reverseList(ListNode* head) {
        if(!head || !head->next)
            return head;
        ListNode* newHead = reverseList(head->next);
        head->next->next = head;
        head->next = nullptr;
        return newHead;
    }
};
```

**复杂度分析**

时间复杂度：O(n)，其中 n 是链表的长度。需要对链表的每个节点进行反转操作。

空间复杂度：O(n)，其中 n 是链表的长度。空间复杂度主要取决于递归调用的栈空间，最多为 n 层。



### 24 两两交换链表中的节点

> 这道题看这个解析吧
>
> [https://programmercarl.com/0024.%E4%B8%A4%E4%B8%A4%E4%BA%A4%E6%8D%A2%E9%93%BE%E8%A1%A8%E4%B8%AD%E7%9A%84%E8%8A%82%E7%82%B9.html#%E6%80%9D%E8%B7%AF](https://programmercarl.com/0024.%E4%B8%A4%E4%B8%A4%E4%BA%A4%E6%8D%A2%E9%93%BE%E8%A1%A8%E4%B8%AD%E7%9A%84%E8%8A%82%E7%82%B9.html#%E6%80%9D%E8%B7%AF)

解答几个问题

- 为什么cur取 待交换元素的前一个位置
  - 因为交换之后，还要保持链表相连，cur取上一次交换后的末尾位置，能够保证链表相连

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
    ListNode* swapPairs(ListNode* head) {
        ListNode* dummyNode = new ListNode(-1, head);
        ListNode* cur = dummyNode;
        while (cur->next && cur->next->next) {
            // 保存原有的几个元素
            ListNode* tmp1 = cur->next;
            ListNode* tmp2 = cur->next->next;
            ListNode* tmp3 = cur->next->next->next;
            // 调整元素位置
            cur->next = tmp2;
            cur->next->next = tmp1;
            cur->next->next->next = tmp3;
            // 移动到下一个位置
            cur = cur->next->next;
        }
        ListNode* newHead = dummyNode->next;
        delete dummyNode;
        return newHead;
    }
};
```

- 时间复杂度：O(n)
- 空间复杂度：O(1)



### 19 删除链表的第N个节点

> 可参考
> https://programmercarl.com/0019.%E5%88%A0%E9%99%A4%E9%93%BE%E8%A1%A8%E7%9A%84%E5%80%92%E6%95%B0%E7%AC%ACN%E4%B8%AA%E8%8A%82%E7%82%B9.html#%E6%80%9D%E8%B7%AF

为什么需要移动n + 1步

- 题目要求的是倒数第n个节点
- 我们假设fast刚好位于末尾元素的下一个位置，值为nullptr
- 为了方便删除倒数第n个节点，slow需要位于倒数第n + 1位置
- 因此slow与fast位置分别为第n + 1个元素和第0个元素（从右往左数），fast需要移动n + 1次

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
    ListNode* removeNthFromEnd(ListNode* head, int n) {
        ListNode* dummyNode = new ListNode(-1, head);
        ListNode *fast = dummyNode, *slow = dummyNode;
        // fast需要移动n + 1步，以保证slow刚好在倒数第n个节点的前一个节点
        for (int i = 1; i <= n + 1 && fast; i++) {
            fast = fast->next;
        }
        while (fast) {
            fast = fast->next;
            slow = slow->next;
        }

        ListNode* tmp = slow->next;
        slow->next = slow->next->next;
        delete tmp;

        ListNode* newHead = dummyNode->next;
        delete dummyNode;
        return newHead;
    }
};
```

- 时间复杂度: O(n)
- 空间复杂度: O(1)



### 160 相交链表

https://leetcode.cn/problems/intersection-of-two-linked-lists/?envType=study-plan-v2&envId=top-100-liked

#### 容易理解的方法

1. 计算两个链表的长度
2. 计算长度差gap
3. 长的一侧先走gap个长度，走完后，两个链表处于同一长度
4. 两个链表同时遍历，如果p1 == p2，则相遇；如果p1(p2) == nullptr，说明无法相遇

```C++
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
class Solution {
public:
    ListNode* getIntersectionNode(ListNode* headA, ListNode* headB) {
        ListNode *p1 = headA, *p2 = headB;
        int lenA = 0, lenB = 0;
        while (p1) {
            lenA++;
            p1 = p1->next;
        }
        while (p2) {
            lenB++;
            p2 = p2->next;
        }
        p1 = headA;
        p2 = headB;
        if (lenB > lenA) {
            swap(lenB, lenA);
            swap(p1,p2);
        }
        int gap = lenA - lenB;
        while (gap--) {
            p1 = p1->next;
        }
        while (p1) {
            if(p1 == p2)
                return p1;
            p1 = p1->next;
            p2 = p2->next;
        }
        return nullptr;
    }
};
```

- 时间复杂度：O(n + m)
- 空间复杂度：O(1)

#### 难以理解的方法

拼接链表A和链表B，拼接后，两个链表同时开始往尾部遍历，

```C++
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
class Solution {
public:
    ListNode *getIntersectionNode(ListNode *headA, ListNode *headB) {
        ListNode* a = headA, *b = headB;
        while(a != b){
            a = a != nullptr ? a->next : headB;
            b = b != nullptr ? b->next : headA;
        }
        return a;
    }
};
```





### 141 环形链表

根据题意：一个节点没有环

```C++
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
class Solution {
public:
    bool hasCycle(ListNode *head) {
        if(head == nullptr || head->next == nullptr)
            return false;
        ListNode* fast = head, *slow = head;
        while(true){
            if(fast == nullptr || fast->next == nullptr)
                return false;
            fast = fast->next->next;
            slow = slow->next;
          	if(fast == slow) 
              	break;
        }
        return true;
    }
};
```

### 142 环形链表II

思路

- 设定快慢指针，如果有环，快指针一定能和慢指针相遇（反推也成立：能相遇说明有环）；如果没环，快指针会到达链表末尾变为nullptr
- 本题还需要找环的入口，通过推理我们得到：相遇后，设定一个指针在head起始位置，另一个在相遇位置，两个指针同时走相同步数一定能在环入口相遇

具体推导证明过程见[https://programmercarl.com/0142.%E7%8E%AF%E5%BD%A2%E9%93%BE%E8%A1%A8II.html#%E6%80%9D%E8%B7%AF](https://programmercarl.com/0142.%E7%8E%AF%E5%BD%A2%E9%93%BE%E8%A1%A8II.html#%E6%80%9D%E8%B7%AF)

```C++
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
class Solution {
public:
    ListNode *detectCycle(ListNode *head) {
        ListNode* fast = head, *slow = head;
        // 注意边界条件
        while(fast && fast->next){
            fast = fast->next->next;
            slow = slow->next;
            // fast == slow说明存在环，但是仍然不知道环的入口在哪里
            // 为了寻找环的入口进行额外的操作
            if(fast == slow){
                // 通过推导，设定一个指针在head起始位置，另一个在相遇位置
                // 两个指针同时走相同步数一定能在环入口相遇
                ListNode* p1 = fast;
                ListNode* p2 = head;
                while(p1 != p2){
                    p1 = p1->next;
                    p2 = p2->next;
                }
                return p1;
            }
        }
        // fast != slow说明不存在环，当fast为空或fast->next为空停止循环
        return nullptr;
    }
};
```



## 矩阵

### 73 矩阵置零

#### 暴力解法

定义行数组`row`和列数组`col`表示行/列有元素0

遍历一遍矩阵，找到元素0时，更新行数组`row`和列数组`col`为true

判断`row[i] || col[j]`时，令矩阵为0

```C++
class Solution {
public:
    void setZeroes(vector<vector<int>>& matrix) {
        int n = matrix.size();
        int m = matrix[0].size();
        vector<bool> row(n, false), col(m, false);
        for(int i = 0; i < n; i++){
            for(int j = 0; j < m; j++){
                if(!matrix[i][j]){
                    row[i] = true;
                    col[j] = true;
                }
            }
        }
        for(int i = 0; i < n; i++){
            for(int j = 0; j < m; j++){
                if(row[i] || col[j])
                    matrix[i][j] = 0;
            }
        }
    }
};
```

#### 优化1

我们可以使用矩阵的第一行和第一列代替行数组`row`和列数组`col`

但是这种代替方法会导致第一行和第一列原有的值丢失，因此我们需要保存第一行和第一列原有的值

```C++
class Solution {
public:
    void setZeroes(vector<vector<int>>& matrix) {
        int n = matrix.size();
        int m = matrix[0].size();
      	// 保存第一行和第一列是否含有元素0的状态
        bool firstRow = false, firstCol = false;
        for(int i = 0; i < n; i++){
            if(!matrix[i][0])
                firstCol = true;
        }
        for(int j = 0; j < m; j++){
            if(!matrix[0][j])
                firstRow = true;
        }
      	// 检测除了第一行和第一列外其他部分是否出现元素0
      	// matrix[i][0]保存第i行是否要置为0
      	// matrix[0][j]保存第j列是否要置为0
        for(int i = 1; i < n; i++){
            for(int j = 1; j < m; j++){
                if(!matrix[i][j]){
                    matrix[i][0] = 0;
                    matrix[0][j] = 0;
                }
            }
        }
      	// 将矩阵对应行/列置为0（不包括第一行和第一列）
        for(int i = 1; i < n; i++){
            for(int j = 1; j < m; j++){
                if(!matrix[i][0] || !matrix[0][j])
                    matrix[i][j] = 0;
            }
        }
      	// 第一行和第一列额外处理
        if(firstRow){
            for(int j = 0; j < m; j++)
                matrix[0][j] = 0;
        }
        if(firstCol){
            for(int i = 0; i < n; i++)
                matrix[i][0] = 0;
        }
    }
};
```



#### 优化2

优化1使用了两个标记变量`firstRow`和`firstCol`，我们还可以优化为一个标记变量

> 但是我觉得不是特别必要这样优化
>
> 思路见
>
> https://leetcode.cn/problems/set-matrix-zeroes/solutions/669901/ju-zhen-zhi-ling-by-leetcode-solution-9ll7/?envType=study-plan-v2&envId=top-100-liked



### 48 旋转图像

官方题解已经说的非常详细

[https://leetcode.cn/problems/rotate-image/?envType=study-plan-v2&envId=top-100-liked](https://leetcode.cn/problems/rotate-image/?envType=study-plan-v2&envId=top-100-liked ) 

#### 普通做法

```C++
class Solution {
public:
    void rotate(vector<vector<int>>& matrix) {
        int n = matrix.size();
        vector<vector<int>> newMatrix(n, vector<int>(n, 0));
        for(int i = 0; i < n; i++){
            for(int j = 0; j < n; j++){
                newMatrix[j][n - 1 - i] = matrix[i][j];
            }
        }
        matrix.assign(newMatrix.begin(),newMatrix.end());
    }
};
```



#### 原地旋转

##### 方法一

```C++
class Solution {
public:
    void rotate(vector<vector<int>>& matrix) {
        int n = matrix.size();
        for (int row = 0; row < n / 2; row++) {
            for (int col = 0; col < (n + 1) / 2; col++) {
                int temp = matrix[row][col];
                matrix[row][col] = matrix[n - 1 - col][row];
                matrix[n - 1 - col][row] = matrix[n - 1 - row][n - 1 - col];
                matrix[n - 1 - row][n - 1 - col] = matrix[col][n - 1 - row];
                matrix[col][n - 1 - row] = temp;
            }
        }
    }
};
```

复杂度分析

时间复杂度：$O(N^2)$，其中 N 是 matrix 的边长。我们需要枚举的子矩阵大小为 $O(⌊n/2⌋×⌊(n+1)/2⌋)=O(N^2 )$。

空间复杂度：$O(1)$。为原地旋转。



##### 方法二

```C++
class Solution {
public:
    void rotate(vector<vector<int>>& matrix) {
        int n = matrix.size();
        //  先矩阵转置
        // 注意矩阵转置时，因为对称性，我们只需要遍历上三角
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                swap(matrix[i][j], matrix[j][i]);
            }
        }
        // 再左右对称的两列互换
        for (int j = 0; j < n / 2; j++) {
            for (int i = 0; i < n; i++) {
                swap(matrix[i][j], matrix[i][n - 1 - j]);
            }
        }
    }
};
```

复杂度分析

时间复杂度：$O(N^2)$，其中 N 是 matrix 的边长。对于每一次翻转操作，我们都需要枚举矩阵中一半的元素。

空间复杂度：$O(1)$。为原地翻转得到的原地旋转。



### 240 搜索二维矩阵II

https://leetcode.cn/problems/search-a-2d-matrix-ii/description/

#### 解法一：暴力枚举

无脑解法，没有利用题意“升序”

```C++
class Solution {
public:
    bool searchMatrix(vector<vector<int>>& matrix, int target) {
        for(int i = 0; i < matrix.size(); i++){
            for(int j = 0; j < matrix[i].size(); j++){
                if(matrix[i][j] == target)
                    return true;
            }
        }
        return false;
    }
};
```

**复杂度分析**

- 时间复杂度：*O*(*mn*)。
- 空间复杂度：*O*(1)。

#### 解法二：二分查找

利用题意“升序”可直接二分查找

```c++
class Solution {
public:
    bool searchMatrix(vector<vector<int>>& matrix, int target) {
      	// 这里要用引用，不然会报内存超出
        for(const auto &row : matrix){
            auto it = lower_bound(row.begin(), row.end(), target);
            if(it != row.end() && *it == target)   return true;
        }
        return false;
    }
};
```



#### 解法三：二叉搜索树

https://leetcode.cn/problems/search-a-2d-matrix-ii/solutions/2361487/240-sou-suo-er-wei-ju-zhen-iitan-xin-qin-7mtf

将矩阵逆时针旋转45度，将其变成二叉搜索树

以右上角为根节点

如果超出边界，说明无解

```c++
class Solution {
public:
    bool searchMatrix(vector<vector<int>>& matrix, int target) {
        int i = 0, j = matrix[0].size() - 1;
        while(i <= matrix.size() - 1 && j >= 0 ){
            if(matrix[i][j] == target) return true;
            if(matrix[i][j] < target) i++;
            else j--;
        }
        return false;
    }
};
```

## 

## 动态规划

### 基础题

#### 509 斐波那契数

https://leetcode.cn/problems/fibonacci-number/description/

##### 递归

```C++
class Solution {
public:
    int fib(int n) {
        if(n == 0)
            return 0;
        if(n == 1)
            return 1;
        return fib(n - 1) + fib(n - 2); 
    }
};
```

- 时间复杂度：$O(2^n)$
- 空间复杂度：$O(n)$，算上了编程语言中实现递归的系统栈所占空间

##### 动态规划

```C++
class Solution {
public:
    int fib(int n) {
        if(n <= 1)
            return n;
       vector<int> num(n + 1);
       num[0] = 0;
       num[1] = 1;
       for(int i = 2; i <= n; i++){
            num[i] = num[i - 1] + num[i - 2];
       } 
       return num[n];
    }
};
```

- 时间复杂度：$O(n)$
- 空间复杂度：$O(1)$

##### 动态规划优化

```C++
class Solution {
public:
    int fib(int n) {
        if(n <= 1)
            return n;
        int a = 0;
        int b = 1;
        int c;
        for(int i = 2; i <= n; i++){
            c = a + b;
            a = b;
            b = c;
        }
        return c;
    }
};
```

- 时间复杂度：$O(n)$
- 空间复杂度：$O(1)$

#### 70 爬楼梯

https://leetcode.cn/problems/climbing-stairs/description/

爬楼梯和斐波那契数不同之处在于：初始值不同

- 爬楼梯n == 1, dp[1] = 1; n == 2, dp[2] = 2
- 斐波那契数n == 0, dp[0] = 0; n == 1, dp[1] = 1; n == 2, dp[2] = 1;

##### 解法一：递归

```C++
class Solution {
public:
    int climbStairs(int n) {
        if(n <= 1)
            return 1;
        return climbStairs(n - 1) + climbStairs(n - 2);
    }
};
```

**时间复杂度：$O(2^n)$**

可视为二叉树，树高为n，节点数为$2^n$，遍历搜索树需要$2^n$次

**空间复杂度：$O(n)$**

n个栈空间

##### 解法二：记忆化搜索

```c++
class Solution {
private:
    vector<int> m;
    int dfs(int n){
        if(n <= 1)
            return 1;
        int &res = m[n];
        if(res)
            return res;
        return dfs(n - 1) + dfs(n - 2);
    }
public:
    int climbStairs(int n) {
        m.resize(n + 1);
        return dfs(n);
    }
};
```

**时间复杂度：$O(n)$**

每个状态只会计算一次，共n个状态

**空间复杂度：$O(n)$**

n个栈空间

##### 解法三：动态规划

```c++
class Solution {
public:
    vector<int> dp;
    int climbStairs(int n) {
        dp.resize(n + 1);
        dp[0] = 1;
        dp[1] = 1;
        for(int i = 2; i <= n; i++)
            dp[i] = dp[i - 1] + dp[i - 2];
        return dp[n];
    }
};
```

**时间复杂度：$O(n)$**

状态数n * 状态计算1次

**空间复杂度：$O(n)$**

n个状态

##### 解法四：空间优化

```c++
class Solution {
public:
    int climbStairs(int n) {
        int a = 0, b = 1, c;
        for(int i = 1; i <= n; i++){
            c = a + b;
            a = b;
            b = c;
        }
        return c;
    }
};
```

**时间复杂度：$O(n)$**

状态数n * 状态计算1次

**空间复杂度：$O(1)$**

只需3个变量



#### 746 使用最小花费爬楼梯

唯一需要注意的是初始化：

可以从第0阶或第1阶楼梯出发，说明到达这两阶楼梯不需要花费

因此dp[0]和dp[1]都为0，而不是cost[0]和cost[1]

##### 正常版

```C++
class Solution {
public:
    int minCostClimbingStairs(vector<int>& cost) {
        int n = cost.size();
        vector<int> dp(n + 1);
        dp[0] = 0;
        dp[1] = 0;
        // dp[i] 表示到达第i个台阶的最低花费
        for(int i = 2; i <= n; i++){
            dp[i] = min(dp[i - 1] + cost[i - 1], dp[i - 2] + cost[i - 2]);
        }
        return dp[n];
    }
};
```

**时间复杂度：$O(n)$**

**空间复杂度：$O(n)$**



##### 优化版

```C++
class Solution {
public:
    int minCostClimbingStairs(vector<int>& cost) {
        int n = cost.size();
        vector<int> dp(2);
        dp[0] = 0;
        dp[1] = 0;
        int res;
        // dp[i] 表示到达第i个台阶的最低花费
        for(int i = 2; i <= n; i++){
            res = min(dp[1] + cost[i - 1], dp[0] + cost[i - 2]);
            dp[0] = dp[1];
            dp[1] = res;
        }
        return res;
    }
};
```

**时间复杂度：$O(n)$**

**空间复杂度：$O(1)$**



#### 62 不同路径

##### 深搜（超时）

从左上(1,1)开始往下遍历，函数调用图和二叉树非常相似

重复大量无用节点

这棵树的深度其实就是m+n-1（深度按从1开始计算）。

那二叉树的节点个数就是$ 2^(m + n - 1) - 1$。可以理解深搜的算法就是遍历了整个满二叉树（其实没有遍历整个满二叉树，只是近似而已）

所以上面深搜代码的时间复杂度为$O(2^{m + n - 1} - 1)$，可以看出，这是指数级别的时间复杂度，是非常大的。

```C++
class Solution {
private:
    int dfs(int i, int j, int m, int n){
        if(i > m || j > n)  return 0;
        if(i == m && j == n)    return 1;
        return dfs(i + 1, j, m, n) + dfs(i, j + 1, m, n);
    }
public:
    int uniquePaths(int m, int n) {
        return dfs(1, 1, m, n);
    }
};
```



##### 动态规划

###### 两维做法

初始化`dp[i][0] = 1`和`dp[0][j] = 1`

```C++
class Solution {
public:
    int uniquePaths(int m, int n) {
        vector<vector<int>> dp(m, vector<int>(n, 0));
        // 由于机器人每次只能往下或往右
        // 所以dp[i][0]和dp[0][j]只有一条路
        for(int i = 0; i < m; i++) dp[i][0] = 1;
        for(int j = 0; j < n; j++) dp[0][j] = 1;
        // 从dp[i][j]开始，路径来源可以是dp[i - 1][j]和dp[i][j - 1]
        for(int i = 1; i < m; i++){
            for(int j = 1; j < n; j++){
                dp[i][j] = dp[i - 1][j] + dp[i][j - 1];
            }
        }
        return dp[m - 1][n - 1];
    }
};
```

时间复杂度：O(m × n)

空间复杂度：O(m × n)



###### 一维优化

`dp[i][j] = dp[i - 1][j] + dp[i][j - 1];`分析这一递推公式，我们能够发现：在从上到下，从左到右的递归顺序下：

`dp[i][j] = dp[i - 1][j] + dp[i][j - 1];`的效果和`dp[j] = dp[j] + dp[j - 1];`相同，因为dp[j]保存的就是`dp[i - 1][j]`的值，dp[j - 1]保存的就是`dp[i][j - 1]`的值，更新`dp[j]`之后`dp[j]`就变成了`dp[i][j]`

```C++
class Solution {
public:
    int uniquePaths(int m, int n) {
        vector<int> dp(n, 0);
        // 由于机器人每次只能往下或往右
        // 所以dp[i][0]和dp[0][j]只有一条路
        for(int j = 0; j < n; j++) dp[j] = 1;
        // 从dp[i][j]开始，路径来源可以是dp[i - 1][j]和dp[i][j - 1]
        for(int i = 1; i < m; i++){
          	// 这里从j = 0开始或者j = 1开始都可以，因为没有条件能够更改dp[i][0]的状态
            for(int j = 1; j < n; j++){
            		dp[j] = dp[j] + dp[j - 1];
            }
        }
        return dp[n - 1];
    }
};
```

时间复杂度：O(m × n)

空间复杂度：O(n)



###### 数论做法

一共$m - 1 + n -1 = n + m -2$步，选择其中m - 1步往下，得到组合数就是题解：$C_{n + m - 2}^{m - 1}$

见https://programmercarl.com/0062.%E4%B8%8D%E5%90%8C%E8%B7%AF%E5%BE%84.html#%E6%80%9D%E8%B7%AF



#### 63 不同路径II

##### 深搜（超时）

```C++
class Solution {
private:
    int dfs(vector<vector<int>>& obstacleGrid, int i, int j){
        int m = obstacleGrid.size();
        int n = obstacleGrid[0].size();
      	// obstacleGrid[i][j] == 1直接返回0
        if(i >= m || j >= n || obstacleGrid[i][j] == 1)  return 0;
        if(i == m - 1 && j == n - 1 && obstacleGrid[i][j] == 0)    return 1;
        return dfs(obstacleGrid, i + 1, j) + dfs(obstacleGrid, i, j + 1);
    }
public:
    int uniquePathsWithObstacles(vector<vector<int>>& obstacleGrid) {
        return dfs(obstacleGrid,0, 0);
    }
};
```



##### 动态规划

初始化的时候注意

`obstacleGrid[i][0] == 0`说明`dp[i + 1][0] == 0`及之后的`dp[i][0]`都为0

###### 二维做法

```c++
class Solution {
public:
    int uniquePathsWithObstacles(vector<vector<int>>& obstacleGrid) {
        int m = obstacleGrid.size();
        int n = obstacleGrid[0].size();
        vector<vector<int>> dp(m, vector<int>(n, 0));
        for(int i = 0; i < m && obstacleGrid[i][0] == 0; i++) {
            dp[i][0] = 1;
        }
        for(int j = 0; j < n && obstacleGrid[0][j] == 0; j++) {
            dp[0][j] = 1;
        }
        for(int i = 1; i < m; i++){
            for(int j = 1; j < n; j++){
                if(obstacleGrid[i][j] == 0)
                    dp[i][j] = dp[i - 1][j] + dp[i][j - 1];
                else
                    dp[i][j] = 0;
            }
        }
        return dp[m - 1][n - 1];
    }
};
```



###### 一维优化

```C++
class Solution {
public:
    int uniquePathsWithObstacles(vector<vector<int>>& obstacleGrid) {
        int m = obstacleGrid.size();
        int n = obstacleGrid[0].size();
        vector<int> dp(n, 0);
        // 这里不仅把dp[0][j]都初始化为1
        // 而且把dp[i][0](i == 0)初始化为1
        // 在之后的循环中，如果obstacleGrid[i][0] == 0那么dp[i][0]将一直保持为1
        for(int j = 0; j < n && obstacleGrid[0][j] == 0; j++) dp[j] = 1;
        for(int i = 1; i < m; i++){
            // 这里必须从j == 0开始
            // 因为如果obstacleGrid[i][0] == 1，需要将dp[i][0]更改状态为0
            // 一旦更改状态为0后，之后将一直保持状态为0
            for(int j = 0; j < n; j++){
                if(obstacleGrid[i][j] == 1)
                    dp[j] = 0;
                else if(j != 0)
                    dp[j] = dp[j] + dp[j - 1];
            }
        }
        return dp[n - 1];
    }
};
```



#### 343 整数划分

`dp[i]` 表示给定一个正整数 `n` ，将其拆分为 `k` 个 **正整数** 的和（ `k >= 2` ）所能得到的最大乘积

**递推公式**

$dp[i] = max(dp[i], max((i - j) * j, dp[i - j] * j))$;

- $(i - j) * j$表示只拆分两个正整数 (k == 2)
- $dp[i - j] * j$表示拆分多个正整数 (k > 2)

**遍历顺序**

`dp[i]`需要使用`dp[i -j]`，所以遍历顺序为从左到右

**初始化**

题意给出n >= 2，j从1开始遍历

因此需要初始化dp[2 - 1] 

n == 1，无法分解为k >= 2个正整数的和，因此dp[1] = 0

```C++
class Solution {
public:
    int integerBreak(int n) {
        vector<int> dp(n + 1, 0);
        // n >= 2，根据递推公式，初始化dp[2]
        dp[1] = 0;
        for (int i = 2; i <= n; i++) {
            for (int j = 1; j <= i / 2; j++) {
                // (i - j) * j表示只拆分一次 (k == 2)
                // dp[i - j] * j表示拆分多次
                dp[i] = max(dp[i], max((i - j) * j, dp[i - j] * j));
            }
        }
        return dp[n];
    }
};
```

- 时间复杂度：O(n^2)
- 空间复杂度：O(n)



#### 96 不同的搜索树

> 这道题正常人应该很难想到。。。

dp[i]表示节点1到节点i的搜索树个数

**递推公式**

$dp[i] = \sum_{1}^{i}j为头节点的搜索树个数$

j为头节点搜索树个数计算方法：dp[j - 1] * dp[i - j]

```C++
class Solution {
public:
    int numTrees(int n) {
        // dp[i]表示节点1到节点i的搜索树个数
        vector<int> dp(n + 1, 0);
        dp[0] = 1;
        for(int i = 1;i <= n; i++){
            // 枚举头节点, j为头节点的值
            // 根据搜索树特性，j - 1为左子树的个数， i - j为右子树的个数
            for(int j = 1; j <= i; j++){
                // 递推公式
                dp[i] += dp[j - 1] * dp[i - j];
            }
        }
        return dp[n];
    }
};
```



<<<<<<< HEAD
### 子序列系列

#### 300 最长递增子序列

##### 动态规划

思路：

- 题目求最长递增子序列，假设我们已经找了k个元素形成了子序列a，我们发现，如果想要继续增加新元素，需要关注子序列a最后一个元素`nums[i]`，**比较`nums[j]`与`nums[i]`的关系（j > i）**。这一步骤本质上关注的是子序列的末尾元素，对于子序列其他元素不关心。因此我们围绕末尾元素建模。

- 我们将`dp[i]`设置为第i个元素结尾的最长递增子序列长度，确认dp[i]含义后很容易得到递推公式

- 递推公式：

  遍历`nums[i]`之前的元素`nums[j]`，比较两者关系，如果`nums[i] > nums[j]`，`dp[i]  = dp[j] + 1`

  ```
  // 伪代码
  if(nums[i] > nums[j]) {
  	dp[i] = max(dp[j] + 1)，j从0遍历到i - 1
  }
  res = max(dp[i])，i从0遍历到i - 1
  ```

- 遍历顺序：从左到右或从右到左都可以，只需要将索引[0, i - 1]的元素遍历一遍，默认从左到右
- 初始化：每个元素结尾的最长递增子序列长度至少为1，即该元素本身，所以$dp[i] = 1, i \in [0, n - 1]$
- 结果：取$res = max(dp[i]), i \in [0, n - 1]$

```C++
class Solution {
public:
    int lengthOfLIS(vector<int>& nums) {
        int n = nums.size();
        // dp[i]表示以nums[i]结尾的最长严格递增子序列的长度
        // 默认为1，仅包含nums[i]
        vector<int> dp(n, 1);
        // 取dp[i]最大值为结果
        int res = 1;
        for(int i = 0; i < n; i++){
            // 遍历j从0到i - 1
            for(int j = 0; j < i; j++){
                if(nums[i] > nums[j])
                    dp[i] = max(dp[i], dp[j] + 1);
            }
            res = max(res, dp[i]);
        }
        return res;
    }
};
```

时间复杂度：$O(n^2 )$，其中 n 为数组 nums 的长度。动态规划的状态数为 n，计算状态 dp[i] 时，需要 O(n) 的时间遍历 dp[0…i−1] 的所有状态，所以总时间复杂度为 $O(n^2)$。

空间复杂度：$O(n)$，需要额外使用长度为 n 的 dp 数组



##### 贪心 + 二分查找

这个优化方法很容易想到，我们想要得到尽可能长的递增序列，就需要选择和当前末尾元素nums[i]尽可能大小相近的元素，从而减小序列上升速度

**选择和当前末尾元素nums[i]尽可能大小相近的元素**

- 这就是贪心的思路，我们寻找比nums[i]大的元素集合，再从中找到最小的元素即可

d[i] 表示长度为i的递增序列末尾元素的最小值

```C++
class Solution {
public:
    int lengthOfLIS(vector<int>& nums) {
        int n = nums.size();
        if(n == 0)
            return 0;
        vector<int> d(n + 1, 0);
        int len = 1;
        d[len] = nums[0];
        for(int i = 1; i < n; i++){
            if(nums[i] > d[len]){
                d[++len] = nums[i];
            }
            else{
                // 通过二分查找 找到第一个大于等于nums[i]的元素
                // 注意这里是二分查找的区间为[d.begin() + 1, d.begin() + len + 1]
                auto it = lower_bound(d.begin() + 1, d.begin() + len + 1, nums[i]);
                // pos为第一个大于等于nums[i]的元素的索引
                int pos = distance(d.begin(),it);
                // 更新d[pos]为nums[i]
                d[pos] = nums[i];
            }
        }
        return len;
    }
};
```



#### 674 最长连续子序列

##### 动态规划

dp[i]表示以第i个元素结尾的最长连续子序列长度

与“300 最长递增子序列”不同在于：本题不需要遍历[0, i -1]找比nums[i]小的元素，只需要与nums[i - 1]比较即可

```C++
class Solution {
public:
    int findLengthOfLCIS(vector<int>& nums) {
        int n = nums.size();
        vector<int> dp(n, 1);
        int res = 1;
        for(int i = 1; i < n; i++){
            if(nums[i] > nums[i - 1])
                dp[i] = dp[i - 1] + 1;
            res = max(res, dp[i]);
        }
        return res;
    }
};
```

- 时间复杂度：O(n)
- 空间复杂度：O(n)



##### 贪心

使用一个计数器，nums[i]比nums[i - 1]大就加一

否则，减一，重新计数

最后统计计数器最大值

```C++
class Solution {
public:
    int findLengthOfLCIS(vector<int>& nums) {
        int n = nums.size();
        int count = 1;
        int res = 1;
        for (int i = 1; i < n; i++) {
            if (nums[i] > nums[i - 1])
                count++;
            else 
                count = 1;
            res = max(res, count);
        }
        return res;
    }
};
```

- 时间复杂度：O(n)
- 空间复杂度：O(1)



#### 718 最长重复子数组
##### 动态规划

###### 二维做法

有两种`dp[i][j]` 的方法



**方法一：**

**`dp[i][j]` 的含义**

`dp[i][j]` 表示数组a第i个元素和数组第j个元素的公共子数组长度

**递推公式：**

如果`A[i] == B[j]`，`dp[i][j] = dp[i - 1][j - 1] + 1`

否则`dp[i][j] = 0`

**遍历顺序：**

从上到下，从左到右

**初始化：**

需要分类讨论

如果`A[0] == B[0]`，`dp[0][0] = 1`

如果`A[0] != B[0]`，`dp[0][0] = 0`

如果`A[i] == B[0]`，`dp[i][0] = 1`

如果`B[j] == A[0]`，`dp[0][j] = 1`

```C++
class Solution {
public:
    int findLength(vector<int>& nums1, vector<int>& nums2) {
        int n = nums1.size();
        int m = nums2.size();
        vector<vector<int>> dp(n, vector<int>(m, 0));
				
      	// 初始化
        for(int i = 0; i < n; i++){
            if(nums1[i] == nums2[0])
                dp[i][0] = 1;
        }
        for(int j = 0; j < m; j++){
            if(nums1[0] == nums2[j])
                dp[0][j] = 1;
        }

      	// 设定res求dp[i][j]的最大值
        int res = 0;
      	// 本质上dp[i][j] = dp[i - 1][j - 1] + 1适用于i >= 1 && j >= 1
      	// 因为dp[i][0]和dp[0][j]已经被更新
      	// 但是res需要求dp[i][j]的最大值，包括dp[i][0]和dp[0][j]的最大值
      	// 所以这里从i == 0 和j == 0开始
        for(int i = 0; i < n; i++){
            for(int j = 0; j < m; j++){
              	// 这里需要i > 0 && j > 0 
                if(i > 0 && j > 0 && nums1[i] == nums2[j])
                    dp[i][j] = dp[i - 1][j - 1] + 1;
                res = max(res, dp[i][j]);
            }          
        }

        return res;
    }
};
```

**方法二：**

**`dp[i][j]` 的含义**

`dp[i][j]` 表示数组a第i - 1个元素和数组第j - 1个元素的公共子数组长度

**递推公式：**

如果`A[i] == B[j]`，`dp[i][j] = dp[i - 1][j - 1] + 1`

否则`dp[i][j] = 0`

**遍历顺序：**

从上到下，从左到右

**初始化：**

`dp[i][j]` 表示数组a第i - 1个元素和数组第j - 1个元素的公共子数组长度

所以i和j从1开始

所以`i == 0|| j ==0`没有含义，`dp[i][0]和dp[0][j]`都为0



```C++
class Solution {
public:
    int findLength(vector<int>& nums1, vector<int>& nums2) {
        int n = nums1.size();
        int m = nums2.size();
        // 因为dp[i][j]表示数组a第i - 1个元素和数组第j - 1个元素的公共子数组长度
      	// 数组a有n个元素，数组b有m个元素
      	// 所以i最大值为n而不是n - 1，j最大值为m而不是m - 1
      	// 这里初始化要注意dp(n + 1, vector<int>(m + 1, 0))
      	// 而不是dp(n, vector<int>(m, 0));
        vector<vector<int>> dp(n + 1, vector<int>(m + 1, 0));

        int res = 0;
      	// 从i == 1和j == 1开始遍历, i <= n, j <= m
        for(int i = 1; i <= n; i++){
            for(int j = 1; j <= m; j++){
                if(nums1[i - 1] == nums2[j - 1])
                    dp[i][j] = dp[i - 1][j - 1] + 1;
                res = max(res, dp[i][j]);
            }          
        }

        return res;
    }
};
```


**总结**

可以发现，方法二初始化比方法一要简单很多

- 时间复杂度：O(n × m)，n 为A长度，m为B长度
- 空间复杂度：O(n × m)



###### 一维优化

```C++
class Solution {
public:
    int findLength(vector<int>& nums1, vector<int>& nums2) {
        int n = nums1.size();
        int m = nums2.size();
        vector<int> dp(m + 1, 0);

        int res = 0;
        for(int i = 1; i <= n; i++){
            // 因为dp[i][j] = dp[i - 1][j - 1] + 1
            // 如果直接变成dp[j] = dp[j - 1] + 1，这里的dp[j - 1]是dp[i][j]
            // 因此需要改变j的遍历顺序
            for(int j = m; j >= 1; j--){
                if(nums1[i - 1] == nums2[j - 1])
                    dp[j] = dp[j - 1] + 1;
              	// 不相等的时候需要将dp[j]置为0，表示公共长度为0
              	// 二维做法中其实也需要置为0，但是初始化的时候已经置为了0
              	// 在一维做法中，由于滚动数组每个位置都会在每个i循环中使用，因此需要更新dp[j] = 0
                else
                    dp[j] = 0;
                res = max(res, dp[j]);
            }          
        }

        return res;
    }
};
```

- 时间复杂度：$O(n × m)$，n 为A长度，m为B长度
- 空间复杂度：$O(m)$



#### 1143 最长公共子序列

##### 动态规划

**与上一题一样：**

`text1[i - 1] == text2[j - 1]`仍然是`dp[i][j] = dp[i - 1][j - 1] + 1;`

**和上一题不同之处在于：**

由于上一题是公共子数组，子数组特性在于连续，因此`text1[i - 1] != text2[j - 1]`说明`dp[i][j] == 0`

而本题是公共子序列，可以不连续，`text1[i - 1] != text2[j - 1]`时`dp[i][j] != 0`，需要我们额外计算

`dp[i][j] `的长度是`dp[i - 1][j]`和`dp[i][j - 1]`中的最大值

###### 二维做法

```C++
class Solution {
public:
    int longestCommonSubsequence(string text1, string text2) {
        int n = text1.size();
        int m = text2.size();
        vector<vector<int>> dp(n + 1, vector<int>(m + 1, 0))
;       for(int i = 1; i <= n; i++){
            for(int j = 1; j <= m; j++){
                if(text1[i - 1] == text2[j - 1])
                    dp[i][j] = dp[i - 1][j - 1] + 1;
                else
                    dp[i][j] = max(dp[i - 1][j], dp[i][j - 1]);
            }
        }
        return dp[n][m];
    }
};
```



###### 一维优化

```C++
class Solution {
public:
    int longestCommonSubsequence(string text1, string text2) {
        int n = text1.size();
        int m = text2.size();
        vector<int> dp(m + 1, 0)
;       for(int i = 1; i <= n; i++){
            int pre = dp[0];
            for(int j = 1; j <= m; j++){
                // 这里的dp[j]为dp[i - 1][j]
                int cur = dp[j];
                if(text1[i - 1] == text2[j - 1])
                    dp[j] = pre + 1;
                else
                    // dp[j]为dp[i - 1][j]
                    // dp[j - 1]为dp[i][j - 1]
                    dp[j] = max(dp[j], dp[j - 1]);
                // 这里的pre为dp[i - 1][j]
                // j++后，pre为dp[i - 1][j - 1]
                pre = cur;
            }
        }
        return dp[m];
    }
};
```

- 时间复杂度：$O(n × m)$，n 为A长度，m为B长度
- 空间复杂度：$O(m)$



## 哈希表

### 1 两数之和

#### 暴力版

遍历每个元素，枚举数组该元素后的每个元素，判断`nums[i]` + `nums[j]` 是否等于`target`

- 如果是，返回`{i, j}`
- 如果遍历整个数组都没有找到`{i,j}`，返回空数组

```C++
class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int target) {
        int n = nums.size();
        for (int i = 0; i < n; ++i) {
            for (int j = i + 1; j < n; ++j) {
                if (nums[i] + nums[j] == target) {
                    return {i, j};
                }
            }
        }
        return {};
    }
};
```

时间复杂度：$O(n^2)$

空间复杂度：$O(1)$



#### 优化版

在暴力版中，我们发现：定位元素`nums[i]`后，寻找元素`nums[j]`花费了$O(n)$的时间复杂度

因此可以使用哈希表进行优化，哈希表查找元素效率为$O(1)$

使用哈希表优化思路：

- 我们判断某个元素的值是否存在，因此该元素的值作为哈希表的key值
- 题目要求返回元素的下标，因此该元素的下标作为哈希表的value值

**最简单的想法**

遍历一遍数组，将每个元素加入到哈希表中

然后再遍历一遍数组，定位元素`nums[i]`时，通过哈希表查询是否存在`target - nums[i]`，如果存在返回下标

需要注意的是，题目要求不能使用同一元素多次，也就是说`nums[i] != hashMap[target - nums[i]]`

```C++
class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int target) {
        unordered_map<int,int> hashMap;
        int n = nums.size();
        for(int i = 0; i < n; i++){
            hashMap.insert({nums[i],i});
        }
        for(int i = 0; i < n; i++){
            int num = target - nums[i];
            if(hashMap.count(num) && hashMap[num] != i){
                int j = hashMap[num];
                return {i, j};
            }
        }
        return {};
    }
};
```

以上做法使用了两次`for(int i = 0; i < n; i++)`，我们能够在一次循环中完成整个算法

```C++
class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int target) {
        unordered_map<int,int> hashMap;
        int n = nums.size();
        for(int i = 0; i < n; i++){           
            int num = target - nums[i];
            if(hashMap.count(num)){
                int j = hashMap[num];
                return {i, j};
            }
            // 为了不使用当前元素，判断完之后再插入
            hashMap.insert({nums[i],i});
        }
        return {};
    }
};
```

**注意：不需要初始化往hashMap添0，因为题目限定了两个整数的和**

### 49 字母异位词分组

本题本质上是对哈希函数的考察

如何设计哈希函数，让字母异位词指向同一个key值，通过value值将这些字母异位词收集起来

由以上分析，我们判断使用`unordered_map`

#### 做法一

第一种做法：对字符串进行排序，同一组异位词排序后的结果一定相同

```C++
class Solution {
public:
    vector<vector<string>> groupAnagrams(vector<string>& strs) {
        // 每个排序后的key对应的乱序的str
        unordered_map<string, vector<string>> hashMap;
        for (string& str : strs) {
            string key = str;
            sort(key.begin(), key.end());
            hashMap[key].push_back(str);
        }
        vector<vector<string>> ans;
        for (auto it = hashMap.begin(); it != hashMap.end(); it++) {
            ans.push_back(it->second);
        }
        return ans;
    }
};
```

#### 做法二

第二种做法：同一组异位词每个字符出现的次数一定相同

例如"abca"

key的设置为a2b1c1

```C++
class Solution {
public:
    vector<vector<string>> groupAnagrams(vector<string>& strs) {
        unordered_map<string, vector<string>> map;
        for (string str : strs) {
          	// 如果写成int counts[26];过不了
          	// 可能是因为编译优化
            int counts[26] = {0};
            for (char c : str) {
                counts[c - 'a']++;
            }
            string key = "";
            for (int i = 0; i < 26; ++i) {
                if (counts[i]) {
                    key.push_back(i + 'a');
                  	// 这一步不能漏
                    key.push_back(counts[i]);
                }
            }
            map[key].push_back(str);
        }
        vector<vector<string>> res;
        for (auto it = map.begin(); it != map.end(); it++) {
            res.push_back(it->second);
        }
        return res;
    }
};
```

## 





## 双指针

### 283 移动零

#### 暴力解法

题目要求：

1. 将所有的零移动到数组的末尾，且不改变非零元素的顺序
2. 在原地对数组进行操作

思路：

- 题目要求在原地对数组进行操作，那我们就假设[0, k - 1]都是非零元素，[k, n - 1]都是零
- 遍历数组，通过`nums[i] == 0`找到第一个零元素
- 移动到数组的末尾：`for (int j = i + 1; j < n; j++)`我们可以往后找到非零元素，将其与零元素交换，那么就可以保证数组前面都是零元素

```C++
class Solution {
public:
    void moveZeroes(vector<int>& nums) {
        int n = nums.size();
        for (int i = 0; i < n; i++) {
            if (nums[i] == 0) {
                for (int j = i + 1; j < n; j++) {
                    if (nums[j] != 0) {
                        swap(nums[i], nums[j]);
                      	// 保证非零元素的顺序，需要break
                        break;
                    }
                }
            }
        }
    }
};
```

#### 双指针优化

我们发现暴力解法中，i指向第一个零元素的位置，j指向第一个非零元素的位置

j的遍历重复经过了[i, j]之间的多个零元素

因此可以使用双指针优化

```C++
class Solution {
public:
    void moveZeroes(vector<int>& nums) {
        int n = nums.size();
        // l 指向第一个零元素
        int l = 0;
        // r指向第一个非零元素
        for(int r = 0; r < n; r++){
            if(nums[r] != 0){
                swap(nums[l],nums[r]);
                l++;
            }
        }
    }
};
```



### 128 最长连续序列

#### 暴力做法

根据题意首先要对数组进行去重，去重可采用set/unordered_set/map/unordered_map等容器

最简单的思路：

- 遍历每个元素x，不断在数组中找出值为x, x + 1, x +2, ... , x + y的元素，计算长度 y + 1
- 既能满足去重又能快速找出值的数据结构且不要求值有序，使用unordered_set即可

```C++
class Solution {
public:
    int longestConsecutive(vector<int>& nums) {
        // 去重
        unordered_set<int> nums_set;
        for(auto num : nums){
            nums_set.insert(num);
        }
        int n = nums_set.size();
        int maxLen = 0;
        for (auto num : nums_set) {
            int curNum = num;
            int curLen = 0;
            while(nums_set.count(curNum)){
                curNum++;
                curLen++;
            }
            maxLen = max(maxLen,curLen);
        }
        return maxLen;
    }
};
```

时间复杂度：$O(n^2)$

- 对于每个元素都遍历了curLen次

空间复杂度:$O(n)$



#### 优化版

暴力解法的缺点在于会重复寻找数字连续的最长序列：

比如说

- 当前元素是x，按暴力解法的做法，我们会遍历x, x + 1, x +2, ... , x + y的元素，计算长度 y + 1
- 如果当前元素是x + 1，按暴力解法的做法，我们会遍历x + 1, x +2, ... , x + y的元素，计算长度 y
- ...
- 如果当前元素是x + y - 1，按暴力解法的做法，我们会遍历x + y - 1, x + y的元素，计算长度 2
- 如果当前元素是x + y，按暴力解法的做法，我们会遍历x + y的元素，计算长度 1

如何避免这种情况呢

我们发现：如果当前元素是x + 1，那么x + 1遍历的元素, x已经遍历过了；推广到x + k, x + k遍历的元素, x + k - 1也遍历过了

那么我们只需要寻找当前元素的前置元素是否存在，就可以判断该序列是否已经遍历过了

```C++
class Solution {
public:
    int longestConsecutive(vector<int>& nums) {
        // 去重
        unordered_set<int> nums_set;
        for(auto num : nums){
            nums_set.insert(num);
        }
        int n = nums_set.size();
        int maxLen = 0;
        for (auto num : nums_set) {
            int curNum = num;
            int curLen = 0;
            // 与暴力解法相比，加了这一行代码，其他都不变
            if(nums_set.count(num - 1))
                continue;
            while(nums_set.count(curNum)){
                curNum++;
                curLen++;
            }
            maxLen = max(maxLen,curLen);
        }
        return maxLen;
    }
};
```

时间复杂度：$O(n)$

- 看起来是时间复杂度是$O(n^2)$，实际上，假设数字连续的最长序列的长度为maxLen，数组去重后长度为n，我们遍历n - maxLen个不在数字连续的最长序列的元素，由于我们的优化操作，我们只从最终数字连续的最长序列的第一个元素开始遍历，并且只遍历这个序列一次，因此再遍历maxLen个元素，最终遍历了n个元素，即$O(n)$

空间复杂度:$O(n)$



### 11盛最多水的容器

容器容纳水的计算方法：

- 假设i和j是容器的两侧
- $容器容纳水量 = (j - i) * min(height[i], height[j])$

那么我们只需要从两侧往中间遍历，依次比较两侧height大小，取容器水量

因为目标是最小的高度，因此更新指针时，更新的是小的那一个

> 思路与977类似，都属于数组异侧双指针
>
> 这种题的特点是：需要从两侧开始比较大小

```C++
class Solution {
public:
    int maxArea(vector<int>& height) {
        int l = 0, r = height.size() - 1;
        int res = 0;
        while (l < r) {
            res = max(res, (r - l) * min(height[l],height[r]));
            height[l] < height[r] ? l++ : r--;          
        }
        return res;
    }
};
```



### 15 三数之和

#### 暴力解法（超时）

判断是否存在三元组 `[nums[i], nums[j], nums[k]]` 满足 `i != j`、`i != k` 且 `j != k` ，同时还满足 `nums[i] + nums[j] + nums[k] == 0`

- 最简单的做法，三层循环就能找出三元组 `[nums[i], nums[j], nums[k]]`

```C++
class Solution {
public:
    vector<vector<int>> threeSum(vector<int>& nums) {
        int n = nums.size();
        vector<vector<int>> ans;
        for(int i = 0; i < n; i++){
            for(int j = i + 1; j < n; j++){
                for(int k = j + 1; k < n; k++){
                    if((nums[i] + nums[j] + nums[k]) == 0)
                        ans.push_back(vector<int> {nums[i],nums[j],nums[k]});
                }
            }
        }
        return ans;
    }
};
```

但题目还要求：答案中不可以包含重复的三元组，因此我们需要去重

- 最直接的想法就是使用set/unordered_set，但是该类容器key值和value值相同，而key值通常不支持vector做元素
- 我们还可以从遍历上去重，可以想到，对数组进行排序，排序后，下一次遍历的元素与上一次相同时则跳过（因为上一个元素遍历过的元素，下一个元素还会重复一次）

```C++
class Solution {
public:
    vector<vector<int>> threeSum(vector<int>& nums) {
        int n = nums.size();
        vector<vector<int>> ans;
        sort(nums.begin(), nums.end());
        for(int i = 0; i < n; i++){
            if(i > 0 && nums[i] == nums[i - 1])
                continue;
            for(int j = i + 1; j < n; j++){
                if(j > i + 1 && nums[j] == nums[j - 1])
                    continue;
                for(int k = j + 1; k < n; k++){
                    if(k > j + 1 && nums[k] == nums[k - 1])
                        continue;
                    if((nums[i] + nums[j] + nums[k]) == 0)
                        ans.push_back(vector<int> {nums[i],nums[j],nums[k]});
                }
            }
        }
        return ans;
    }
};
```

时间复杂度：$O(n^3)$

空间复杂度：$O(n^2)$



#### 优化版

三重循环还是时间花销太大了，我们想办法如何进一步优化

我们发现：假设`nums[i] + nums[j] + nums[k] == 0` 和`nums[i] + nums[j] + nums[k + 1] == 0`并且`k > j + 1`

那么第三层循环，k会重复遍历区间[j, k - 1]

为了避免这种情况，我们可以使用双指针



```C++
class Solution {
public:
    vector<vector<int>> threeSum(vector<int>& nums) {
        int n = nums.size();
        sort(nums.begin(), nums.end());
        vector<vector<int>> ans;
        for (int first = 0; first < n; first++) {
            if (first > 0 && nums[first] == nums[first - 1])
                continue;
            int target = -nums[first];
            int third = n - 1;
            for (int second = first + 1; second < n; second++) {
                if (second > first + 1 && nums[second] == nums[second - 1])
                    continue;
                // 双指针需要保证左指针second < 右指针third
                while (second < third && nums[second] + nums[third] > target){
                    third--;
                }
                // 如果两者相同，则说明不再存在b<c，与我们的前提假设b>c矛盾，因此结束
                if(second == third)
                    break;
                if(nums[second] + nums[third] == target)
                    ans.push_back({nums[first],nums[second],nums[third]});
            }
        }
        return ans;
    }
};
```



### 42 接雨水

**接雨水的本质：**对于下标 i，下雨后水能到达的最大高度等于下标 i 两边的最大高度的最小值，下标 i 处能接的雨水量等于下标 i 处的水能到达的最大高度减去 height[i]

#### 暴力解法

通过循环找出下标 i 两边的最大高度leftMax和rightMax，再求最小值，这个最小值就是下标 i 处的水能到达的最大高度

> leftMax和rightMax计算过程包含height[i]

下标 i 处能接的雨水量等于下标 i 处的水能到达的最大高度减去 height[i]

```C++
class Solution {
public:
    int trap(vector<int>& height) {
        int n = height.size();
        int res = 0;
        for(int i = 0; i < n; i++){
            int leftMax = 0, rightMax = 0;
          	// 记得leftMax包含height[i]
            for(int j = 0; j <= i; j++){
                leftMax = max(leftMax, height[j]);
            }
          	// 记得rightMax包含height[i]
            for(int j = i; j < n; j++){
                rightMax = max(rightMax,height[j]);
            }
            if(leftMax < rightMax){
                res += leftMax - height[i];
            }
            else
                res += rightMax - height[i];
        }
        return res;
    }
};
```

时间复杂度：$O(2n^2)$

空间复杂度：$O(n)$



#### 动态规划

在暴力解法的基础上分析，我们发现，每次从i左右两侧遍历寻找最高度需要$O(n)$，这里面重复了很多次

我们干脆一次遍历使用数组记录`leftMax[i]`和`rightMax[i]`

- leftMax[i]表示i左侧高度最大值
- rightMax[i]表示i右侧高度最大值

观察代码你会发现，其实也就是将第二层for循环提到外面

```C++
class Solution {
public:
    int trap(vector<int>& height) {
        int n = height.size();
        int res = 0;
        // leftMax[i]表示i左侧高度最大值
        // rightMax[i]表示i右侧高度最大值
        int leftMax[n], rightMax[n];
        // 初始化
        leftMax[0] = height[0];
        rightMax[n - 1] = height[n - 1];
        // 更新leftMax和rightMax
        for (int i = 1; i < n; i++) {
          	// 记得leftMax包含height[i]
            leftMax[i] = max(leftMax[i - 1],height[i]);
        }
        for (int i = n - 2; i >= 0; i--) {
          	// 记得rightMax包含height[i]
            rightMax[i] = max(rightMax[i + 1],height[i]);
        }
        for (int i = 0; i < n; i++) {
            if (leftMax[i] < rightMax[i]) {
                res += leftMax[i] - height[i];
            } else
                res += rightMax[i] - height[i];
        }
        return res;
    }
};
```

时间复杂度：$O(n)$

空间复杂度：$O(n)$



#### 单调栈法

> 单调栈特点：
>
> - 栈内记录下标
> - 单调递减栈
>   - 栈底到栈顶，元素单调递减
>   - 当遇到height[i] > height[stk.top()]，需要弹出栈顶元素，此时大小关系有：
>     1. height[i] > height[stk.top()]
>     2. 弹出栈顶元素`int idx = stk.top();`
>     3. height[stk.top()] >= height[idx]，这里的stk.top()与第一步的stk.top()不同

从左到右遍历数组，遍历到下标 i 时，如果栈内至少有两个元素，记栈顶元素为 top，top 的下面一个元素是 left，则一定有 height[left]≥height[top]。如果 height[i]>height[top]，则得到一个可以接雨水的区域

- 该区域的宽度是 i−left−1
  - 当height[i]>height[top]，我们找到了两侧最大值，分别为rightMax(height[i])和leftMax(height[left])，两侧之间的区域就是接雨水的区域
  - 由于接雨水区域不包括两侧最大值，因此width = i - left - 1
- 高度是 min(height[left],height[i])−height[top]

根据宽度和高度即可计算得到该区域能接的雨水量。

```C++
class Solution {
public:
    int trap(vector<int>& height) {
        int n = height.size();
        stack<int> stk;
        int ans = 0;
        for(int i = 0; i < n; i++){
            // 这里注意用的是while 不是 if
            while(!stk.empty() && height[i] > height[stk.top()]){
                int idx = stk.top();
                stk.pop();
                // 记得判断边界条件
                if(stk.empty())
                    break;
                int left = stk.top();
                int minHeight = min(height[left], height[i]);
                ans += (minHeight - height[idx]) * (i - left - 1);
            }
            stk.push(i);
        }
        return ans;
    }
};
```



#### 双指针法

暴力解法本质上就是比较两侧元素大小，因此可以采用同侧双指针法优化

本题中，我们比较的是两侧高度最大值的最小值，因此分为两步

1. 记录两侧高度的最大值 -> 在指针移动过程中进行
2. 对两侧高度最大值进行取最小值 -> min(leftMax, rightMax)

问题在于如何求解下标 i 处能接的雨水量，即使用双指针后，下标i如何表示

- 双指针问题特性：left和right交替移动，最终遍历完整个数组，因此下标i实际上是移动的left和right
- 我们得到最小值后，立即计算这一侧的雨水量
  - 如果leftMax < rightMax，那么计算res += leftMax - height[left];
  - 如果leftMax > rightMax，那么计算res += rightMax - height[right];
  - 这是因为，得到最小值后，我们会移动相应的指针。以leftMax < rightMax为例，假设当前left == 2，我们会更新left，之后我们不会再计算这个指针指向的height[2]，因此计算雨水量使用leftMax - height[left]
- 为什么leftMax < rightMax，移动left
  - 这是因为雨水量由最小值决定，如果移动rightMax，除非新的rightMax小于leftMax，否则对结果没有任何影响
  - 而rightMax是递增的，每次都只会取更大值，即rightMax = max(rightMax, height[right])，因此rightMax不可能小于leftMax
  - 因此我们移动最小值那一侧的指针

```C++
class Solution {
public:
    int trap(vector<int>& height) {
        int n = height.size();
        int left = 0, right = n - 1;
        int leftMax = height[left], rightMax = height[right];
        int res = 0;
        while(left < right){
            leftMax = max(leftMax, height[left]);
            rightMax = max(rightMax, height[right]);
            if(leftMax < rightMax){
                res += leftMax - height[left];
                left++;
            }
            else{
                res += rightMax - height[right];
                right--;
            }
        }
        return res;
    }
};
```

时间复杂度：$O(n)$

空间复杂度：$O(1)$



## 滑动窗口

滑动窗口算法可以用于解决一些字符串和数组问题，**滑动窗口记录最大值、最小值、子串长度**

例如：

- 字符串匹配问题，例如 Leetcode 第 28 题和第 76 题；
- 最长子串或子数组问题，例如 Leetcode 第 3 题、第 209 题和第 424 题；
- 最小覆盖子串问题，例如 Leetcode 第 76 题；
- 字符串排列问题，例如 Leetcode 第 567 题；
- 求解字符串或数组中的一些性质，例如 Leetcode 第 438 题、第 567 题和第 1004 题等。

### 3 无重复字符的最长子串

为什么使用滑动窗口 -> 因为题目问的是子串，即连续字符序列

判断字符是否重复 -> 用哈希表维护滑动窗口的字符

```C++
class Solution {
public:
    int lengthOfLongestSubstring(string s) {
        int n = s.size();
        int start = 0;
        unordered_set<char> hashMap;
        int ans = 0;
        for(int end = 0; end < n; end++){
            while(hashMap.count(s[end])){
                // 这里注意是把s[start]移除
                hashMap.erase(s[start]);
                start++;
            }
            hashMap.insert(s[end]);
            ans = max(ans,end - start + 1);
        }
        return ans;
    }
};
```

时间复杂度：$O(n)$

空间复杂度：$O(n)$



### 438 找到字符串中的所有字母异位词

**写法一**

for循环里面，i指向窗口前一个位置，这样就能保证i + pLen一定有效，不需要额外判断

```C++
class Solution {
public:
    vector<int> findAnagrams(string s, string p) {
        vector<int> ans;
        int sLen = s.size(), pLen = p.size();
        if(sLen < pLen)
            return vector<int>{};
        vector<int> sHashMap(26);
        vector<int> pHashMap(26);       
        for(int i = 0; i < pLen; i++){
            sHashMap[s[i] - 'a']++;
            pHashMap[p[i] - 'a']++;
        }
        if(sHashMap == pHashMap)
            ans.push_back(0);
        // i为滑动窗口的入口前一个位置，i + pLen 为滑动窗口的出口的下一个位置
        // 滑动窗口的出口需要有意义，因此需要满足i + pLen < sLen -> i < sLen - pLen
        idx - i + 1 = pLen -> idx = pLen + i - 1
        for(int i = 0; i < sLen - pLen; i++){
            // 调整左边界
            --sHashMap[s[i] - 'a'];
            // 调整右边界
            ++sHashMap[s[i + pLen] - 'a'];
            // 调整之后，获得新的滑动窗口
            // 对滑动窗口进行判断
            if(sHashMap == pHashMap)
                ans.push_back(i + 1);
        }
        return ans;
    }
};
```

时间复杂度：`O(m+(n−m)×Σ)`，其中 n 为字符串 s 的长度，m 为字符串 p 的长度，Σ 为所有可能的字符数。我们需要 O(m) 来统计字符串 p 中每种字母的数量；需要 O(m) 来初始化滑动窗口；需要判断 n−m+1 个滑动窗口中每种字母的数量是否与字符串 p 中每种字母的数量相同，每次判断需要 O(Σ) 。因为 s 和 p 仅包含小写字母，所以 Σ=26。

空间复杂度：O(Σ)。用于存储字符串 p 和滑动窗口中每种字母的数量



**另一种写法**

for循环里面，i指向窗口的入口，i + pLen指向窗口的下一个位置， i + pLen 不一定有效，需要额外判断

```C++
class Solution {
public:
    vector<int> findAnagrams(string s, string p) {
        vector<int> ans;
        int sLen = s.size(), pLen = p.size();
        if (sLen < pLen)
            return vector<int>{};
        vector<int> sHashMap(26);
        vector<int> pHashMap(26);
        for (int i = 0; i < pLen; i++) {
            sHashMap[s[i] - 'a']++;
            pHashMap[p[i] - 'a']++;
        }
        // i为滑动窗口的入口，i + pLen 为滑动窗口的出口
        // 如果从入口开始遍历, i最大值计算：sLen - 1 - i + 1 == pLen -> i <= sLen - pLen
        for (int i = 0; i <= sLen - pLen; i++) {
            if (sHashMap == pHashMap)
                ans.push_back(i);
            // 这里需要判断 i + pLen 是否超出数组索引大小，才能取s[i + pLen]
            if (i + pLen < sLen) {
                // 调整左边界
                --sHashMap[s[i] - 'a'];
                // 调整右边界
                ++sHashMap[s[i + pLen] - 'a'];
            }
        }
        return ans;
    }
};
```



### 239 滑动窗口的最大值

#### 单调队列

> 有时间的话阅读一下这篇文章
>
> [https://labuladong.online/algo/data-structure/monotonic-queue/#%E4%B8%80%E3%80%81%E6%90%AD%E5%BB%BA%E8%A7%A3%E9%A2%98%E6%A1%86%E6%9E%B6](https://labuladong.online/algo/data-structure/monotonic-queue/#%E4%B8%80%E3%80%81%E6%90%AD%E5%BB%BA%E8%A7%A3%E9%A2%98%E6%A1%86%E6%9E%B6)
>
> 
>
> 以下文字来源于以上文章，这解释了为什么使用单调队列：
>
> **给你一个数组 `window`，已知其最值为 `A`，如果给 `window` 中添加一个数 `B`，那么比较一下 `A` 和 `B` 就可以立即算出新的最值；但如果要从 `window` 数组中减少一个数，就不能直接得到最值了，因为如果减少的这个数恰好是 `A`，就需要遍历 `window` 中的所有元素重新寻找新的最值**。
>
> 这个场景很常见，但不用单调队列似乎也可以，比如优先级队列也是一种特殊的队列，专门用来动态寻找最值的，我创建一个大（小）顶堆，不就可以很快拿到最大（小）值了吗？
>
> 如果单纯地维护最值的话，优先级队列很专业，队头元素就是最值。但优先级队列无法满足标准队列结构「先进先出」的**时间顺序**，因为优先级队列底层利用二叉堆对元素进行动态排序，元素的出队顺序是元素的大小顺序，和入队的先后顺序完全没有关系。
>
> 所以，现在需要一种新的队列结构，既能够维护队列元素「先进先出」的时间顺序，又能够正确维护队列中所有元素的最值，这就是「单调队列」结构。
>
> 「单调队列」这个数据结构主要用来辅助解决滑动窗口相关的问题，前文 [滑动窗口核心框架](https://labuladong.online/algo/essential-technique/sliding-window-framework/) 把滑动窗口算法作为双指针技巧的一部分进行了讲解，但有些稍微复杂的滑动窗口问题不能只靠两个指针来解决，需要上更先进的数据结构。
>
> 比方说，你注意看前文 [滑动窗口核心框架](https://labuladong.online/algo/essential-technique/sliding-window-framework/) 讲的几道题目，每当窗口扩大（`right++`）和窗口缩小（`left++`）时，你单凭移出和移入窗口的元素即可决定是否更新答案。
>
> 但本文开头说的那个判断一个窗口中最值的例子，你无法单凭移出窗口的那个元素更新窗口的最值，除非重新遍历所有元素，但这样的话时间复杂度就上来了，这是我们不希望看到的。



```C++
class Solution {
public:
    vector<int> maxSlidingWindow(vector<int>& nums, int k) {
        deque<int> window;
        int n = nums.size();
        vector<int> res;
        for(int i = 0; i < n; i++){
            // 移动滑动窗口头部 
            // 当前滑动窗口头部idx 如果比理想的头部i - k + 1要小，则调整滑动窗口头部
            while(!window.empty() && window.front() < i - k + 1){
                window.pop_front();
            }
            // 移动滑动窗口尾部
            while(!window.empty() && nums[i] > nums[window.back()]){
                window.pop_back();
            }
            window.push_back(i);
            // 更新滑动窗口最大值
            // 当i >= k -1 说明滑动窗口已填满，可以开始移动和获取最大值
            if(i >= k - 1)
                res.push_back(nums[window.front()]);
        }
        return res;
    }
};
```

时间复杂度：O(n)，其中 n 是数组 nums 的长度。每一个下标恰好被放入队列一次，并且最多被弹出队列一次，因此时间复杂度为 O(n)。

空间复杂度：O(k)。与方法一不同的是，在方法二中我们使用的数据结构是双向的，因此「不断从队首弹出元素」保证了队列中最多不会有超过 k+1 个元素，因此队列使用的空间为 O(k)



### 76 最小覆盖子串

又是子串，我们立即想到使用滑动窗口

**思路**

1. 首先想到的肯定是暴力解法：暴力枚举 + 哈希表
2. 然后在分析的过程中，发现双指针同向不回退，就可以利用这个单调性，联想到滑动窗口解法：滑动窗口 + 哈希表

**解题方法**

1. 先创建两个哈希表，用来统计两个字符串中字符出现的次数
2. 再将要覆盖的字符串t，存入哈希表baseHash
3. 设置pos和minLen，用来记录子串的初始位置和最小长度（这步很关键，我们可以等循环结束再拷贝子串，而不是循环中，减少了很多时间开销）
4. **其次设置count，用来记录curHash中的有效字符个数（这步优化，可以让我们不用每次都一一比较两个哈希表，而是比较count是否达到t的有效字符个数）**

接下来，是正常的滑动窗口四步走（详见代码）：

- 进窗口
- 判断
- 出窗口
- 处理结果（这步的位置根据题目要求而变化）

**复杂度**

- 时间复杂度:O(m+n)

- 空间复杂度:O(1)


```C++
class Solution {
public:
    string minWindow(string s, string t) {
        // hs记录s的字符和个数
        // ht记录t的字符和个数
        unordered_map<char,int> hs,ht;
        int sLen = s.size();
        int tLen = t.size();
        string res;
        if(sLen < tLen)
            return res;
        for(auto c: t){
            ht[c]++;
        }
        // cnt用于记录需要的字符数
        int cnt = 0;
        // 遍历s
        for(int right = 0, left = 0; right < sLen; right++){
            hs[s[right]]++;
            // 如果当前窗口内hs含有字符s[i]个数比ht少
            // 说明当前字符s[i]是必须的
            // 说明窗口需要继续扩展
            if(hs[s[right]] <= ht[s[right]])
                cnt++;
            // s[j]是多余的
            // 收缩窗口
            while(hs[s[left]] > ht[s[left]]){
                hs[s[left]]--;
                left++;
            }
            if(cnt == t.size()){
                if(res.empty() || right - left + 1 < res.size())
                    res = s.substr(left, right - left + 1);
            }
        }
        return res;
    }
};
```

## 

## 子串

### 560 和为k的子数组

#### 暴力解法

```C++
class Solution {
public:
    int subarraySum(vector<int>& nums, int k) {
        int n = nums.size();
        int res = 0;
        for(int i = 0; i < n; i++){
            int sum = 0;
            for(int j = i; j < n; j++){
                sum += nums[j];
                if(sum == k)
                    res++;
            }
        }
        return res;
    }
};
```

时间复杂度：$O(n^2)$

空间复杂度：$O(1)$



#### 优化版

> 题外话：这道题看到连续序列可能会想用滑动窗口
>
> 但是滑动窗口通常用于记录窗口内的最大最小值 或 子串长度
>
> 在本题中，k值可以为正数，也可以为负数，这意味着我们不一定求的是最值，使用滑动窗口无法求解

在暴力解法中，我们发现每次枚举nums[i]后，都会循环遍历nums[j]计算sum，这种计算子数组的和可以用前缀和优化

前缀和：我们想知道[j, i]的和，就可以使用前缀和`pre[i] - pre[j - 1]`计算

在本题中，我们想知道区间和为k数组的个数，我们当然可以遍历每个元素i，获得pre[i]，但问题是我们不知道什么时候区间和等于k，即我们无法知道下标j

我们假设已经找到了j，那么有`pre[i] - pre[j - 1] == k`，我们发现`pre[j - 1]`可以用`pre[i] - k`代替，也就是我们不需要知道j具体是多少，只需要找出前缀和为`pre[i] - k`的数组即可

**前缀和为`pre[i] - k` 与 区间和为k 可是完全不同的概念**

- 或许你会说前缀和为`pre[i] - k` ，需要从0到i依次遍历寻找；区间和为k，也需要从i到0依次遍历寻找，都是$O(n)$时间复杂度
- 但是注意`pre[i]`与`pre[i] - k` 的关系，当我们得到了`pre[i]`，说明我们已经得到了`pre[i] - k`，这两者都是通过前缀和计算得到的，而前缀和计算是遍历过程中得到的，**因此我们可以维护一个哈希表，计算一次前缀和就将结果放入哈希表**，那么当我们得到了`pre[i]`，我们可以通过$O(1)$时间复杂度获得`pre[i] - k`的个数

最后，从左往右边更新边计算的时候已经保证了hashMap[pre[i]−k] 里记录的 pre[j] 的下标范围是 0≤j≤i 。同时，由于pre[i] 的计算只与前一项的答案有关，因此我们可以不用建立 pre 数组，直接用 pre 变量来记录 pre[i−1] 的答案即可。

```C++
class Solution {
public:
    int subarraySum(vector<int>& nums, int k) {
        // key记录值sum[i] - k，value记录个数
        unordered_map<int,int> hashMap;
        int n = nums.size();
        int pre = 0;
        int count = 0;
        // 这一步不能省
        // 因为pre == k的时候一定有解
        // 从前缀和为0的时候开始
        hashMap[0] = 1;
        // sum[i] - sum[j - 1] = k
        // 即sum[j - 1] = sum[i] - k
        // 此处的pre就是sum[i]
        for(int i = 0; i < n; i++){
            pre += nums[i];
            auto it = hashMap.find(pre - k);
            if(it != hashMap.end())
                count += it->second;
            // 记录前缀和为pre的个数
            hashMap[pre]++;
        }
        return count;
    }
};
```

时间复杂度：$O(n)$

空间复杂度：$O(n)$



## 

## 二叉树

理论基础

https://programmercarl.com/%E4%BA%8C%E5%8F%89%E6%A0%91%E7%90%86%E8%AE%BA%E5%9F%BA%E7%A1%80.html#%E7%AE%97%E6%B3%95%E5%85%AC%E5%BC%80%E8%AF%BE

### 二叉树遍历

- 深度优先遍历（前中后的区别：输出元素的顺序，前就是第一个，中就是中间，后就是最后）
  - 前序遍历
  - 中序遍历
  - 后序遍历
- 广度优先遍历
  - 层序遍历

#### 144 二叉树的前序遍历

##### 递归版

```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
private:
    vector<int> ans;
    void preOrder(TreeNode* root){
        if(!root)
            return;
        ans.push_back(root->val);
        preOrder(root->left);
        preOrder(root->right);
    }
public:
    vector<int> preorderTraversal(TreeNode* root) {
        preOrder(root);
        return ans;
    }
};
```



##### 迭代版

```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
public:
    vector<int> preorderTraversal(TreeNode* root) {
        if(!root)
            return {};
        // 模拟递归函数调用顺序
        stack<TreeNode*> stk;
        // 存放结果
        vector<int> ans;
        stk.push(root);
        while(!stk.empty()){
            TreeNode* cur = stk.top();
            stk.pop();
            ans.push_back(cur->val);
          	// 注意放入栈的顺序与实际调用顺序相反
            if(cur->right)
                stk.push(cur->right);
            if(cur->left)
                stk.push(cur->left);
        }
        return ans;
    }
};
```



#### 94 二叉树的中序遍历

##### 递归版

```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
private:
    vector<int> ans;
    void inOrder(TreeNode* root){
        if(!root)
            return;
        inOrder(root->left);
        ans.push_back(root->val);
        inOrder(root->right);
    }
public:
    vector<int> inorderTraversal(TreeNode* root) {
        inOrder(root);
        return ans;
    }
};
```



##### 迭代版

中序遍历迭代写法与前序遍历不同之处在于：

- 前序遍历访问节点的顺序与处理节点的顺序相同：第一个访问的就是根节点，第一个处理的也是根节点
- 中序遍历访问节点的顺序与处理节点的顺序不同：第一个访问的是根节点，第一个处理的是左节点（遇见左节点会直接触发递归，直到没有左节点为止）

因此中序遍历迭代写法使用栈存储左节点，根节点和右节点在函数体内处理，不存入栈，否则会破坏函数调用顺序

```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left),
 * right(right) {}
 * };
 */
class Solution {
public:
    vector<int> inorderTraversal(TreeNode* root) {
        if (!root)
            return {};
        stack<TreeNode*> stk;
        vector<int> ans;
        TreeNode* cur = root;
        while (cur || !stk.empty()) {
            if (cur) {
                stk.push(cur);
                cur = cur->left;
            }
            else{
                cur = stk.top();
                stk.pop();
                ans.push_back(cur->val);
                cur = cur->right;
            }
        }
        return ans;
    }
};
```



#### 145 二叉树的后序遍历

##### 递归版

```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
private:
    vector<int> ans;
    void postOrder(TreeNode* root){
        if(!root)
            return;
        postOrder(root->left);
        postOrder(root->right);
        ans.push_back(root->val);
    }
public:
    vector<int> postorderTraversal(TreeNode* root) {
        postOrder(root);
        return ans;
    }
};
```



##### 迭代版

再来看后序遍历，先序遍历是中左右，后序遍历是左右中，那么我们只需要调整一下先序遍历的代码顺序，就变成中右左的遍历顺序，然后在反转result数组，输出的结果顺序就是左右中了，如下图：

![前序到后序](/Users/t/Desktop/xxxx2077.github.io/docs/algorithm/leetcode.assets/20200808200338924.png)

```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
public:
    vector<int> postorderTraversal(TreeNode* root) {
        if(!root)
            return {};
        vector<int> ans;
        stack<TreeNode*> stk;
        stk.push(root);
        while(!stk.empty()){
            TreeNode* cur = stk.top();
            stk.pop();
            ans.push_back(cur->val);
            if(cur->left)
                stk.push(cur->left);
            if(cur->right)
                stk.push(cur->right);
        }
        reverse(ans.begin(), ans.end());
        return ans;
    }
};
```



#### 102 二叉树的层序遍历

以下做法告诉我们，二叉树层序遍历中，队列存储的是每一层的节点

```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left),
 * right(right) {}
 * };
 */
class Solution {
public:
    vector<vector<int>> levelOrder(TreeNode* root) {
        if (!root)
            return {};
        queue<TreeNode*> q;
        q.push(root);
        vector<vector<int>> ans;
        while (!q.empty()) {
            // 记录这一层有多少个节点
            int size = q.size();
            vector<int> res;
            // 输出这一层的所有节点，并更新queue
            for (int i = 0; i < size; i++) {
                TreeNode* cur = q.front();
                q.pop();
                res.push_back(cur->val);
                if (cur->left)
                    q.push(cur->left);
                if (cur->right)
                    q.push(cur->right);
            }
            ans.push_back(res);
        }
        return ans;
    }
};
```

#### 104 二叉树的最大深度

##### 深度优先遍历

```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
public:
    int maxDepth(TreeNode* root) {
        if(!root)
            return 0;
        return max(maxDepth(root->left), maxDepth(root->right)) + 1;
    }
};
```



##### 层序遍历

```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
public:
    int maxDepth(TreeNode* root) {
        if(!root)
            return 0;
        queue<TreeNode*> q;
        q.push(root);
        int ans = 0;
        while(!q.empty()){
            int size = q.size();
            for(int i = 0; i < size; i++){
                TreeNode* cur = q.front();
                q.pop();
                if(cur->left)
                    q.push(cur->left);
                if(cur->right)
                    q.push(cur->right);
            }
            ans++;
        }
        return ans;
    }
};
```



#### 199 二叉树的右视图

右侧所能看到的节点 其实就是每层节点的最后一个节点 -> 需要我们按层遍历，而且找到每层的最后一个节点

因此本题使用层序遍历，最后一个节点通过索引size - 1得到

```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
public:
    vector<int> rightSideView(TreeNode* root) {
        if(!root)
            return {};
        vector<int> ans;
        queue<TreeNode*> q;
        q.push(root);
        while(!q.empty()){
            int size = q.size();
            for(int i = 0; i < size; i++){
                TreeNode* cur = q.front();
                q.pop();
                if(i == size - 1)
                    ans.push_back(cur->val);
                if(cur->left)
                    q.push(cur->left);
                if(cur->right)
                    q.push(cur->right);
            }
        }
        return ans;
    }
};
```



### 226 翻转二叉树

#### 递归

```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
public:
    TreeNode* invertTree(TreeNode* root) {
        if(!root)
            return nullptr;
        TreeNode* left = invertTree(root->left);
        TreeNode* right = invertTree(root->right);
        root->left = right;
        root->right = left;
        return root;
    }
};
```

时间复杂度 O(N) ： 其中 N 为二叉树的节点数量，建立二叉树镜像需要遍历树的所有节点，占用 O(N) 时间。
空间复杂度 O(N) ： 最差情况下（当二叉树退化为链表），递归时系统需使用 O(N) 大小的栈空间。

#### 迭代

算法流程：

1. 特例处理： 当 root 为空时，直接返回 null 。
2. 初始化： 栈（或队列），本文用栈，并加入根节点 root 。
3. 循环交换： 当栈 stack 为空时跳出。
   1. 出栈： 记为 node 。
   2. 添加子节点： 将 node 左和右子节点入栈。
   3. 交换： 交换 node 的左 / 右子节点。
4. 返回值： 返回根节点 root 。

```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
public:
    TreeNode* invertTree(TreeNode* root) {
        if(!root)
            return nullptr;
        stack<TreeNode*> stk;
        stk.push(root);
        while(!stk.empty()){
            TreeNode* cur = stk.top();
            stk.pop();
            if(cur->left)
                stk.push(cur->left);
            if(cur->right)
                stk.push(cur->right);
            // 交换两个节点
            TreeNode* temp = cur->right;
            cur->right = cur->left;
            cur->left = temp;
        }
        return root;
    }
};
```



### 101 对称二叉树

判断对称二叉树的逻辑：

1. 找到两个子树
2. 判断两个子树的根节点u和v的值是否相同
3. 如果相同，接着判断u->left和v->right的值是否相同 以及 u->right和v->left的值是否相同
4. 直到遍历完整个二叉树为止

#### 递归

```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
public:
    bool check(TreeNode* u, TreeNode* v){
        if(!u && !v)
            return true;
        if(!u || !v)
            return false;
        return u->val == v->val && check(u->left, v->right) && check(u->right, v->left);
    }
    bool isSymmetric(TreeNode* root) {
        if(!root)
            return true;
        return check(root->left, root->right);
    }
};
```

假设树上一共 n 个节点。

时间复杂度：这里遍历了这棵树，渐进时间复杂度为 O(n)。
空间复杂度：这里的空间复杂度和递归使用的栈空间有关，这里递归层数不超过 n，故渐进空间复杂度为 O(n)。



#### 迭代

每一层比较是否对称，比较方法：

- 在队列中加入两个根节点
- 每次取出两个根节点，进行比较
  - 如果都为空，对称
  - 如果有一个不为空，一个为空，不对称
  - 如果值相同，对称
- 把这两个根节点的左节点和右节点对称放入队列

```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left),
 * right(right) {}
 * };
 */
class Solution {
public:
    bool isSymmetric(TreeNode* root) {
        if (!root)
            return true;
        queue<TreeNode*> q;
        q.push(root);
        q.push(root);
        while (!q.empty()) {
            TreeNode* node1 = q.front();
            q.pop();
            TreeNode* node2 = q.front();
            q.pop();
            if(!node1 && !node2)
                continue;
            if (!node1 || !node2 || node1->val != node2->val)
                return false;
            q.push(node1->left);
            q.push(node2->right);

            q.push(node1->right);
            q.push(node2->left);
        }
        return true;
    }
};
```

时间复杂度：O(n)，同「方法一」。
空间复杂度：这里需要用一个队列来维护节点，每个节点最多进队一次，出队一次，队列中最多不会超过 n 个点，故渐进空间复杂度为 O(n)



### 543 二叉树的直径

```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
private:
    // ans记录经过的节点数
    // 两节点之间路径的长度由节点之间的边数表示
    // 也就是说直径为ans - 1（节点数 - 1 = 边数）
    int ans;
    int depth(TreeNode* root){
        // 注意边界条件
        if(!root)
            return 0;
        // 计算根节点左右子树的最大深度（最大节点数）
        int leftDepth = depth(root->left);
        int rightDepth = depth(root->right);
        // 更新本子树的最大节点数leftDepth + rightDepth + 1（1是根节点）
        ans = max(ans, leftDepth + rightDepth + 1);
        // 返回本子树的深度max(leftDepth, rightDepth) + 1（1是根节点）
        return max(leftDepth, rightDepth) + 1;
    }
public:
    int diameterOfBinaryTree(TreeNode* root) {
        if(!root)
            return 0;
        // 这个d其实并不重要，因为不一定经过root
        int d = depth(root);
        // 直径为最大节点数 - 1
        return ans - 1;
    }
};
```

**复杂度分析**

时间复杂度：O(N)，其中 N 为二叉树的节点数，即遍历一棵二叉树的时间复杂度，每个结点只被访问一次。

空间复杂度：O(Height)，其中 Height 为二叉树的高度。由于递归函数在递归过程中需要为每一层递归函数分配栈空间，所以这里需要额外的空间且该空间取决于递归的深度，而递归的深度显然为二叉树的高度，并且每次递归调用的函数里又只用了常数个变量，所以所需空间复杂度为 O(Height) 。



### 108 将有序数组转换为二叉搜索树

> 给定中序遍历结果求二叉搜索树，结果不一定唯一
>
> 给定中序遍历结果求**平衡的**二叉搜索树，结果不一定唯一
>
> 因此，题目给出了多种可能的答案，表示都可以

思路：

1. 二叉搜索树的中序遍历是递增数组
2. 我们每次取二叉搜索树的中间值，这个值就是根节点
3. 根节点左边是它的左子树，右边是它的右子树
4. 接着重复步骤2和步骤3，即可获得二叉搜索树

**有个小坑：**

如何证明以上做法能够保证二叉搜索树是平衡的

证明见以下链接

https://leetcode.cn/problems/balance-a-binary-search-tree/solutions/241897/jiang-er-cha-sou-suo-shu-bian-ping-heng-by-leetcod/

```c++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
private:
    TreeNode* dfs(vector<int>& nums, int start, int end){
        if(start > end)
            return nullptr;
        int mid = (start + end) / 2;
        TreeNode* root = new TreeNode(nums[mid]);
        root->left = dfs(nums, start, mid - 1);
        root->right = dfs(nums, mid + 1, end);
        return root;
    }
public:
    TreeNode* sortedArrayToBST(vector<int>& nums) {
        return dfs(nums, 0 ,nums.size() - 1);
    }
};
```

**复杂度分析**

时间复杂度：O(n)，其中 n 是数组的长度。每个数字只访问一次。

空间复杂度：O(logn)，其中 n 是数组的长度。空间复杂度不考虑返回值，因此空间复杂度主要取决于递归栈的深度，递归栈的深度是 O(logn)。



### 98 验证二叉搜索树

#### 中序遍历（递归直接版）

通过中序遍历得到最后的有序序列，遍历一遍有序序列看看是否递增

```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
private:
    vector<long long> ans;
    void inOrder(TreeNode* root){
        if(!root)
            return;
        inOrder(root->left);
        ans.push_back(root->val);
        inOrder(root->right);
    }
public:
    bool isValidBST(TreeNode* root) {
        inOrder(root);
        long long pre = (long long)INT_MIN - 1;
        for(long long num : ans){
            if(num <= pre)
                return false;
            pre = num;
        }     
        return true;
    }
};
```

但这种方法时间复杂度和空间复杂度有点高



#### 中序遍历（递归优化版）

我们可以在中序遍历过程中判断是否符合有序序列，即只需要判断中序遍历访问的当前节点与访问的上一个节点是否满足有序

```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
private:
    vector<long long> ans;
    long long pre = (long long)INT_MIN - 1;
    bool inOrder(TreeNode* root){
        if(!root)
            return true;
        bool leftRes = inOrder(root->left);
        if(root->val <= pre)
            return false;
        pre = root->val;
        bool rightRes = inOrder(root->right);
        return leftRes && rightRes;        
    }
public:
    bool isValidBST(TreeNode* root) {
        return inOrder(root);
    }
};
```



### 230 二叉搜索树第k小的元素

#### 中序遍历（直接版）

```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
private:
    vector<int> ans;
    void inOrder(TreeNode* root){
        if(!root)
            return;
        inOrder(root->left);
        ans.push_back(root->val);
        inOrder(root->right);
    }
public:
    int kthSmallest(TreeNode* root, int k) {
        inOrder(root); 
        return ans[k - 1];
    }
};
```



#### 中序遍历（优化版）

所谓优化就是不需要遍历整棵树，遍历过程中找到对应的节点就可以返回

##### 递归

感觉用递归不太适合，这里就不贴出来了



##### 迭代

```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
public:
    int kthSmallest(TreeNode* root, int k) {
        stack<TreeNode*> stk;
        TreeNode* cur = root;
        while(cur || !stk.empty()){
            if(cur){
                stk.push(cur);
                cur = cur->left;
            }else{
                cur = stk.top();
                stk.pop();
                // 从k - 1开始计数
                k--;
                // 因此k == 0时对应第k个小的值
                if(k == 0)
                    return cur->val;
                cur = cur->right;
            }
        }
        return 0;
    }
};
```

复杂度分析

时间复杂度：O(H+k)，其中 H 是树的高度。在开始遍历之前，我们需要 O(H) 到达叶结点。当树是平衡树时，时间复杂度取得最小值 O(logN+k)；当树是线性树（树中每个结点都只有一个子结点或没有子结点）时，时间复杂度取得最大值 O(N+k)。

空间复杂度：O(H)，栈中最多需要存储 H 个元素。当树是平衡树时，空间复杂度取得最小值 O(logN)；当树是线性树时，空间复杂度取得最大值 O(N)



#### 方法二：记录子树的结点数

> 如果二叉搜索树经常被修改（插入/删除操作）并且你需要频繁地查找第 `k` 小的值，你将如何优化算法？

详见题解：

https://leetcode.cn/problems/kth-smallest-element-in-a-bst/solutions/1050055/er-cha-sou-suo-shu-zhong-di-kxiao-de-yua-8o07/?envType=study-plan-v2&envId=top-100-liked

```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
private:
    unordered_map<TreeNode*,int> nodeNum;
    int setNodeNum(TreeNode* node){
        if(!node)
            return 0;
        int leftNum = setNodeNum(node->left);
        int rightNum = setNodeNum(node->right);
        nodeNum[node] = leftNum + rightNum + 1;
        return nodeNum[node];
    }
    int getNodeNum(TreeNode* node){
        if(node && nodeNum.count(node))
            return nodeNum[node];
        else
            return 0;
    }
public:
    int kthSmallest(TreeNode* root, int k) {
        if(!root)
            return 0;
        setNodeNum(root);
        TreeNode* node = root;
        while(node){
            int leftNum = getNodeNum(node->left);
            // 如果左子树节点树比 k - 1小，说明第k个数在右子树
            // 此时左子树有 leftNum 个节点
            // 也就是说此时我们已经找到了第k个节点左边的leftNum个节点
            // 我们还需要填充k - 1 - leftNum个节点，就可以找到第k个节点
            // 因此k = k - 1 - leftNum
            if(leftNum < k - 1){
                node = node->right;
                k -= leftNum + 1;
            }else if (leftNum == k - 1){
                return node->val;
            }else{
                node = node->left;
            }
        }
        return 0;
    }
};
```

下一次寻找第k小的节点，只需要查找哈希表即可，为$O(1)$时间复杂度



### 114 二叉树展开为链表

#### 迭代

思路：

- 将左子树插入到右子树的地方
- 将原来的右子树接到左子树的最右边节点
- 考虑新的右子树的根节点，一直重复上边的过程，直到新的右子树为 null

```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left),
 * right(right) {}
 * };
 */
class Solution {
public:
    void flatten(TreeNode* root) {
        TreeNode* cur = root;
        while (cur) {
          	// move表示左子树的最右边节点
          	// move是右子树需要接上的位置
            TreeNode* move = cur->left;
            while (move && move->right) {
                move = move->right;
            }
          	// 这里需要判断move是否为空
          	// 如果一开始cur->left不为空（左子树不为空），那么move不为空
          	// 如果一开始cur->left为空（左子树为空），那么move为空
          	// 如果左子树不为空所以要进行操作
            if (move) {
                move->right = cur->right;
                cur->right = cur->left;
                cur->left = nullptr;
            }
          	// 移动到右子树和左子树是否为空没关系
            cur = cur->right;
        }
    }
};
```

时间复杂度：$O(n)$

空间复杂度：$O(1)$



#### 反前序遍历

递归+回溯的思路：

将前序遍历反过来遍历，那么第一次访问的就是前序遍历中最后一个节点。

那么可以调整最后一个节点，再将最后一个节点保存到pre里，再调整倒数第二个节点，将它的右子树设置为pre，再调整倒数第三个节点，依次类推直到调整完毕。和反转链表的递归思路是一样的。

```C++
class Solution {
public:
    TreeNode* preNode;
    void flatten(TreeNode* root) {
        if (root == NULL) return;
        flatten(root->right);
        flatten(root->left);
        root->left = NULL;
        root->right = preNode;
        preNode = root;
    }
};
```

时间复杂度：$O(n)$

空间复杂度：$O(n)$



### 105 从前序与中序遍历构造二叉树

#### 直接做法

```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
private:
    TreeNode* myBuildTree(vector<int>& preorder, vector<int>& inorder, int preorderStart, int preorderEnd, int inorderStart, int inorderEnd){
        if(preorderStart > preorderEnd || inorderStart > inorderEnd)
            return nullptr;
        auto it = find(inorder.begin()+inorderStart, inorder.begin()+inorderEnd + 1, preorder[preorderStart]);
        int pos = distance(inorder.begin(), it);
        int leftSubTreeNum = pos - inorderStart;
        TreeNode* root = new TreeNode(inorder[pos]);
        root->left = myBuildTree(preorder,inorder,preorderStart + 1, preorderStart + leftSubTreeNum, inorderStart, pos - 1);
        root->right = myBuildTree(preorder,inorder, preorderStart + leftSubTreeNum + 1, preorderEnd, pos + 1, inorderEnd);
        return root;
    }
public:
    TreeNode* buildTree(vector<int>& preorder, vector<int>& inorder) {
        return myBuildTree(preorder, inorder,0,preorder.size() - 1, 0, inorder.size() - 1);
    }
};
```



#### 直接做法的优化

find的时间复杂度为$O(n)$，可以进一步优化为哈希表查询，时间复杂度改为$O(1)$

```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
private:
    TreeNode* myBuildTree(vector<int>& preorder, vector<int>& inorder, int preorderStart, int preorderEnd, int inorderStart, int inorderEnd){
        if(preorderStart > preorderEnd || inorderStart > inorderEnd)
            return nullptr;
        int pos = hashMap[preorder[preorderStart]];
        int leftSubTreeNum = pos - inorderStart;
        TreeNode* root = new TreeNode(inorder[pos]);
        root->left = myBuildTree(preorder,inorder,preorderStart + 1, preorderStart + leftSubTreeNum, inorderStart, pos - 1);
        root->right = myBuildTree(preorder,inorder, preorderStart + leftSubTreeNum + 1, preorderEnd, pos + 1, inorderEnd);
        return root;
    }
public:
    unordered_map<int, int> hashMap;
    TreeNode* buildTree(vector<int>& preorder, vector<int>& inorder) {
        for(int i = 0; i < inorder.size(); i++){
            hashMap[inorder[i]] = i;
        }
        return myBuildTree(preorder, inorder,0,preorder.size() - 1, 0, inorder.size() - 1);
    }
};
```

时间复杂度：O(n)，其中 n 是树中的节点个数。

空间复杂度：O(n)，除去返回的答案需要的 O(n) 空间之外，我们还需要使用 O(n) 的空间存储哈希映射，以及 O(h)（其中 h 是树的高度）的空间表示递归时栈空间。这里 h<n，所以总空间复杂度为 O(n)。



#### 迭代

待补充



### 437 路径之和III

#### 直接做法

pathSum表示返回二叉树中任意节点为起点和为targetSum的路径数，注意：这里的任意节点包括：

- 根节点
- 根节点的直接子节点
- **间接子节点**

因此我们想到，遍历二叉树的每个节点，以这个节点为起点，计算和为targetSum的路径数，最后累加起来，就是结果

遍历的方式有很多，以最简单的前序遍历为例

那么我们的问题就变成了求解一个函数，这个函数负责计算以某个节点为起点，和为targetSum的路径数

为此我们定义了一个函数rootSum

- 该函数就是计算特定节点为起点的和为targetSum的路径数

- 计算方法：

  1. 如果当前节点root值为targetSum，表示我们找到了目标节点，路径数加一
  2. 如果当前节点root值不为targetSum，那么我们需要继续遍历当前节点的左子树和右子树，直到找到满足题意的路径
     - 如果左/右子树存在节点node，使得root->n1->n2->...->node的和为targetSum，那么路径数加一

  由于节点的值可以为负数，因此情况1和情况2可以同时成立，因此结果应该是两种情况的和

现在我们已经定义了函数rootSum，那么pathSum也就可以实现了：

- 本质是遍历二叉树，这里我们采用了前序遍历
  - 处理每个节点后，遍历它的左子树和右子树
- 处理每个节点的方式：以每个节点作为起点，计算每个节点为起点的和为targetSum的路径数，即计算rootSum



```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
private:
    // 计算以某个节点为起点的路径数
    // root->n1->n2->...->node
    int rootSum(TreeNode* root, long targetSum){
        if(!root)
            return 0;
        int res = 0;
        // 如果当前节点值为targetSum
        if(root->val == targetSum)
            res++;
        // 如果当前节点值不为targetSum
        // 由于我们已经假设root一定包含在路径中
        // 因此之后寻找路径需要更新targetSum
        res += rootSum(root->left, targetSum - root->val);
        res += rootSum(root->right, targetSum - root->val);
        return res;
    }
public:
    // 注意数据范围，使用long
    int pathSum(TreeNode* root, long targetSum) {
        if(!root)
            return 0;
        int res = 0;
        // 前序遍历框架
        res += rootSum(root, targetSum);
        // 路径不需要从根节点开始
        // 每个节点都可以是路径的起点
        // 因此每次调用pathSum都是同样的targetSum
        res += pathSum(root->left, targetSum);
        res += pathSum(root->right, targetSum);
        return res;
    }
};
```

时间复杂度：$O(N^2)$，其中 N 为该二叉树节点的个数。对于每一个节点，求以该节点为起点的路径数目时，则需要遍历以该节点为根节点的子树的所有节点，因此求该路径所花费的最大时间为 O(N)，我们会对每个节点都求一次以该节点为起点的路径数目，因此时间复杂度为 $O(N^2)$

空间复杂度：O(N)，考虑到递归需要在栈上开辟空间。



#### 优化做法

以每个节点为起点计算路径数，会包含很多重复的路径，例如：

1. n1->n2->...->n7->n8
2. n2->...->n7

假设这两条路径都符合和为targetSum，那么计算路径1会包含路径2的步骤，重复了路径2的计算

针对这种情况，我们可以联想到数组中的前缀和，问题在于二叉树如何实现前缀和。我们发现**从根节点到叶子节点这条路径其实就对应一个数组**，那么我们只需要将问题分解为每条根节点到叶子结点这条路径如何求解即可，再将最后结果累加

- 在深度优先遍历中，我们知道，遍历到叶子节点时会回溯，那么从根节点到叶子节点这条路径中，有多少条以某个节点为起点和为targetSum的路径数。在直接做法中，通过对每个节点求一次rootSum。在优化做法中，维护前缀和+哈希表避免重复计算
- 当节点回溯时，路径更新，因此哈希表也需要更新（哈希表去掉回溯节点对应前缀和的标记）

```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
private:
    unordered_map<long,int> hashMap;
    int dfs(TreeNode* root, long pre, long targetSum){
        if(!root)
            return 0;
        // 前序遍历
        pre += root->val;
        int res = 0;
        // sum[i] - sum[j - 1] == targetSum
        // -> sum[j - 1] == sum[i] - targetSum 
        if(hashMap.count(pre - targetSum))
            res += hashMap[pre - targetSum];

        // 为什么要恢复现场
        // 因为遍历完当前节点会回溯，回溯意味着这条路径的和pre不存在
        hashMap[pre]++;
        res += dfs(root->left, pre, targetSum);
        res += dfs(root->right, pre, targetSum);
        hashMap[pre]--;
        return res;
    }
public:
    int pathSum(TreeNode* root, long targetSum) {
        if(!root)
            return 0;
        hashMap[0] = 1;
        // 只需要遍历一次二叉树
        return dfs(root, 0,targetSum);
    }
};
```

**复杂度分析**

- 时间复杂度：*O*(*N*)，其中 *N* 为二叉树中节点的个数。利用前缀和只需遍历一次二叉树即可。
- 空间复杂度：*O*(*N*)

#### 总结

直接做法和优化做法本质上都是遍历一遍二叉树，遍历方式采用了前序遍历，区别在于如何处理根节点

- 处理根节点：计算根节点到叶子节点和为targetSum的路径数

  - 直接做法：以根节点到叶子节点这条路径中的每个节点作为起点，计算该起点和为targetSum的路径数

    - 类比于数组中

      ```C++
      for(int i = 0; i < n; i++){
      		int sum = 0;
      		for(int j = i; j < n; j++){
            	sum += nums[j];
      				if(sum == targetSum)
      						cnt++;
      		}
      }
      ```

      因此直接做法还需要再遍历一次子树的所有节点，即再采用一次前序遍历

      

  - 优化做法：以根节点到叶子节点这条路径，使用前缀和 + 哈希表，只需遍历一次路径即可得到和为targetSum的路径数

    - 类比于数组中

      ```C++
      for(int i = 0; i < n; i++){
      		pre += nums[i];
      		if(hashMap.count(pre - targetSum)){
      				cnt += hashMap[pre - targetSum];
      		}
      		hashMap[pre - targetSum]++;
      }
      ```

- 遍历左子树 + 遍历右子树

  - 唯一需要注意的是，优化做法中，由于回溯，哈希表需要删除回溯元素



### 236 二叉树的最近公共祖先

分类讨论，给定两个节点p和q，有两种情况：

- p和q没有直接或间接父子节点关系，那么p和q一定分别在某个节点的左子树和右子树，这个节点就是最近公共祖先
- p和q有直接或间接的父子节点关系，假设p为q的直接或间接父节点，那么q一定在p的左子树或右子树

#### 前序遍历

前序遍历访问顺序：中左右，这意味着我们需要先判断当前节点，才能访问左右子树

最近公共祖先的唯二情况：

- 左子树含有p，当前节点为q / 右子树含有p，当前节点为q
  - 在前序遍历中，由于前序遍历会先访问到q，再访问到p（也就是先访问到最近公共祖先），因此只需要：一旦访问到值为p或q的节点，立马返回当前节点，该节点就是最近公共祖先
- 左右子树分别含有p或q，表明当前节点就是最近公共祖先
  - 因为是前序遍历，因此从这次判断之后，不会再出现左右子树分别含有p或q的情况，只会出现左子树有p 或右子树有q
  - 因此只要触发这个条件，我们就能判断当前节点就是最近公共祖先

具体算法如下图：

![236.png](/Users/t/Desktop/xxxx2077.github.io/docs/algorithm/leetcode.assets/1681546069-BZfraI-236.png)

解释一下边界条件：

- 当前节点是空节点 -> 返回当前节点 （这个应该不用解释）
- 前序遍历的性质保证了函数返回的结果就是第一个满足最近公共祖先的结果
  - 只有左子树找到 -> 说明p或q就在左子树中，返回递归左子树的结果
  - 只有右子树找到 -> 说明p或q就在右子树中，返回递归右子树的结果
  - 左右子树都没有找到 -> 返回空节点（表示当前子树不含有p 或 q）

```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode(int x) : val(x), left(NULL), right(NULL) {}
 * };
 */
class Solution {
public:
    TreeNode* lowestCommonAncestor(TreeNode* root, TreeNode* p, TreeNode* q) {
        if(!root || root == p || root == q)
            return root;
        TreeNode* left = lowestCommonAncestor(root->left, p, q);
        TreeNode* right = lowestCommonAncestor(root->right, p, q);
        if(left && right)
            return root;
        if(!left && right)
            return right;
        if(!right && left)
            return left;
        return nullptr;
    }
};
```

时间复杂度：O(N)，其中 N 是二叉树的节点数。二叉树的所有节点有且只会被访问一次，因此时间复杂度为 O(N)。

空间复杂度：O(N) ，其中 N 是二叉树的节点数。递归调用的栈深度取决于二叉树的高度，二叉树最坏情况下为一条链，此时高度为 N，因此空间复杂度为 O(N)。



#### 后序遍历

后序遍历访问顺序：左右中，这意味着后序遍历能够先获取左右子树是否含有p或q的信息，再处理根节点

最近公共祖先的唯二情况：

- 左右子树分别含有p或q，表明当前节点就是最近公共祖先
  - 从这次判断之后，进行回溯，p和q会在同一个子树中，而不是不同子树
  - 因此只要触发这个条件，我们就能判断当前节点就是最近公共祖先
- 左子树含有p，当前节点为q / 右子树含有p，当前节点为q
  - 只要触发这个条件，我们就能判断当前节点就是最近公共祖先

由于后序遍历的性质，函数返回的结果并不是最近公共祖先，而是最近公共祖先的父节点

因此我们没有必要让函数返回节点，只需要返回bool值表示是否存在p或q即可

因此我们需要使用ans变量额外存储这个变量

```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode(int x) : val(x), left(NULL), right(NULL) {}
 * };
 */
class Solution {
public:
    TreeNode* ans;
    bool dfs(TreeNode* root, TreeNode* p, TreeNode* q){
        if(!root)
            return false;
        bool leftStat = dfs(root->left, p ,q);
        bool rightStat = dfs(root->right, p ,q);
        if((leftStat && rightStat) || ((root == p || root == q) && (leftStat || rightStat)))
            ans = root;
     		// 最后返回值，我们不关心最近公共祖先是哪个，我们只关心当前子树是否含有p或q
      	// 因此只要左子树出现了p或q / 左子树出现了p或q / 当前节点为p或q 就能表示当前子树含有p或q
        return leftStat || rightStat || root == p || root == q;
    }
    TreeNode* lowestCommonAncestor(TreeNode* root, TreeNode* p, TreeNode* q) {
        if(!root)
            return nullptr;
        dfs(root,p,q);
        return ans;
    }
};
```

复杂度分析

时间复杂度：O(N)，其中 N 是二叉树的节点数。二叉树的所有节点有且只会被访问一次，因此时间复杂度为 O(N)。

空间复杂度：O(N) ，其中 N 是二叉树的节点数。递归调用的栈深度取决于二叉树的高度，二叉树最坏情况下为一条链，此时高度为 N，因此空间复杂度为 O(N)。



### 124 二叉树中的最大路径和

```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
public:
    int ans = INT_MIN;
    int maxSum(TreeNode* root){
        if(!root)
            return 0;
        // 分别计算两个子树的最大贡献
        // 如果两个子树的最大贡献为负数，那么当前子树加上这个负数只会更小
        // 因此需要将两个子树的最大贡献与0比较
        int leftMaxSum = max(0,maxSum(root->left));
        int rightMaxSum = max(0,maxSum(root->right));
        // 更新本子树的最大路径和
        ans = max(ans, root->val + leftMaxSum + rightMaxSum);
        // 返回的是最大贡献，而不是最大路径和
        // 区分：当本子树贡献给别的路径时，贡献的是本子树的左边或者右边
        return root->val + max(leftMaxSum, rightMaxSum);
    }
    int maxPathSum(TreeNode* root) {
        if(!root)
            return 0;
        // 不关心根节点的最大贡献，不需要处理返回值
        maxSum(root);
        // 只关注最大路径和
        return ans;
    }
};
```

### 总结

124 二叉树中的最大路径和  和 543 二叉树的直径 比较像，都是使用到了二叉树的直径这一概念

> 二叉树的 **直径** 是指树中任意两个节点之间最长路径的 **长度** 。这条路径可能经过也可能不经过根节点 `root`

437 路径之和III 虽然也不要求一定经过根节点，但是要求路径为父节点到子节点，这一点与直径不同



## 贪心

### 121 买卖股票的最佳时机

想要得到最大利润很简单：

只需要使用最高的价钱 - 最小的成本

我们最直接的想法就是：

遍历一遍数组，得到最高价钱和最小成本，两者相减即可

```C++
class Solution {
public:
    int maxProfit(vector<int>& prices) {
        int profit = 0;
        int minCost = INT_MAX, maxCost = 0;
        for(int i = 0; i < prices.size(); i++){
            minCost = min(minCost, prices[i]);
            maxCost = max(maxCost, prices[i]);
        }
        profit = maxCost - minCost;
        return profit <= 0 ? 0 : profit;
    }
};
```

但是本题有个隐藏条件：股票出售需要在买入之后，以上做法没有满足这个条件。

那么我们如何做到呢？其实也不难，我们不更新最高价钱，而是直接更新最大利润

在遍历过程中，最小成本cost取得的索引一定比prices[i]当前的索引小，因此满足题意

```C++
class Solution {
public:
    int maxProfit(vector<int>& prices) {
        int cost = INT_MAX, profit = 0;
        for(int i = 0;i < prices.size(); i++){
            cost = min(cost, prices[i]);
            profit = max(profit, prices[i] - cost);
        }
        return profit;
    }
};
```



### 55 跳跃游戏

维护最大可达位置nextStep

如果当前位置i <= nextStep，说明当前位置i可达，可跳到当前位置i上，更新最大可达位置

如果最大可达位置比n - 1大，说明能够到达n - 1

```C++
class Solution {
public:
    bool canJump(vector<int>& nums) {
        int n = nums.size();
        int nextStep = 0;
        for(int i = 0; i < n; i++){
            if(i <= nextStep){
                nextStep = max(nextStep, i + nums[i]);
                if(nextStep >= n - 1)
                    return true;
            }
        }
        return false;
    }
};
```



### 45 跳跃游戏II

#### 普通版

```C++
class Solution {
public:
    int jump(vector<int>& nums) {
        int n = nums.size();
        int start = 0, end = start + 1;
        int ans = 0;
        while(end < n){
            int nextStep;
            for(int i = start; i < end; i++){
                nextStep = max(nextStep, i + nums[i]);
            }
            ans++;
            start = end;
            end = nextStep + 1;
        }
        return ans;
    }
};
```

#### 优化版

在跳跃游戏中，我们的思路是：

- 我们不确定给定nums[i] 需要走多少步才能到达最后一个元素
- 为此，我们进行了问题转换，我们不需要知道走多少步，只需要更新最大到达范围maxPos，如果maxPos大于等于n - 1，说明能够到达n - 1

在跳跃游戏II中，我们仍然能仿照这个思路：

- 如果当前maxPos没有覆盖n - 1，那我们跳跃一次
- 如果maxPos大于等于n - 1，说明能够到达n - 1，**不需要再跳跃**

**不同之处**在于：跳跃游戏II默认我们能够到达最后一个元素，求跳跃次数

如何能让跳跃次数最大，我们只需要走到maxPos的时候再跳跃即可 -> 我们维护两个maxPos，一个表示当前能够到达的最大位置，另一个表示下一次能够到达的最大位置

**这里需要特别注意的一点：**跳跃游戏II默认我们能够到达最后一个元素，因此我们不需要遍历到 n -1个元素，因为在那之前，我们一定能让maxPos覆盖n - 1

如果包含了n - 1反而有可能让结果多加一次(end 刚好等于n - 1)

```C++
class Solution {
public:
    int jump(vector<int>& nums) {
        int n = nums.size();
        int end = 0;
        int maxNextStep = 0;
        int step = 0;
        // 注意：i < n - 1 而不是i < n
        for (int i = 0; i < n - 1; i++) {
          	// 这里不需要if判断了，因为题目说一定能到达n - 1
            maxNextStep = max(maxNextStep, i + nums[i]);
            if (i == end) {
                ++step;
                end = maxNextStep;
            }
        		// 与跳跃游戏不同，这里不需要maxNextStep >= n - 1判断，因为我们知道一定能到达n - 1
        		// 如果加了这个判断，表明我们已经知道覆盖范围大于n - 1了
        		// 但是这时候i还没走到更新后的end，我们需要让i走到end之后让step加一
        }
        return step;
    }
};
```



### 763 划分字母区间

对于划分区间问题，我们通常会想到贪心

做法通常是比较区间的末端，更新区间



在本题中，分析题目：

- 同一字母最多出现在一个片段中 -> 假设字母出现的最后位置$end_c$为`last[s[i] - 'a']`，区间末端$end$必须要大于等于$end_c$，否则会出现两个字母出现在不同片段
- 把这个字符串划分为尽可能多的片段 -> 只要满足i到达区间末端$end$，说明当前区间[start, end]所有字母出现的最后位置$end_c$为`last[s[i] - 'a']`，都满足$end_c$小于等于区间末端$end$，那么我们就可以立即划分区间，从而得到尽可能多的区间

```C++
class Solution {
public:
    vector<int> partitionLabels(string s) {
        int n = s.size();
        int last[26];
        vector<int> res;
        // 统计每个字符最后出现的下标
        for(int i = 0; i < n; i++){
            last[s[i] - 'a'] = i;
        }
        // start为区间开始点，end为区间结束点
        // end一定为某区间内所有last[j]的最大值
        int start = 0, end = 0;
        for(int i = 0; i < n; i++){
            end = max(end, last[s[i] - 'a']);
            // i == end 说明区间终点end已确定 且已遍历到区间终点end
            if(i == end){
                res.push_back(end - start + 1);
                start = end + 1;
            }
        }
        return res;
    }
};
```

复杂度分析

时间复杂度：O(n)，其中 n 是字符串的长度。需要遍历字符串两次，第一次遍历时记录每个字母最后一次出现的下标位置，第二次遍历时进行字符串的划分。

空间复杂度：O(∣Σ∣)，其中 Σ 是字符串中的字符集。这道题中，字符串只包含小写字母，因此 ∣Σ∣=26。

## 21 合并两个升序链表

### 解法一：递归

```
s1: A->B->C->...
s2: a->b->c->...
```

假设有链表s1和s2，如果A < a，则本次比较得到链表的下一个元素为A，并且下一次B和a比较；否则，本次比较得到链表的下一个元素为a，下一次A和b比较

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
    ListNode* mergeTwoLists(ListNode* list1, ListNode* list2) {
        if(!list1)
            return list2;
        if(!list2)
            return list1;
        if(list1->val < list2->val){
            list1->next = mergeTwoLists(list1->next, list2);
            return list1;
        }
        else{
            list2->next = mergeTwoLists(list1, list2->next);
            return list2;
        }
    }
};
```

**时间复杂度：O(n+m)**，其中 n 和 m 分别为两个链表的长度。因为每次调用递归都会去掉 l1 或者 l2 的头节点（直到至少有一个链表为空），函数 mergeTwoList 至多只会递归调用每个节点一次。因此，时间复杂度取决于合并后的链表长度，即 O(n+m)。

**空间复杂度：O(n+m)**，其中 n 和 m 分别为两个链表的长度。递归调用 mergeTwoLists 函数时需要消耗栈空间，栈空间的大小取决于递归调用的深度。结束递归调用时 mergeTwoLists 函数最多调用 n+m 次，因此空间复杂度为 O(n+m)。

### 解法二：迭代

```c++
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
    ListNode* mergeTwoLists(ListNode* list1, ListNode* list2) {
        ListNode* head = new ListNode();
        ListNode* tail = head;
        while (list1 != nullptr && list2 != nullptr) {
            if (list1->val < list2->val) {
                tail->next = list1;
                list1 = list1->next;
            } else {
                tail->next = list2;
                list2 = list2->next;
            }
            tail = tail->next;
        }
        tail->next = list1 == nullptr ? list2 : list1;
        return head->next;
    }
};
```

**时间复杂度：O(n+m)**，其中 n 和 m 分别为两个链表的长度。因为每次循环迭代中，l1 和 l2 只有一个元素会被放进合并链表中， 因此 while 循环的次数不会超过两个链表的长度之和。所有其他操作的时间复杂度都是常数级别的，因此总的时间复杂度为 O(n+m)。

**空间复杂度：O(1)**。我们只需要常数的空间存放若干变量。

## 22 括号生成

### 递归版

如果左括号数小于对数，选择左括号

如果右括号个数小于左括号，选择右括号

```C++
class Solution {
private:
    void dfs(vector<string>& ans, string& res, int left, int right, int n) {
        if (res.size() == n * 2) {
            ans.push_back(res);
            return;
        }
        if (left < n) {
            res.push_back('(');
            dfs(ans, res, left + 1, right, n);
            res.pop_back();
        }
        if (right < left) {
            res.push_back(')');
            dfs(ans, res, left, right + 1, n);
            res.pop_back();
        }
    }

public:
    vector<string> generateParenthesis(int n) {
        vector<string> ans;
        string res;
        dfs(ans, res, 0, 0, n);
        return ans;
    }
};
```



## 23 合并K个升序链表

https://leetcode.cn/problems/merge-k-sorted-lists/description/

本题在**21 合并两个升序链表**的基础上进行加难

### 解法一：顺序合并

每相邻两个合并升序链表

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
private:
    ListNode* mergeTwoLists(ListNode* list1, ListNode* list2){
        ListNode* head = new ListNode();
        ListNode* tail = head;
        while(list1 != nullptr && list2 != nullptr){
            if(list1->val < list2->val){
                tail->next = list1;
                list1 = list1->next;
            }
            else{
                tail->next = list2;
                list2 = list2->next;
            }
            tail = tail->next;
        }
        tail->next = list1 == nullptr ? list2 : list1;
        return head->next;
    }
public:
    ListNode* mergeKLists(vector<ListNode*>& lists) {
        ListNode* ans = nullptr;
        for(int i = 0; i < lists.size(); i++){
            ans = mergeTwoLists(ans, lists[i]);
        }
        return ans;
    }
};
```



### 解法二： 分治合并

类似于快速排序，分组合并

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
private:
    ListNode* mergeTwoLists(ListNode* list1, ListNode* list2){
        ListNode* head = new ListNode();
        ListNode* tail = head;
        while(list1 != nullptr && list2 != nullptr){
            if(list1->val < list2->val){
                tail->next = list1;
                list1 = list1->next;
            }
            else{
                tail->next = list2;
                list2 = list2->next;
            }
            tail = tail->next;
        }
        tail->next = list1 == nullptr ? list2 : list1;
        return head->next;
    }
    ListNode* merge(vector<ListNode*>& lists,int l, int r){
        if(l == r)
            return lists[l];
        if(l > r)
            return nullptr;
        int mid = (l + r) >> 1;
        return mergeTwoLists(merge(lists, l, mid), merge(lists, mid + 1, r));
    }
public:
    ListNode* mergeKLists(vector<ListNode*>& lists) {
        return merge(lists, 0, lists.size() - 1);
    }
};
```

### 解法三：优先级队列

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
private:
    struct Status{
        int val;
        ListNode* ptr;
        
    };
    struct cmp{
        bool operator () (const Status& s1, Status &s2)  const {
            return s1.val > s2.val;
        }
    };

    priority_queue<Status,vector<Status>,cmp> q;
public:
    ListNode* mergeKLists(vector<ListNode*>& lists) {
        ListNode* head = new ListNode();
        ListNode* tail = head;
        for(auto node : lists){
            if(node)
                q.push({node->val, node});
        }
        while(!q.empty()){
            Status s = q.top();
            q.pop();
            tail->next = s.ptr;
            tail = tail->next;
            if(s.ptr->next)
                q.push({s.ptr->next->val, s.ptr->next});
        }
        return head->next;
    }
};
```

或写成：

区别只是在于优先级队列自定义比较的不同写法

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
#include <queue>
class Solution {
private:
    struct Status{
        int val;
        ListNode* ptr;
        // 一定要原封不动的这样写
        bool operator < (const Status&s) const{
            return val > s.val;
        }
    };
    // 一定要原封不动的这样写
    priority_queue<Status> q;
public:
    ListNode* mergeKLists(vector<ListNode*>& lists) {
        ListNode* head = new ListNode();
        ListNode* tail = head;
        for(auto node : lists){
            if(node)
                q.push({node->val, node});
        }
        while(!q.empty()){
            Status s = q.top();
            q.pop();
            tail->next = s.ptr;
            tail = tail->next;
            if(s.ptr->next)
                q.push({s.ptr->next->val, s.ptr->next});
        }
        return head->next;
    }
};
```



## 25 K个一组翻转链表

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
private:
    ListNode* reverse(ListNode* head){
        ListNode* prev = nullptr;
        ListNode* cur = head;
        while(cur){
            ListNode* nxt = cur->next;
            cur->next = prev;
            prev = cur;
            cur = nxt;
        }
        return prev;
    }
public:
    ListNode* reverseKGroup(ListNode* head, int k) {
        // 增加一个dummyNode
        ListNode* dummyNode = new ListNode();
        dummyNode->next = head;
        // prev指向上一组的第k个节点，即本组第一个节点的前一个节点
        // 起到dummyNode的作用
        ListNode* prev = dummyNode, *end = prev;
        // 当end没有下一个节点，不需要反转，结束循环
        while(end->next){
            // end指向本组的第k个节点
            // 如果还遍历第[1,k]个节点，end为空，不需要反转，结束循环
            for(int i = 0; i < k && end; i++)
                end = end->next;
            // 如果循环因为某节点为空而停止，不需要反转，结束循环
            if(end == nullptr)
                break;
            // start指向本组的第一个节点
            ListNode* start = prev->next;
            // nxt指向下一组的第一个节点
            ListNode* nxt = end->next;
            // 反转链表，结果为新的链表头
            // 反转链表与上一组链表相连
            end->next = nullptr;
            prev->next = reverse(start);
            // 更新指针
            start->next = nxt;
            prev = start;
            end = prev;
        }
        return dummyNode->next;
    }
};
```













## 回溯问题

### 77 组合

如下图所示，组合问题本质上是一个树形求解问题，有以下性质

1. 取了的数不能再取
2. 获取到指定k个数后，立即返回结果，不再继续遍历

对于性质1，可以通过增加参数startIndex确定每次遍历的起始索引，[1,startIndex)为已经遍历过的，[startIndex,n]为未遍历的

> PS：
>
> 对于自然数组合问题，给定的集合，恰好满足：索引i对应的值i
>
> 对于其他组合，例如给定集合{A,B,C,D}，则不满足该规律，因此是path.push_back(集合的值)

对于性质2，采用回溯的方法

```C++
if(condition)
{
		//procedure
		return;
}
```

![77.组合](/Users/t/Desktop/xxxx2077.github.io/docs/algorithm/leetcode.assets/20201123195223940.png)

```C++
class Solution {
private:
    vector<vector<int>> ans;
    // path数组用于记录满足结果的集合
    vector<int> path;
    // startIndex用于记录下一次开始的元素，避免重复
    void dfs(int n, int k, int startIndex){
        if(path.size() == k){
            ans.push_back(path);
            return;
        }
        for(int i = startIndex; i <= n; i++){
            path.push_back(i);
            dfs(n, k, i + 1);
            path.pop_back();
        }
    }
public:
    vector<vector<int>> combine(int n, int k) {
        dfs(n, k, 1);
        return ans;
    }
};
```

#### 优化版

对于上述问题，我们可以进一步进行剪枝优化

如下图，当n=4, k=4，我们发现第一个数取1，进行到第四层就能遍历所有可能（1,2,3,4），因此第一层循环不需要2及之后的元素，第二层不需要3及之后的元素，其余同理

假设当前取的元素集合为path，个数为`path.size()`，那么我们还需要取的元素个数为`k - path.size()`

总共有n个元素，假设起始索引startIndex取到最大值，使得startIndex之后的元素个数恰好为`k - path.size()`

那么startIndex的值为`n - (k - path.size()) + 1`，可以通过n - startIndex = k - size() + 1计算

```C++
// 剪枝部分
for(int i = startIndex; i <= n - (k - path.size()) + 1; i++){
	path.push_back(i);
	dfs(n, k, i + 1);
	path.pop_back();
}
```

![77.组合4](/Users/t/Desktop/xxxx2077.github.io/docs/algorithm/leetcode.assets/20210130194335207.png)



```C++
class Solution {
private:
    vector<vector<int>> ans;
    // path数组用于记录满足结果的集合
    vector<int> path;
    // startIndex用于记录下一次开始的元素，避免重复
    void dfs(int n, int k, int startIndex){
        if(path.size() == k){
            ans.push_back(path);
            return;
        }
      	// 剪枝部分
        for(int i = startIndex; i <= n - (k - path.size()) + 1; i++){
            path.push_back(i);
            dfs(n, k, i + 1);
            path.pop_back();
        }
    }
public:
    vector<vector<int>> combine(int n, int k) {
        dfs(n, k, 1);
        return ans;
    }
};
```

#### 另一思路

根据二进制由每位进1的思想

我们也可以从最初递增序列1,2,3,4,...,共k个数开始递增，直到到达最大序列

- 该递增为让最高位一次递增，其余位不变
- 但是递增最高位的过程，会导致前面的位发生改变，因此最高两位满足递增关系时，说明已经满足组合关系，将前面的数置为初始序列

方法为：

- 从左往右，找到第一个满足$a_j + 1 \neq a_{j+1}$，说明已经不满足递增了，因此将$a_j + 1$
- 为了使第一个序列能够执行上述算法，引入哨兵节点，在第k位加入n + 1，保证第k - 1位不满足$a_j + 1 \neq a_{j+1}$

> 例如，n = 4，k = 2
>
> 最初序列为1,2[5] （[5]为哨兵节点）
>
> 接着我们需要得到1,3[5] 
>
> - 为了得到1,3[5]，根据算法我们需要先得到2,3[5] ，得到2,3[5] 后，将前面的第j位重新置为$j + 1$
>
> 以此类推
>
> 你会发现这种算法与二进制非常类似，最高位进位后，剩余的位将重新置为0

```C++
class Solution {
public:
    vector<int> temp;
    vector<vector<int>> ans;

    vector<vector<int>> combine(int n, int k) {
        // 初始化
        // 将 temp 中 [0, k - 1] 每个位置 i 设置为 i + 1，即 [0, k - 1] 存 [1, k]
        // 末尾加一位 n + 1 作为哨兵
        for (int i = 1; i <= k; ++i) {
            temp.push_back(i);
        }
        temp.push_back(n + 1);
        
        int j = 0;
        while (j < k) {
            ans.emplace_back(temp.begin(), temp.begin() + k);
            j = 0;
            // 寻找第一个 temp[j] + 1 != temp[j + 1] 的位置 t
            // 我们需要把 [0, t - 1] 区间内的每个位置重置成 [1, t]
            while (j < k && temp[j] + 1 == temp[j + 1]) {
                temp[j] = j + 1;
                ++j;
            }
            // j 是第一个 temp[j] + 1 != temp[j + 1] 的位置
            ++temp[j];
        }
        return ans;
    }
};
```



### 39 组合总和II

```C++
class Solution {
private:
    vector<int> res;
    vector<vector<int>> ans;
    void dfs(const vector<int>& candidates, vector<int>& res, int target,
             int index) {
        if (index == candidates.size()) {
            return;
        }
        if (target == 0) {
            ans.push_back(res);
            return;
        }
        // 不选这个数
        dfs(candidates, res, target, index + 1);
        // 选这个数
        if (candidates[index] <= target) {
            res.push_back(candidates[index]);
            dfs(candidates, res, target - candidates[index], index);
            res.pop_back();
        }
    }

public:
    vector<vector<int>> combinationSum(vector<int>& candidates, int target) {
        dfs(candidates, res, target, 0);
        return ans;
    }
};
```



### 216 组合总和III

在77 组合基础上加了限制条件，不仅需要k个元素的组合，而且该组合之和为n

因此我们只需要加上限制即可，其余与77 组合做法一致

限制条件：

`if(path.size() == k && n == 0)`

```C++
class Solution {
private:
    const int N = 9;
    vector<vector<int>> ans;
    vector<int> path;
    void dfs(int k, int n, int startIndex){
        // 注意这里需要判断n == 0以保证k个元素之和恰好为n
        if(path.size() == k && n == 0){
            ans.push_back(path);
            return ;
        }
        for(int i = startIndex; i <= N - (k - path.size()) + 1; i++){
            if(i <= n){
                path.push_back(i);
              	// 记得这里要n - i，表示选择元素i后，剩余的元素和
                dfs(k, n - i, i + 1);
                path.pop_back();
            }
        }
    }
public:
    vector<vector<int>> combinationSum3(int k, int n) {
        dfs(k, n, 1);
        return ans;
    }
};
```



### 46 全排列

#### 写法一

```C++
class Solution {
private:
    void dfs(vector<int> &nums, int start, vector<int> &path,vector<vector<int>> &ans){
        if(path.size() == nums.size())
            ans.push_back(path);
        for(int i = start; i < nums.size(); i++){
            path.push_back(nums[i]);
            swap(nums[start], nums[i]);
            dfs(nums, start + 1, path, ans);
            swap(nums[start], nums[i]);
            path.pop_back();
        }
    }
public:
    vector<vector<int>> permute(vector<int>& nums) {
        vector<vector<int>> ans;
        vector<int> path;
        dfs(nums,0,path,ans);
        return ans;
    }
};
```

#### 写法二

```C++
class Solution {
private:
    vector<vector<int>> ans;
    void dfs(vector<int>& nums,int idx){
        if(idx == nums.size() - 1){
            ans.push_back(nums);
            return;
        } 
        for(int i = idx; i < nums.size(); i++){
            swap(nums[i], nums[idx]);
            dfs(nums, idx + 1);
            swap(nums[i], nums[idx]);
        }
    }
public:
    vector<vector<int>> permute(vector<int>& nums) {
        dfs(nums, 0);
        return ans;
    }
};
```



### 17 电话号码的字母组合

startIndex记录输入字符串遍历的位置

通过startIndex获取对应电话簿字母串str

遍历字母串str将其加入str



```C++
class Solution {
private:
    unordered_map<int, string> phoneTable = {
        {2, "abc"}, {3, "def"},  {4, "ghi"}, {5, "jkl"},
        {6, "mno"}, {7, "pqrs"}, {8, "tuv"}, {9, "wxyz"},
    };
    vector<string> ans;
    string path;
    int k;
    void dfs(string& digits, string& path, int k, int startIndex) {
        if (k == 0) {
            ans.push_back(path);
            return;
        }
        string str = phoneTable[digits[startIndex] - '0'];
        for (char letter : str) {
            path.push_back(letter);
            dfs(digits, path, k - 1, startIndex + 1);
            path.pop_back();
        }
    }

public:
    vector<string> letterCombinations(string digits) {
        if (!digits.empty()) {
            k = digits.size();
            dfs(digits, path, k, 0);
        }
        return ans;
    }
};
```



### 78 子集

#### 迭代法

用二进制表示每个幂集，第i位为1表示选择第i个元素，那么总共有2^n - 1个状态

```C++
class Solution {
private:
    vector<int> t;
    vector<vector<int>> ans;
public:
    vector<vector<int>> subsets(vector<int>& nums) {
        int n = nums.size();
        // 总共有2^n - 1种状态
        for(int mask = 0; mask < (1 << n); mask++){
            // 每个状态对应的序列不同
            t.clear();
            // 枚举每个元素
            for(int i = 0; i < n; i++){
                // 1 << i表示第i位为1
                // mask & (1 << i)表示mask状态第i位为1
                // 即选择第i个元素
                if(mask & (1 << i)){
                    t.push_back(nums[i]);
                }
            }
            ans.push_back(t);
        }
        return ans;
    }
};
```



#### 递归法

用idx记录当前遍历到第几个元素，分类讨论：

- 选择当前元素，如果选择当前元素，那么dfs之后需要回溯
- 不选择当前元素

```C++
class Solution {
private:
    vector<vector<int>> ans;
    vector<int> res;
    void dfs(vector<int>&nums, int idx){
        if(idx == nums.size()){
            ans.push_back(res);
            return;
        }
        res.push_back(nums[idx]);
        dfs(nums, idx + 1);
        res.pop_back();
        dfs(nums, idx + 1);
    }
public:
    vector<vector<int>> subsets(vector<int>& nums) {
        dfs(nums, 0);
        return ans;
    }
};
```



## 79 单词搜索

```C++
class Solution {
private:
    int rows, cols;
    int dx[4] = {-1, 0, 1, 0};
    int dy[4] = {0, 1, 0, -1};
    bool dfs(vector<vector<char>>& board, const string& word, int x, int y,
             int idx) {
        if (board[x][y] != word[idx])
            return false;
        if (idx == word.size() - 1)
            return true;
        for (int i = 0; i < 4; i++) {
            int a = x + dx[i];
            int b = y + dy[i];
            if (a >= 0 && a < rows && b >= 0 && b < cols) {
                board[x][y] = '\0';
                if (dfs(board, word, a, b, idx + 1))
                    return true;
                board[x][y] = word[idx];
            }
        }
        return false;
    }

public:
    bool exist(vector<vector<char>>& board, string word) {
        rows = board.size();
        cols = board[0].size();
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                if (dfs(board, word, i, j, 0))
                    return true;
            }
        }
        return false;
    }
};
```



## 84 柱状图最大的矩形

https://leetcode.cn/problems/largest-rectangle-in-histogram/description/

### 解法一： 暴力枚举

枚举宽：枚举左边界，再枚举右边界

```c++
class Solution {
public:
    int largestRectangleArea(vector<int>& heights) {
        int ans = 0;
        int n = heights.size();
        for(int i = 0; i < n; i++){
            int minHeight = heights[i];
            for(int j = i; j < n; j++){
                minHeight = min(minHeight, heights[j]);
                ans = max(ans, (j - i + 1) * minHeight);
            }
        }
        return ans;
    }
};
```

枚举高：

```C++
class Solution {
public:
    int largestRectangleArea(vector<int>& heights) {
        int ans = 0;
        int n = heights.size();
        // 枚举每根柱子的高度
        for(int mid = 0; mid < n; mid++){
            int height = heights[mid];
            int left = mid, right = mid;
            // 如果左右柱子比当前枚举的柱子高，那么矩形的高度仍然为当前枚举柱子的高度heights[mid]
            while(left - 1 >= 0 && heights[left - 1] >= height) --left;
            while(right + 1 < n && heights[right + 1] >= height) ++right;
          	// 注意这里left和right都指向最后一个比枚举柱子高度大的柱子
          	// 与单调栈做法不同，这里为right - left + 1（单调栈是right - left - 1）
            ans = max(ans, (right - left + 1) * height);
        }
        return ans;
    }
};
```

可以发现，这两种暴力方法的时间复杂度均为$ O(N^2)$，会超出时间限制，我们必须要进行优化。考虑到枚举「宽」的方法使用了两重循环，本身就已经需要 $O(N^2)$的时间复杂度，不容易优化，因此我们可以考虑优化只使用了一重循环的枚举「高」的方法。

### 解法二： 单调栈

#### 朴素版

> 单调栈常用于查找比它大的第一个数 or 比它小的第一个数
>
> 单调递增栈：栈内离栈顶越近（下标越大），栈元素越大；栈顶元素为栈内最大
>
> - 当有新元素进入，如果新元素比栈顶元素大，直接入栈。
> - 当有新元素进入，如果新元素比栈顶元素小，栈弹出，直到满足新元素比栈顶元素大，再将新元素入栈。
>
> 由此可见，新元素C使栈顶元素A弹出后，下一个栈顶元素B是A左边第一个比B小的元素，新元素C是A右边第一个比C小的元素

由暴力枚举高的解法可知道，我们枚举高度后需要分别往两边寻找比它矮的第一个柱子（数），因此可以使用单调栈

```c++
class Solution {
public:
    int largestRectangleArea(vector<int>& heights) {
        int ans = 0;
        int n = heights.size();
        vector<int> left(n), right(n);
        stack<int> stk;
        for(int i = 0; i < n; i++){
            while(!stk.empty() && heights[stk.top()] >= heights[i]) stk.pop();
            left[i] = (stk.empty() ? -1 : stk.top());
            stk.push(i);
        }
        stk = stack<int>();
        for(int i = n - 1; i >= 0; i--){
            while(!stk.empty() && heights[stk.top()] >= heights[i]) stk.pop();
            right[i] = (stk.empty() ? n : stk.top());
            stk.push(i);
        }
        for(int i = 0; i < n; i++){
          	// right 和 left 都指向第一个比枚举柱子小的柱子，因此不包含left 和 right
          	// 宽度计算为： (right - 1) - (left + 1) + 1 = right - left - 1
            ans = max(ans, (right[i] - left[i] - 1) * heights[i]);
        }
        return ans;
    }
};
```

**复杂度分析**

- 时间复杂度：*O*(*N*)。
- 空间复杂度：*O*(*N*)。

每一个位置只会入栈一次（在枚举到它时），并且最多出栈一次。

因此当我们从左向右/总右向左遍历数组时，对栈的操作的次数就为 *O*(*N*)。所以单调栈的总时间复杂度为 *O*(*N*)。

#### 优化版

对上述进行优化

> 新元素C使栈顶元素A弹出后，下一个栈顶元素B是A左边第一个比B小的元素，新元素C是A右边第一个比C小的元素

```C++
class Solution {
public:
    int largestRectangleArea(vector<int>& heights) {
        int len = heights.size() + 2;
        vector<int> height(len);
      	// 在heights数组基础上在头尾加上0元素
      	// 这是因为以heights[0]（heights[heights.size() - 1]）作为柱子高度时，缺少左边界（右边界）
      	// 为其补上左右边界，使其能够计算heights[0]（heights[heights.size() - 1]）作为柱子高度时的面积
        height[0] = 0;
        height[len - 1] = 0;
        for(int i = 1; i < len - 1; i++)
            height[i] = heights[i - 1];
        stack<int> stk;
        int ans = 0;
        for(int i = 0; i < len; i++){
            while(!stk.empty() && height[i] < height[stk.top()]){
              	// 新元素i让栈弹出，栈顶元素为stk.top()
                int idx = stk.top();
                stk.pop();
              	// 这里的stk.top()为弹出后的下一个栈顶元素
                int w = i - stk.top() - 1;
              	// 高度为最初的栈顶元素
                ans = max(ans, w * height[idx]);
            }
          	// 没有弹出时不需要计算面积
            stk.push(i);
        }
        return ans;
    }
};
```

**复杂度分析**

- 时间复杂度：*O*(*N*)。
- 空间复杂度：*O*(*N*)。

## 85 最大矩形

https://leetcode.cn/problems/maximal-rectangle/

若`matrix[i][j] == ‘1’`，那么以该点为矩形的右下角

- 记`left[i][j]`为第i行第j列元素左边连续1的个数（包括第i行第j列）
- 那么矩形可以转换为若干个柱形，`left[i][j]`为柱形的高度，题目就变成了84 求柱状图最大的柱形
- 宽度为k - i + 1，k为第i行前的第k行

换一下坐标轴，宽度就是代码中的高度，高度就是代码中的宽度

### 解法一：暴力枚举点

```C++
class Solution {
public:
    int maximalRectangle(vector<vector<char>>& matrix) {
        int n = matrix.size();
        int m = matrix[0].size();
        vector<vector<int>> left(n,vector<int>(m, 0));
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (matrix[i][j] == '1') {
                    left[i][j] = (j == 0 ? 0: left[i][j - 1]) + 1;
                }
            }
        }
        int ans = 0;
        for(int i = 0; i < n; i++){
            for(int j = 0; j < m; j++){
                if(matrix[i][j] == '1'){
                    int w = left[i][j];
                  	// 这里area初始化为w, 因为假设matrix[k][j]都为'0', 宽度至少为1
                    int area = w;
                    for(int k = i - 1; k >= 0; k--){
                        w = min(w, left[k][j]);
                        area = max(area, (i - k + 1) * w);
                    }
                    ans = max(ans, area);
                }
            }
        }
        return ans;
    }
};
```

复杂度分析

时间复杂度：$O(m^2n)$，其中 m 和 n 分别是矩阵的行数和列数。计算 left 矩阵需要 O(mn) 的时间。随后对于矩阵的每个点，需要 O(m) 的时间枚举高度。故总的时间复杂度为$ O(mn)+O(mn)⋅O(m)=O(m^2n)$。

空间复杂度：$O(mn)$，其中 m 和 n 分别是矩阵的行数和列数。我们分配了一个与给定矩阵等大的数组，用于存储每个元素的左边连续 1 的数量。

### 解法二：单调栈

同84 一样，需要求出柱形图最小的高度（代码中为宽度）

与84不同之处在于，本题可以拆分为m列 柱形图，将84题的代码处理m次即可

```c++
class Solution {
public:
    int maximalRectangle(vector<vector<char>>& matrix) {
        int n = matrix.size();
        int m = matrix[0].size();
        vector<vector<int>> left(n, vector<int>(m, 0));
        for(int i = 0; i < n; i++){
            for(int j = 0; j < m; j++){
                if(matrix[i][j] == '1')
                    left[i][j] = (j == 0 ? 0 : left[i][j - 1]) + 1;
            }
        }
        int ans = 0;
        int len = n + 2;
      	// 枚举每一列
        for(int j = 0; j < m; j++){
            stack<int> stk;
            int area = 0;        
            vector<int> ll(len);
            ll[0] = 0;
            ll[len - 1] = 0;
          	// 初始化别弄反了，是left[k - 1][j]，不是left[j][k - 1]
            for(int k = 1; k < len - 1; k++)
                ll[k] = left[k - 1][j];
            for(int i = 0; i < len; i++){
                while(!stk.empty() && ll[i] < ll[stk.top()]){
                    int idx = stk.top();
                    stk.pop();
                    int w = i - stk.top() - 1;
                    area = max(area, w * ll[idx]);
                }
                stk.push(i);
            }
            ans = max(ans, area);
        }
        return ans;
    }
};
```

复杂度分析

时间复杂度：O(mn)，其中 m 和 n 分别是矩阵的行数和列数。计算 left 矩阵需要 O(mn) 的时间；对每一列应用柱状图算法需要 O(m) 的时间，一共需要 O(mn) 的时间。

空间复杂度：O(mn)，其中 m 和 n 分别是矩阵的行数和列数。我们分配了一个与给定矩阵等大的数组，用于存储每个元素的左边连续 1 的数量。

## 112 路径总和

https://leetcode.cn/problems/path-sum/description/

### 做法：递归

本做法中的targetSum为**剔除掉当前节点剩余的targetSum**，即左/右节点到达子节点需要走的路径和

#### 思路版

该版本没有怎么简化，着重于详细的思路

```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
private:
    bool dfs(TreeNode* root, int targetSum){
      	// 判断是否存在左节点
        if(root->left){
          	// 如果左节点存在满足条件的路径，那么当前节点也存在满足条件的路径
            if(dfs(root->left, targetSum - root->left->val))
                return true;
        }
      	// 右节点同理
        if(root->right){
            if(dfs(root->right, targetSum - root->right->val))
                return true;
        }
      	// 如果当前节点为叶子节点
        if(!root->left && !root->right){
            if(targetSum == 0)
                return true;
            else 
                return false;
        }
        return false;       
    }
public:
    bool hasPathSum(TreeNode* root, int targetSum) {
      	// 如果根节点没空，不存在题解
        if(!root)
            return false;
        return dfs(root, targetSum - root->val);
    }
};
```

或写成

```C++
class Solution {
private:
    bool traversal(TreeNode* cur, int count) {
        if (!cur->left && !cur->right && count == 0) return true; // 遇到叶子节点，并且计数为0
        if (!cur->left && !cur->right) return false; // 遇到叶子节点直接返回

        if (cur->left) { // 左
            count -= cur->left->val; // 递归，处理节点;
            if (traversal(cur->left, count)) return true;
            count += cur->left->val; // 回溯，撤销处理结果
        }
        if (cur->right) { // 右
            count -= cur->right->val; // 递归，处理节点;
            if (traversal(cur->right, count)) return true;
            count += cur->right->val; // 回溯，撤销处理结果
        }
        return false;
    }

public:
    bool hasPathSum(TreeNode* root, int sum) {
        if (root == NULL) return false;
        return traversal(root, sum - root->val);
    }
};
```



#### 简化版

```C++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
public:
    bool hasPathSum(TreeNode* root, int targetSum) {
        if(root == NULL) return false;
        if(!root->left && !root->right && targetSum == root->val)   return true;
        return hasPathSum(root->left, targetSum - root->val) || hasPathSum(root->right, targetSum - root->val);
    }
};
```



## 200 岛屿数量

> 题解中这里修改了原数组，大家如果面试的时候，要问清楚面试官是否能修改原数组，不能的话就得加入标记数组，不要一给题就直接上手

### 解法一： dfs

我的解法

```C++
class Solution {
private:
    int dx[4] = {-1, 0, 1, 0};
    int dy[4] = {0, 1, 0, -1};
    void dfs(vector<vector<char>>& grid, vector<vector<bool>>& isVisited, int x,
             int y) {
        int n = grid.size();
        int m = grid[0].size();
        for (int i = 0; i < 4; i++) {
            int a = x + dx[i];
            int b = y + dy[i];
            if (a >= 0 && a < n && b >= 0 && b < m && grid[a][b] == '1' &&
                !isVisited[a][b]) {
                isVisited[a][b] = true;
                dfs(grid, isVisited, a, b);
            }
        }
    }

public:
    int numIslands(vector<vector<char>>& grid) {
        int n = grid.size();
        int m = grid[0].size();
        vector<vector<bool>> isVisited(n, vector<bool>(m, false));
        int ans = 0;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (grid[i][j] == '1' && !isVisited[i][j]) {
                    ans++;
                    isVisited[i][j] = true;
                    dfs(grid, isVisited, i, j);
                }
            }
        }
        return ans;
    }
};
```

复杂度分析

时间复杂度：O(MN)，其中 M 和 N 分别为行数和列数。

空间复杂度：O(MN)，在最坏情况下，整个网格均为陆地，深度优先搜索的深度达到 MN。

### 解法二： bfs

我的解法

与dfs类似

```C++
class Solution {
private:
    typedef pair<int,int> PII;
    int dx[4] = {-1, 0, 1, 0};
    int dy[4] = {0, 1, 0, -1};
    void bfs(vector<vector<char>>& grid, vector<vector<bool>>& isVisited, int x, int y){
        int n = grid.size();
        int m = grid[0].size();
        queue<PII> q;
        q.push({x, y});
        while(!q.empty()){
            auto t = q.front();
            q.pop();
            for(int i = 0; i < 4; i++){
                int a = t.first + dx[i];
                int b = t.second + dy[i];
                if(a >= 0 && a < n && b >=0 && b < m && grid[a][b] == '1' && !isVisited[a][b]){
                    isVisited[a][b] = true;
                    q.push({a, b});
                }
            }
        }
    }
public:
    int numIslands(vector<vector<char>>& grid) {
        int n = grid.size();
        int m = grid[0].size();
        vector<vector<bool>> isVisited(n, vector<bool>(m, false));
        int ans = 0;
        for(int i = 0; i < n; i++){
            for(int j = 0; j < m; j++){
                if(grid[i][j] == '1' && !isVisited[i][j]){
                    ans++;
                    bfs(grid, isVisited, i, j);
                }
            }
        }
        return ans;
    }
};
```

**复杂度分析**

时间复杂度：O(MN)，其中 M 和 N 分别为行数和列数。

空间复杂度：O(min(M,N))，在最坏情况下，整个网格均为陆地，队列的大小可以达到 min(M,N)。

### 解法三： 并查集

```C++
class Solution {
private:
    vector<int> p;
    vector<bool> isVisited;
    int res;
    int dx[4] = {-1, 0, 1, 0};
    int dy[4] = {0, 1, 0, -1};
    int Find(int x) {
        if (p[x] != x)
            p[x] = Find(p[x]);
        return p[x];
    }
    void Union(int x, int y) {
      	// 每次合并都要res减一，因此如果合并过直接跳过，以免res多减
        if (Find(x) == Find(y))
            return;
        p[Find(x)] = Find(y);
        res--;
    }

public:
    int numIslands(vector<vector<char>>& grid) {
        int n = grid.size();
        int m = grid[0].size();
        p.resize(n * m);
        isVisited.resize(n * m);
        res = 0;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                int idx = i * m + j;
                if (grid[i][j] == '1') {
                    p[idx] = idx;
                    res++;
                }
            }
        }
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                int idx = i * m + j;
                if (grid[i][j] == '1') {
                  	// 只有这个地方需要标记已遍历
                    isVisited[idx] = true;
                    for (int k = 0; k < 4; k++) {
                        int a = i + dx[k];
                        int b = j + dy[k];
                        if (a >= 0 && a < n && b >= 0 && b < m &&
                            grid[a][b] == '1' && !isVisited[a * m + b]) {
                          	// 这里不需要标记遍历，因为Union不会继续往下访问下一个节点
                          	// 不是递归函数！
                            Union(idx, a * m + b);
                        }
                    }
                }
            }
        }
        return res;
    }
};
```

复杂度分析

时间复杂度：O(MN×α(MN))，其中 M 和 N 分别为行数和列数。注意当使用路径压缩（见 find 函数）和按秩合并（见数组 rank）实现并查集时，单次操作的时间复杂度为 α(MN)，其中 α(x) 为反阿克曼函数，当自变量 x 的值在人类可观测的范围内（宇宙中粒子的数量）时，函数 α(x) 的值不会超过 5，因此也可以看成是常数时间复杂度。

空间复杂度：O(MN)，这是并查集需要使用的空间。

> 我没有使用按秩合并



## 209 长度最小的子数组

https://leetcode.cn/problems/minimum-size-subarray-sum/description/

题目关键在于：这个子数组是连续的

### 解法一：暴力枚举

先枚举子数组的起点，再往后枚举，满足sum >= target停止，计算子数组长度 j - i + 1

```C++
class Solution {
private:
    const int INF = 0x3f3f3f3f;
public:
    int minSubArrayLen(int target, vector<int>& nums) {
        int n = nums.size();
        int ans = INF;
        for(int i = 0; i < n; i++){
            int sum = 0;
            for(int j = i; j < n; j++){
                sum += nums[j];
                if(sum >= target)
                    ans = min(ans, j - i + 1);
            }
        }
        if(ans == INF) 
            return 0;
        else
            return ans;
    }
};
```

复杂度分析

时间复杂度：$O(n^2)$，其中 n 是数组的长度。需要遍历每个下标作为子数组的开始下标，对于每个开始下标，需要遍历其后面的下标得到长度最小的子数组。

空间复杂度：O(1)。

### 解法二： 前缀和 + 二分查找

解法一枚举起点之后又向后枚举了n个元素才找到sum >= target

由于本题限定了“正整数元素”，对于这种找到第一个满足sum >= target的元素，显然可以使用二分查找

我们的目标是sum >= target 而不是num >= target，因此需要一个数组记录每个元素作为末尾时的sum[i]

因此想到前缀和

```C++
class Solution {
private:
    const int INF = 0x3f3f3f3f;

public:
    int minSubArrayLen(int target, vector<int>& nums) {
        int n = nums.size();
        vector<int> s(n + 1);
        //  计算前缀和
        for (int i = 1; i <= n; i++) {
            // 这里原本是nums[i]，但是nums和s的下标之间偏移了1
            s[i] = s[i - 1] + nums[i - 1];
        }
        int ans = INF;
        // 遍历起点，由于是遍历前缀和，所以下标可直接从1开始
        for (int i = 1; i <= n; i++) {
            // 我们要找到sum >= target
            // sum = s[idx] - s[i - 1]
            // 因此二分查找的目标为在数组s中找到大于等于target + s[i -
            // 1]的第一个元素
            int t = target + s[i - 1];
            auto it = lower_bound(s.begin(), s.end(), t);
            if (it != s.end()) {
                int idx = distance(s.begin(), it);
                ans = min(ans, idx - i + 1);
            }
        }
        return ans == INF ? 0 : ans;
    }
};
```

二分自己实现如下：

```C++
class Solution {
private:
    const int INF = 0x3f3f3f3f;

public:
    int minSubArrayLen(int target, vector<int>& nums) {
        int n = nums.size();
        vector<int> s(n + 1);
        //  计算前缀和
        for (int i = 1; i <= n; i++) {
            // 这里原本是nums[i]，但是nums和s的下标之间偏移了1
            s[i] = s[i - 1] + nums[i - 1];
        }
        int ans = INF;
        // 遍历起点，由于是遍历前缀和，所以下标可直接从1开始
        for (int i = 1; i <= n; i++) {
            // 我们要找到sum >= target
            // sum = s[idx] - s[i - 1]
            // 因此二分查找的目标为在数组s中找到大于等于target + s[i - 1]的第一个元素
            int t = target + s[i - 1];
            int l = i, r = n;
            while(l < r){
                int mid = l + r >> 1;
                if(s[mid] >= t) r = mid;
                else l = mid + 1;
            }
            if(s[l] >= t)
                ans = min(ans, l - i + 1);
        }
        return ans == INF ? 0 : ans;
    }
};
```

### 解法三：移动窗口

由于题目的子数组是连续的序列，求sum >= target子数组长度最小值，实际上是要求子数组滑动时的最小值 >= target

想让子数组长度最小，意味着这个移动窗口的长度不定，因此移动窗口的头部也需要改变

加进一个元素

```C++
class Solution {
private:
    const int INF = 0x3f3f3f3f;
public:
    int minSubArrayLen(int target, vector<int>& nums) {
        int n = nums.size();
        int start = 0, end = 0;
        int ans = INF;
        int sum = 0;
        while(end < n){
            sum += nums[end];
            while(sum >= target){
                ans = min(ans, end - start + 1);
                sum -= nums[start];
                start++;
            }
            end++;
        }
        return ans == INF ? 0 : ans;
    }
};
```

以上是双指针做法

如果套模板，使用队列解决，则是：

```C++
class Solution {
private:
    const int INF = 0x3f3f3f3f;
public:
    int minSubArrayLen(int target, vector<int>& nums) {
        int n = nums.size();
        queue<int> q;
        int sum = 0;
        int ans = INF;
        for(int i = 0; i < n; i++){
          	// 先加nums[i] 再对队头进行判断
            q.push(i);
            sum += nums[i];
          	// 处理队头
            while(!q.empty() && sum >= target){
                sum -= nums[q.front()];
                ans = min(ans, q.back() - q.front() + 1);
                q.pop();
            }
        }
        return ans == INF ? 0 : ans;
    }
};
```

需要注意的是，队列的头是早加入的元素，尾是刚刚加入的元素，即头对应start，尾对应end

## 234 回文链表

https://leetcode.cn/problems/palindrome-linked-list/solutions/457059/hui-wen-lian-biao-by-leetcode-solution/?envType=study-plan-v2&envId=top-100-liked

### 递归版

利用函数递归特性，当函数遍历到最底层遇到终止条件才会返回，终止条件设置为nullptr，则函数到达最后一个节点才会返回

此时我们设置firstPointer指向第一个节点，当函数开始返回时，将curNode与firstPointer的值进行比较

如果某次比较发现不相等，那么说明不是回文链表，需要向上传递结果，因此返回值设置为bool类型

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
private:
    ListNode* firstPointer;
public:
    bool recursivelyCheck(ListNode* curNode){
        if(!curNode)
            return true;
        if(!recursivelyCheck(curNode->next))
            return false;
        if(firstPointer->val != curNode->val)
            return false;
        firstPointer = firstPointer->next;
        return true;
    }
    bool isPalindrome(ListNode* head) {
        firstPointer = head;
        return recursivelyCheck(head);
    }
};
```

**复杂度分析**

- 时间复杂度：*O*(*n*)，其中 *n* 指的是链表的大小。
- 空间复杂度：*O*(*n*)，其中 *n* 指的是链表的大小。

### 迭代版

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
private:
    ListNode* reverseList(ListNode* head) {
        ListNode* prev = nullptr;
        ListNode* cur = head;
        while (cur) {
            ListNode* next = cur->next;
            cur->next = prev;
            prev = cur;
            cur = next;
        }
        return prev;
    }
    ListNode* getFirstEnd(ListNode* head) {
        ListNode *fast = head, *slow = head;
        while (fast->next != nullptr && fast->next->next != nullptr) {
            fast = fast->next->next;
            slow = slow->next;
        }
        return slow;
    }

public:
    bool isPalindrome(ListNode* head) {
        if (!head)
            return true;
        ListNode* firstEnd = getFirstEnd(head);
        ListNode* secondHead = reverseList(firstEnd->next);
        ListNode *p1 = head, *p2 = secondHead;
        while (p2) {
            if (p1->val != p2->val)
                return false;
            p1 = p1->next;
            p2 = p2->next;
        }
        // 如果需要恢复原状
        firstEnd->next = reverseList(secondHead);
        return true;
    }
};
```

**复杂度分析**

时间复杂度：O(n)，其中 n 指的是链表的大小。

空间复杂度：O(1)。我们只会修改原本链表中节点的指向，而在堆栈上的堆栈帧不超过 O(1)。

## 279 完全平方数

思路：

题目要求和为i的完全平方数最小数量

假设选择了j (j <= i)，那么接下来要找的就是和为i - j*j的完全平方数最小数量

可以看出，这是一个状态递推式，可以使用动态规划

f[i - j* j]下标比f[i]小，所以可以从小到大遍历

```C++
class Solution {
public:
    int numSquares(int n) {
        // dp[i]表示和为i的完全平方数的最少数量
        // dp[0] = 0
        vector<int> dp(n + 1, 0);
        for(int i = 1; i <= n; i++){
            // 枚举完全平方数
            dp[i] = INT_MAX;
            for(int j = 1; j * j <=i; j++){
                dp[i] = min(dp[i],1 + dp[i - j * j]);
            }
        }
        return dp[n];
    }
};
```





## 415 字符串相加（大数加法）

```C++
class Solution {
public:
    string addStrings(string num1, string num2) {
        int len1 = num1.size(), len2 = num2.size();
        if (len1 < len2)
            return addStrings(num2, num1);
      	// 将num1，num2反向存储，因为最高位放在数组末端，方便进位
        vector<int> a, b;
        for (int i = len1 - 1; i >= 0; i--)
            a.push_back(num1[i] - '0');
        for (int i = len2 - 1; i >= 0; i--)
            b.push_back(num2[i] - '0');
        string ans;
        int t = 0;
        for (int i = 0; i < len1; i++) {
            t += a[i];
            if (i < len2)
                t += b[i];
            ans.push_back(t % 10 + '0');
            t /= 10;
        }
        if (t)
            ans.push_back(t + '0');
     		// ans也为倒序，真实答案需要反过来
        reverse(ans.begin(), ans.end());
        return ans;
    }
};
```



## 470 用rand7() 实现rand10()

```C++
// The rand7() API is already defined for you.
// int rand7();
// @return a random integer in the range 1 to 7

class Solution {
public:
    int rand10() {
        while (true) {
            // (rand_X - 1) * Y + rand_Y 可构造[1, X * Y]
            // 相当于构造一个Y进制的数，个位是rand_Y，满足Y进制，每个个位等概率分布
            // “十位”是 (rand_X - 1)，也是等概率分布
            // rand_X为[1,X]
            // 类比于3 = 二进制的 11 = 2 * 1 + 2，这里Y就是2，X - 1就是1
            // 因此能够构造的最大值为 Y * (X - 1) + Y
            int num = (rand7() - 1) * 7 + (rand7() - 1); // num 为等概率[0, 48]
            // 对[0,48]取我们需要的值[1,11]
            if (num >= 1 && num <= 40)
                return num % 10 + 1;

            // 对多出来的值0,41,42...48继续利用
            // num % 40 = 0, 1, 2, 3, ...,8 = rand9() - 1
            // 继续利用公式构造等概率分布
            num = (num % 40) * 7 + rand7() - 1;
            // num取值为[0, 62]
            // 无用数字只有0, 1, 2
            if (num >= 1 && num <= 60)
                return num % 10 + 1;

            // 同理
            // num % 60 = 0, 1, 2 = rand3() - 1
            // num取值为[0, 20]
            num = (num % 60) * 7 + rand7() - 1;
            if (num >= 1 && num <= 20)
                return num % 10 + 1;

            // 最后无用数字只有0
        }
    }
};
```



## 503 下一个更大元素II

https://leetcode.cn/problems/next-greater-element-ii/description/

遍历一遍数组显然不够，可复制一份数组拼接在原数组末尾，实现循环数组

实际操作中，我们不需要复制，只需要遍历两次数组即可，i % n 对应nums的下标

```C++
class Solution {
public:
    vector<int> nextGreaterElements(vector<int>& nums) {
        int n = nums.size();
        stack<int> stk;
        vector<int> ans(n, -1);
        for (int i = 0; i < 2 * n - 1; i++) {
            while (!stk.empty() && nums[i % n] > nums[stk.top()]) {
                ans[stk.top()] = nums[i % n];
                stk.pop();
            }
            stk.push(i % n);
        }
        return ans;
    }
};
```

**复杂度分析**

时间复杂度: O(n)，其中 n 是序列的长度。我们需要遍历该数组中每个元素最多 2 次，每个元素出栈与入栈的总次数也不超过 4 次。

空间复杂度: O(n)，其中 n 是序列的长度。空间复杂度主要取决于栈的大小，栈的大小至多为 2n−1。



## 547 省份数量

### 解法一：dfs

本题nxn矩阵可视作邻接矩阵，对其可以进行图论的dfs或bfs遍历，找出所有的连通分量

关键在于如果计算连通分量的个数：如果第i - 1次dfs遍历后仍有节点没有被遍历，说明其属于新的连通分量

```C++
class Solution {
private:
    void dfs(vector<vector<int>>& isConnected, vector<bool>& isVisited, int idx){
        for(int j = 0; j < isConnected[idx].size(); j++){
            if(isConnected[idx][j] && !isVisited[j]){
                isVisited[j] = true;
                dfs(isConnected, isVisited, j);
            }
        }
    }
public:
    int findCircleNum(vector<vector<int>>& isConnected) {
        int n = isConnected.size();
        vector<bool> isVisited(n, false);
        int ans = 0;
        for(int i = 0; i < n; i++){
            // 遍历一遍后，如果第二遍还出现了没有遍历过的节点
            // 说明出现新的连通分量
            if(!isVisited[i]){
                // 找出i对应的所有连通节点，对其标记
                dfs(isConnected, isVisited, i);
                // i没有被访问过，所以出现新的连通分量
                ans++;
            }
        }
        return ans;
    }
};
```

**复杂度分析**

时间复杂度：$O(n^2)$，其中 n 是城市的数量。需要遍历矩阵 n 中的每个元素。

空间复杂度：$O(n)$，其中 n 是城市的数量。需要使用数组 visited 记录每个城市是否被访问过，数组长度是 n，递归调用栈的深度不会超过 n

### 解法二： bfs

与dfs类似，以每个节点bfs遍历一遍，如果遍历停止，说明其访问完所有相连的节点

遍历后还有未访问的节点，说明有新的连通分量

```C++
class Solution {
public:
    int findCircleNum(vector<vector<int>>& isConnected) {
        int n = isConnected.size();
        vector<bool> isVisited(n, false);
        int ans = 0;
        for(int i = 0; i < n; i++){
            queue<int> q;
            if(!isVisited[i]){
                ans++;
                q.push(i);
                while(!q.empty()){
                    int idx = q.front();
                    q.pop();
                    for(int j = 0; j < n; j++){
                        if(isConnected[idx][j] && !isVisited[j]){
                            q.push(j);
                            isVisited[j] = true;
                        }
                    }
                }
            }
        }
        return ans;
    }
};
```

**复杂度分析**

时间复杂度：$O(n^2)$，其中 n 是城市的数量。需要遍历矩阵 isConnected 中的每个元素。

空间复杂度：$O(n)$，其中 n 是城市的数量。需要使用数组 visited 记录每个城市是否被访问过，数组长度是 n，广度优先搜索使用的队列的元素个数不会超过 n。

### 解法三： 并查集

```C++
class Solution {
public:
    int Find(vector<int>& p, int x) {
        if (p[x] != x)
            p[x] = Find(p, p[x]);
        return p[x];
    }
    void Union(vector<int>& p, int x, int y) { p[Find(p, x)] = Find(p, y); }

    int findCircleNum(vector<vector<int>>& isConnected) {
        int n = isConnected.size();
        int m = isConnected[0].size();
        vector<int> parent(n);
        for (int i = 0; i < n; i++)
            parent[i] = i;
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < m; j++) {
                if (isConnected[i][j])
                    Union(parent, i, j);
            }
        }
        int ans = 0;
        for (int i = 0; i < n; i++) {
            if (parent[i] == i)
                ans++;
        }
        return ans;
    }
};
```

**复杂度分析**

时间复杂度：$O(n^2logn)$，其中 n 是城市的数量。需要遍历矩阵 isConnected 中的所有元素，时间复杂度是 $O(n^2)$，如果遇到相连关系，则需要进行 2 次查找和最多 1 次合并，一共需要进行 $2n^2$次查找和最多$n^2$次合并，因此总时间复杂度是$ O(2n^2logn^2 )=O(n^2logn)$。这里的并查集使用了路径压缩，但是没有使用按秩合并，最坏情况下的时间复杂度是 $O(n^2logn)$，平均情况下的时间复杂度依然是 $O(n2α(n))$，其中 α 为阿克曼函数的反函数，$α(n) $可以认为是一个很小的常数。

空间复杂度：$O(n)$，其中 n 是城市的数量。需要使用数组 parent 记录每个城市所属的连通分量的祖先。



## 684 冗余连接

https://leetcode.cn/problems/redundant-connection/

本题给出n个点和n条边，由于树的边数为节点数 -1， 所以实际上只会多出一条边，这条边就是我们要求的解

如果多条答案边，创一个ans数组依次放入，最后返回末尾元素即可（即栈顶元素）

```C++
class Solution {
private:
    vector<int> p;
    void init(int n){
        p.resize(n + 1);
        for(int i = 1; i <= n; i++)
            p[i] = i;
    }
    int Find(int x){
        if(p[x] != x) p[x] = Find(p[x]);
        return p[x];
    }
    void Union(int x, int y){
        p[Find(x)] = Find(y);
    }
public:
    vector<int> findRedundantConnection(vector<vector<int>>& edges) {
        int n = edges.size();
        init(n);
        for(auto edge: edges){
            int x = edge[0], y = edge[1];
            if(Find(x) != Find(y)){
                Union(x, y);
            }
            // p[x] == p[y]说明x和y在一棵树中了，此时多加的那条边会使树变成图，即题解
            else return edge;
        }
        return vector<int>();
    }
};
```



## 739 每日温度

https://leetcode.cn/problems/daily-temperatures/description/

> 找出左/右边第一个比栈顶元素小 ->  单调递增栈
>
> 找出左/右边第一个比栈顶元素大 -> 单调递减栈

```C++
class Solution {
public:
    vector<int> dailyTemperatures(vector<int>& temperatures) {
        int n = temperatures.size();
        stack<int> stk;
        vector<int> ans(n, 0);
        for(int i = 0; i < n; i++){
          	// 单调递减栈，弹出说明新元素i是第一个比栈顶元素大的元素
            while(!stk.empty() && temperatures[i] > temperatures[stk.top()]){
              	// 题目问的是几天后
                ans[stk.top()] = i - stk.top();
                stk.pop();
            }
            stk.push(i);
        }
        return ans;
    }
};
```

**复杂度分析**

时间复杂度：O(n)，其中 n 是温度列表的长度。正向遍历温度列表一遍，对于温度列表中的每个下标，最多有一次进栈和出栈的操作。

空间复杂度：O(n)，其中 n 是温度列表的长度。需要维护一个单调栈存储温度列表中的下标。



## 912 排序数组

### 堆排序

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



### 归并排序

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



### 快速排序

```C++
class Solution {
private:
    void quickSort(vector<int>& nums, int l, int r) {
        // 注意是l < r
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
            // 因为是 l < r 所以这里是quickSort(nums, l, j)而不是quickSort(nums, l, j - 1)
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

## 模拟题

### 146 LRU缓存

```C++
class DListNode {
public:
    int key;
    int value;
    DListNode* prev;
    DListNode* next;
    DListNode():key(0), value(0),prev(nullptr),next(nullptr){};
    DListNode(int key_, int value_) : key(key_), value(value_),prev(nullptr),next(nullptr) {}
};

class LRUCache {
private:
    DListNode* head;
    DListNode* tail;
    unordered_map<int, DListNode*> cache;
    int size;
    int capacity;

    void addToHead(DListNode* node) {
        node->prev = head;
        node->next = head->next;
        head->next->prev = node;
        head->next = node;
    }

    void removeNode(DListNode* node) {
        node->prev->next = node->next;
        node->next->prev = node->prev;
    }

    void moveToHead(DListNode* node) {
        removeNode(node);
        addToHead(node);
    }

    DListNode* removeTail() {
        DListNode* node = tail->prev;
        removeNode(node);
        return node;
    }

public:
    LRUCache(int capacity) {
        this->capacity = capacity;
        head = new DListNode();
        tail = new DListNode();
        head->next = tail;
        tail->prev = head;
        size = 0;
    }

    int get(int key) {
        if (!cache.count(key))
            return -1;
        DListNode* node = cache[key];
        moveToHead(node);
        return node->value;
    }

    void put(int key, int value) {
        if (cache.count(key)) {
            DListNode* node = cache[key];
            moveToHead(node);
            node->value = value;
        } else {
            DListNode* node = new DListNode(key, value);
            addToHead(node);
            cache[key] = node;
            ++size;
            if (size > capacity) {
                DListNode* t = removeTail();
                cache.erase(t->key);
                delete t;
                --size;
            }
        }
    }
};

/**
 * Your LRUCache object will be instantiated and called as such:
 * LRUCache* obj = new LRUCache(capacity);
 * int param_1 = obj->get(key);
 * obj->put(key,value);
 */
```



## 刷题总结

### 滑动窗口

> 单向队列queue，`#include <queue>` , 仅支持插入队尾push(int i)，弹出队头pop()
>
> 双向队列duque，`#include<deque>`, 支持插入队头push_front(int i)，插入队尾push_back(int i)，删除队头pop_front()，删除队尾pop_back()

对于一般的滑动窗口，如果不用pop队尾，可以用queue

```C++
		queue<int> q;
		// 遍历序列每个元素
		for(int i = 0; i < n; i++){
      	// 检查新加入的元素是否满足条件，如果满足，加入队尾
      	if(check(q.front(), i))
      			q.push(i);
      	// 根据问题，对插入的nums[i]操作
      	...
      	// check(q.front())意为：检查队头是否满足条件，如果不满足，则弹出
				while(!q.empty() && check(q.front())){
						q.pop();
				}
		}
```

如果需要求滑动窗口最大最小值，可以使用deque

```C++
		deque<int> q;
		// 遍历序列每个元素
		for(int i = 0; i < n; i++){
      	// 检查队头是否满足条件，如果不满足，弹出队头	
      	while(!q.empty() && check(q.front()))	q.pop_front();
      	// 检查队尾是否满足条件，如果不满足，弹出队尾
      	while(!q.empty() && check(q.back(), i)) q.pop_back(i);
      	// 将新元素加入队尾
      	q.push_back(i);
		}
```

例如acwing 154 滑动窗口

https://www.acwing.com/problem/content/156/

```C++
#include <iostream>
#include <deque>
using namespace std;

const int N = 1e6 + 10;
int a[N];
int n, k;

int main(){
    deque<int> q;
    cin >> n >> k;
    for(int i = 0; i < n; i++)
        cin >> a[i];
    // 求滑动窗口最小值
    for(int i = 0; i < n; i++){
        // 队列存储的是滑动窗口的最小值的索引
        // 队列的长度不一定为k
        
        // 窗口第一个元素的索引为idx，长度为k的窗口对应的末尾元素的索引为idx + k - 1，也为i
        // 所以i = idx + k - 1 或idx = i - k + 1
        // 可推出：
        // （1）i = idx + k - 1:
        //      所以一开始idx = 0，窗口未满，往里面填元素，当i == k - 1时，窗口刚好满；之后i > k - 1
        // （2）idx = i + k - 1:
        //      想要保持窗口一直为k，那么需要idx = i - k + 1 <= q.front()
        //      如果i - k + 1 > q.front() 说明队头已经不在窗口内，需要弹出
        
        
        // pop前保证队列不为空 且 保证窗口始终保持在k个
        // 如果超出k个，说明队头需要弹出
        // 如果不足或等于k个，队头也不需要弹出
        while(!q.empty() && i - k + 1 > q.front()) q.pop_front();
        // pop前保证队列不为空 且 如果队尾元素a[q.back()]比新元素a[i]还小
        // 那么只要a[i]还在窗口内，之后窗口的最小值一定不为a[q.back()]
        // 因此弹出队尾元素
        while(!q.empty() && a[i] < a[q.back()]) q.pop_back();
        q.push_back(i);
        
        if(i - k + 1 >= 0)
            cout << a[q.front()] << " ";
    }
    q.clear();
    cout << endl;
    // 求滑动窗口最大值
    for(int i = 0; i < n; i++){
        while(!q.empty() && i - q.front() + 1 > k) q.pop_front();
        while(!q.empty() && a[i] > a[q.back()]) q.pop_back();
        q.push_back(i);
        if(i - k + 1 >= 0)
            cout << a[q.front()] << " ";
    }
}
```

当然，还可以使用双指针，只需要指向原来的数组即可

### 图：网格问题

网格问题

### 并查集

可解决图的连通分量问题

### 单调栈



## STL

### 二分查找

https://blog.csdn.net/weixin_45031801/article/details/137544229

lower_bound( begin , end , val , less<type>() )
上述代码中加入了 less<type>() 自定义比较函数：适用于从小到大排序的有序序列，从数组/容器的 beign 位置起，到 end-1 位置结束，查找第一个 大于等于 val 的数字
lower_bound( begin , end , val , greater<type>() )
上述代码中加入了 greater<type>() 自定义比较函数：适用于从大到小排序的有序序列，从数组/容器的 beign 位置起，到 end-1 位置结束，查找第一个 小于等于 val 的数字

#### upper_bound

前提是有序的情况下，upper_bound返回第一个大于val值的位置。（通过二分查找）

#### lower_bound

前提是**有序**的情况下，lower_bound 返回指向第一个值不小于 val 的位置，也就是返回第一个大于等于val值的位置。（通过二分查找）

***\*注意：\****需要注意的是如果例子中（val >= 8）,那么迭代器就会指向last位置，***\*也就是数组尾元素的下一个，不管val多大，迭代器永远指向尾元素的下一个位置\****

```c++
#include <iostream>
#include <algorithm>
#include <vector>
using namespace std;
 
int main()
{
	vector<int> v = { 3,4,1,2,8 };
	// 先排序
	sort(v.begin(), v.end());  // 1 2 3 4 8
 
	// 定义两个迭代器变量
	vector<int>::iterator iter1;
	vector<int>::iterator iter2;
 
	// 在动态数组中寻找 >=3 出现的第一个数 并以迭代器的形式返回
	iter1 = lower_bound(v.begin(), v.end(), 3);  // -- 指向3
	// 在动态数组中寻找 >=7 出现的第一个数 并以迭代器的形式返回
	iter2 = lower_bound(v.begin(), v.end(), 7);  // -- 指向8
 
	cout << distance(v.begin(), iter1) << endl; //下标 2
	cout << distance(v.begin(), iter2) << endl; //下标 4 
	return 0;
}

```

## 其他细节

```C++
while(index--){
}
```

等价于

```C++
for(int i = 0; i < index; i++){
}
```

