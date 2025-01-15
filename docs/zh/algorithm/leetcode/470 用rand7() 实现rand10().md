# 470 用rand7() 实现rand10()

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