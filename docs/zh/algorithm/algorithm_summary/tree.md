# 二叉树和多叉树

## 二叉树

### 构造二叉树

[如何通过数组构造二叉树输入用例](https://programmercarl.com/%E5%89%8D%E5%BA%8F/ACM%E6%A8%A1%E5%BC%8F%E5%A6%82%E4%BD%95%E6%9E%84%E5%BB%BA%E4%BA%8C%E5%8F%89%E6%A0%91.html#java)

```C++
#include <iostream>
#include <vector>
#include <queue>
using namespace std;

struct TreeNode{
    int val;
    TreeNode* left;
    TreeNode* right;
    TreeNode() : val(0), left(nullptr), right(nullptr){}
    TreeNode(int x) : val(x), left(nullptr), right(nullptr){}
    TreeNode(int x, TreeNode* left, TreeNode* right) : val(0), left(left), right(right){}
};

TreeNode* buildTree(vector<int>& nums){
    TreeNode* root = nullptr;
    vector<TreeNode*> vec(nums.size());
    for(int i = 0; i < nums.size(); i++){
        TreeNode* newNode = nullptr;
        // -1插入nullptr，否则插入newNode
        if(nums[i] != -1)
            newNode = new TreeNode(nums[i]);
        vec[i] = newNode;
    }
    root = vec[0];
    for(int i = 0; i < vec.size(); i++){
        TreeNode* cur = vec[i];
        if(cur != nullptr){
            if(2 * i + 1 < vec.size())
                cur->left = vec[2 * i + 1];
            if(2 * i + 2 < vec.size())
                cur->right = vec[2 * i + 2];
        }
    }
    return root;
}

void printTree(TreeNode* root){
    if(!root)
        return;
    queue<TreeNode*> q;
    q.push(root);
    vector<vector<int>> ans;
    while(!q.empty()){
        int size = q.size();
        vector<int> res;
        while(size--){
            TreeNode* cur = q.front();
            q.pop();
            // vec含有nullptr，对应nums[i]代表没有节点，打印的时候需要再次转换为-1
            if(cur != nullptr){
                res.push_back(cur->val);
                q.push(cur->left);
                q.push(cur->right);
            }else{
                res.push_back(-1);
            }
        }
        ans.push_back(res);
    }

    for(vector<int>& vec: ans){
        for(int num : vec){
            cout << num << " ";
        }
        cout << endl;
    }
}

int main(){
    vector<int> nums = {3, 9, 20, -1, -1, 15, 7};
    printTree(buildTree(nums));
}
```