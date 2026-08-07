# CS 231 期末复习笔记

按考试情报组织：分治（+递归式）、回溯、BFS/DFS、DP、随机化算法、problem definition、认 paradigm、双变量 running time。
所有伪代码都是考试可直接套用的写法。

---

## §1 伪代码怎么写才拿分

考试写伪代码不要求任何具体语言语法，但要求**无歧义**。答题 checklist：

- [ ] 算法有名字和输入，如 `MergeSort(A[1..n])`，说明输入是什么（数组？图？集合？）。
- [ ] 有明确的**返回/输出**语句。
- [ ] 递归算法必须有 **base case**（漏 base case 是最常见扣分点）。
- [ ] 循环边界写清楚：`for i = 1 to n`，不要写 `for each i`（除非遍历集合）。
- [ ] 回溯算法必须有**撤销（undo）**那一步。
- [ ] 用到的辅助变量第一次出现时说明含义（一行注释即可）。
- [ ] 写完后**用一个小例子在脑内跑一遍**（n=0、n=1 的边界尤其要跑）。
- [ ] 题目若要求分析，最后写一句 running time 及理由。

允许的写法：`swap(A[i], A[j])`、`floor(n/2)`、"把 x 加入集合 R"这类自然语言混排都可以，只要每步含义唯一。

---

## §2 Divide and Conquer（第一大题）

### 2.1 思想与模板

三步：**Divide**（把问题分成若干更小的同类子问题）→ **Conquer**（递归解子问题）→ **Combine**（合并子问题的解）。

```text
DC(P):
  if P 足够小 (base case):
      直接求解并返回
  把 P 分成子问题 P1, ..., Pa        // 通常大小为 n/b
  for each Pi:  Si = DC(Pi)          // 递归
  return Combine(S1, ..., Sa)        // 合并
```

**适用**：子问题相互独立、同构，且合并步骤不太贵（排序、查找、最大子段和、大整数乘法…）。
**不适用**：子问题重叠（→ 用 DP）、无法有效合并。

### 2.2 三个必背例子

**① Binary Search** —— T(n) = T(n/2) + O(1) = **O(log n)**

```text
BinarySearch(A[lo..hi], t):        // A 已升序排序
  if lo > hi: return NOT_FOUND     // base case
  mid = floor((lo + hi) / 2)
  if A[mid] == t: return mid
  else if A[mid] < t: return BinarySearch(A[mid+1..hi], t)
  else:               return BinarySearch(A[lo..mid-1], t)
```

**② Merge Sort** —— T(n) = 2T(n/2) + O(n) = **O(n log n)**

```text
MergeSort(A[1..n]):
  if n <= 1: return A                    // base case
  mid = floor(n/2)
  L = MergeSort(A[1..mid])
  R = MergeSort(A[mid+1..n])
  return Merge(L, R)

Merge(L[1..p], R[1..q]):                 // 合并两个有序数组，O(p+q)
  i = 1; j = 1; result = 空列表
  while i <= p and j <= q:
      if L[i] <= R[j]: append L[i] to result; i = i + 1
      else:            append R[j] to result; j = j + 1
  把 L[i..p] 和 R[j..q] 中剩余元素依次接到 result 末尾
  return result
```

**③ 快速幂 Power** —— T(n) = T(n/2) + O(1) = **O(log n)**

```text
Power(x, n):                 // 计算 x^n, n 为非负整数
  if n == 0: return 1        // base case
  half = Power(x, floor(n/2))
  if n 是偶数: return half * half
  else:        return half * half * x
```

### 2.3 Recurrence relation（大题最后一小问，重点！）

朋友确认：分治大题最后一问要写 **T(n) 的递归式**，可能还要解出来（Master theorem）。

**怎么从伪代码写出 T(n)：**

> T(n) = （递归调用次数 a）× T(子问题大小 n/b) + （每层除递归外的工作量 f(n)），并写上 base case T(1) = O(1)。

逐项对应：递归几次 → a；每次输入砍成多大 → n/b；divide + combine 花多少 → f(n)。
例：MergeSort 递归 2 次、每次规模 n/2、Merge 花 O(n) ⇒ **T(n) = 2T(n/2) + O(n)**。

**Master Theorem（简化版）**：对 T(n) = a·T(n/b) + O(n^d)，其中 a ≥ 1, b > 1, d ≥ 0，比较 d 与 log_b(a)：

| 比较 | 结果 |
|---|---|
| d < log_b(a)（递归占主导） | T(n) = O(n^(log_b a)) |
| d = log_b(a)（每层持平） | T(n) = O(n^d · log n) |
| d > log_b(a)（合并占主导） | T(n) = O(n^d) |

**常见递归式速查表（背）：**

| 递归式 | 解 | 典型算法 |
|---|---|---|
| T(n) = T(n/2) + O(1) | O(log n) | binary search |
| T(n) = T(n/2) + O(n) | O(n) | — |
| T(n) = 2T(n/2) + O(1) | O(n) | — |
| T(n) = 2T(n/2) + O(n) | O(n log n) | merge sort |
| T(n) = 4T(n/2) + O(n) | O(n²) | — |
| T(n) = 3T(n/2) + O(n) | O(n^(log₂3)) ≈ O(n^1.585) | Karatsuba 大整数乘法 |
| T(n) = T(n−1) + O(1) | O(n) | 线性递归 |
| T(n) = T(n−1) + O(n) | O(n²) | 最坏情况 quicksort |
| T(n) = 2T(n−1) + O(1) | O(2ⁿ) | 枚举所有子集 |

Master theorem 不适用时（如 T(n)=T(n−1)+O(n) 这种减 1 型），用**展开法/递归树**：
把 T(n) 一层层代入展开，数一共多少层、每层多少工作量，相加。
例：T(n)=T(n−1)+cn = cn + c(n−1) + … + c·1 = c·n(n+1)/2 = O(n²)。

**答分治大题的标准结构**（照这个顺序写）：
1. 一句话说思路（怎么 divide、怎么 combine）；
2. 伪代码；
3. 正确性一两句（如果题目要求）；
4. T(n) 递归式 + 每项来源；
5. 解递归式得出 running time。

---

## §3 Backtracking（回溯）

### 3.1 思想与模板

回溯 = **系统地扩展"部分解 (partial solution)"**：每步在当前部分解上尝试所有合法选择，发现不可能成功就**剪枝返回 (prune)**，试完一个选择要**撤销 (undo)** 再试下一个。本质是对解空间树做 DFS。

```text
Backtrack(P):                          // P 是当前部分解
  if P 已是完整解: 输出 P; return true      // 找一个解就停的版本
  for each 可以扩展 P 的候选选择 c:
      if 加入 c 后 P 仍可能通向完整解:      // 剪枝检查 (feasibility check)
          把 c 加入 P
          if Backtrack(P) == true: return true
          把 c 从 P 中移除                  // ★ 撤销，必写！
  return false                          // 所有选择都失败 → 回溯
```

要**所有解**：找到完整解时输出但不 return true，继续搜。
**与暴力枚举的区别**：exhaustive search 生成所有完整候选解再逐个检查；backtracking 在部分解阶段就提前剪掉不可能的分支。

### 3.2 两个必背例子

**① Subset Sum**（选/不选二叉树，正数输入时可剪枝）

```text
SubsetSum(i, sum, chosen):        // 前 i−1 个已决定，chosen 当前和为 sum
  if sum == target: 输出 chosen; return true
  if i > n or sum > target: return false      // 剪枝（元素均为正数）
  把 A[i] 加入 chosen
  if SubsetSum(i+1, sum + A[i], chosen): return true
  把 A[i] 移出 chosen                          // undo
  return SubsetSum(i+1, sum, chosen)           // 不选 A[i]

主调用: SubsetSum(1, 0, ∅)
```

**② N-Queens**（逐行放置，检查列和对角线）

```text
Queens(row):                       // col[1..row−1] 已放好
  if row > n: 输出 col[1..n]; return true
  for c = 1 to n:
      if Safe(row, c):             // 与已放皇后不同列、不同对角线
          col[row] = c
          if Queens(row + 1): return true
          col[row] = 0             // undo
  return false

Safe(row, c): for r = 1 to row−1:
    if col[r] == c or |col[r] − c| == row − r: return false
  return true
```

回溯最坏情况 running time 一般是指数级（如子集问题 O(2ⁿ)、排列问题 O(n!)），剪枝只是实际更快，最坏阶不变——选择题可能考这个。

---

## §4 BFS / DFS（最后一题）

图 G：n 个顶点 (vertices)、m 条边 (edges)，邻接表 (adjacency list) 存储。

**BFS（队列，按层扩展）** —— O(n + m)

```text
BFS(G, s):
  for each v in V: visited[v] = false
  Q = 空队列
  visited[s] = true; dist[s] = 0; enqueue(Q, s)
  while Q 非空:
      u = dequeue(Q)
      for each w adjacent to u:
          if not visited[w]:
              visited[w] = true
              dist[w] = dist[u] + 1     // 需要最短距离时
              parent[w] = u             // 需要还原路径时
              enqueue(Q, w)
```

**DFS（递归/栈，一条路走到底）** —— O(n + m)

```text
DFS(G, u):
  visited[u] = true
  for each w adjacent to u:
      if not visited[w]:
          parent[w] = u
          DFS(G, w)

// 遍历整个图（可能不连通）:
DFSAll(G): for each v in V: if not visited[v]: DFS(G, v)
```

**什么时候用哪个（判断题/最后一题的关键）：**

| 需求 | 用 |
|---|---|
| 无权图**最短路径 / 最少步数 / 层数** | **BFS**（只有 BFS 保证最短） |
| 只问**能否到达 / 是否连通 / 找任意一条路径** | BFS、DFS 都行（写 DFS 更短） |
| 连通分量个数 | 任一，外层套 DFSAll，数启动次数 |
| 检测环、拓扑类问题、走迷宫式穷举 | DFS |
| 状态空间"最少操作数"类问题（把状态当点、操作当边） | BFS |

**Running time：邻接表 O(n + m)；邻接矩阵 O(n²)** ——这是双变量选择题的高频考点。

### 4.1 BFS vs DFS 系统对比（第二批情报：原题就这么问的）

用 V = 顶点集（|V| = n）、E = 边集（|E| = m）表示：

| | **BFS** | **DFS** |
|---|---|---|
| 数据结构 | 队列 (queue) | 栈 (stack) / 递归 |
| 扩展方式 | 按层，距离起点由近到远 | 一条路走到底，走不动再回退 |
| Use case | **无权图最短路径**、最少步数/层数、二分图判定 | **环检测**、拓扑排序、连通分量、路径存在性、回溯式穷举搜索 |
| 最坏时间（邻接表） | **O(V + E)** | **O(V + E)** |
| 最坏时间（邻接矩阵) | O(V²) | O(V²) |
| 最坏空间（图本身除外） | **O(V)**：visited + 队列（宽而浅的图队列会很满） | **O(V)**：visited + 递归栈（深而窄的图栈会很深） |

### 4.2 Edge classification（tree / back / forward / cross）

对**有向图**做 DFS 时，每条边 (u, v) 按 v 的状态分成四类：

| 类型 | 定义 | 意义 |
|---|---|---|
| **Tree edge** | 沿它第一次发现 v（构成 DFS 树） | 搜索的"骨架" |
| **Back edge** | v 是 u 在 DFS 树中的**祖先**（含自环） | **存在 back edge ⟺ 图有环** |
| **Forward edge** | v 是 u 的**后代**，但不是 tree edge | 提前"抄近道"到已访问的后代 |
| **Cross edge** | 其余情况（两棵子树之间 / 无祖先后代关系） | |

必背结论：
- **无向图 DFS 只有 tree edge 和 back edge**（不存在 forward / cross）。
- **无向图 BFS 只有 tree edge 和 cross edge**，且 cross edge 两端层号差 ≤ 1。
- **有向图 BFS 没有 forward edge**（tree / back / cross 三种）。
- DFS 判环就是找 back edge；这也是"环检测用 DFS"的原因。

---

## §5 Dynamic Programming（据说较难的大题）

### 5.1 何时用 DP & 五步答题法

特征：问题能分解成**重叠**子问题（同一子问题被反复用到）+ 最优子结构（原问题最优解由子问题最优解构成）。分治子问题不重叠，DP 子问题重叠——这是两者的分界线。

考试答 DP 题按**五步**写，每步都是采分点：

1. **定义子问题/状态**：用文字精确说明表项含义，如 "dp[i][w] = 只用前 i 件物品、容量为 w 时能取得的最大价值"。
2. **递推式 (recurrence)**：写出 dp[…] 与更小表项的关系，并说明每种情况对应什么决策。
3. **Base case**。
4. **填表顺序**（保证算当前项时所依赖的项已算好）。
5. **最终答案在哪个表项** + **running time =表的大小 × 每项计算时间**。

### 5.2 三个必背例子

**① 0/1 Knapsack** —— O(n·W)（两个变量！）

```text
// dp[i][w] = 前 i 件物品、容量 w 下的最大总价值
for w = 0 to W: dp[0][w] = 0                  // base case: 没有物品
for i = 1 to n:
    for w = 0 to W:
        dp[i][w] = dp[i−1][w]                 // 不拿第 i 件
        if weight[i] <= w:
            dp[i][w] = max(dp[i][w], dp[i−1][w − weight[i]] + value[i])   // 拿
答案 = dp[n][W]
```

**② Longest Common Subsequence (LCS)** —— O(m·n)（两个变量！）

```text
// c[i][j] = X 前 i 个字符与 Y 前 j 个字符的 LCS 长度
c[0][j] = 0 for all j;  c[i][0] = 0 for all i
for i = 1 to m:
    for j = 1 to n:
        if X[i] == Y[j]: c[i][j] = c[i−1][j−1] + 1
        else:            c[i][j] = max(c[i−1][j], c[i][j−1])
答案 = c[m][n]
```

**③ Coin Change（最少硬币数）** —— O(n·A)

```text
// dp[a] = 凑出金额 a 所需最少硬币数（凑不出为 ∞）
dp[0] = 0;  dp[a] = ∞ for a = 1..A
for a = 1 to A:
    for each 面值 c with c <= a:
        dp[a] = min(dp[a], dp[a − c] + 1)
答案 = dp[A]
```

**④ Weighted Interval Scheduling（带权活动选择）** —— O(n log n)
（第二批情报显示考带权 activity selection 的正确解法，很可能就是这道"挺难的 DP"）

```text
把活动按结束时间排序: f1 <= f2 <= ... <= fn
p(i) = 最大的 j < i 使得 fj <= si（即 i 之前最后一个与 i 不重叠的活动；没有则 p(i)=0）
// dp[i] = 只考虑前 i 个活动能取得的最大总权重
dp[0] = 0
for i = 1 to n:
    dp[i] = max( dp[i−1],              // 不选活动 i
                 w[i] + dp[p(i)] )      // 选活动 i → 只能配 p(i) 之前的活动
答案 = dp[n]
```

排序 O(n log n)，每个 p(i) 二分查找 O(log n)，填表 O(n) → 总 **O(n log n)**。
为什么不能贪心：见 §11。

**应对"很难的 DP"**：难通常难在第 1 步。卡住时问自己——
- 处理到第 i 个元素时，还需要记住什么信息才能做后面的决策？那个信息就是第二维状态。
- 先写暴力递归，再找递归里重复出现的参数组合 → 参数就是状态，加表就是 DP（memoization 也算 DP）。
- 两个字符串/序列 → 八成是 dp[i][j]（各自的前缀）；带容量/预算 → dp[i][剩余容量]。

---

## §6 Randomized Algorithms：Las Vegas vs Monte Carlo（简答小问）

| | **Las Vegas** | **Monte Carlo** |
|---|---|---|
| 答案 | **永远正确** | **可能出错**（错误概率有上界） |
| 运行时间 | **随机**（分析期望 expected running time） | **确定**（固定上界） |
| 赌的是 | 时间 | 正确性 |
| 失败处理 | 可以"不出答案/重来"，但绝不给错答案 | 按时给答案，但可能是错的 |
| 降低风险 | 多跑几次总会出解 | **重复 k 次独立运行**，错误概率指数下降（如单边错误：p^k） |
| 经典例子 | **Randomized QuickSort**（随机选 pivot）、randomized selection | **Miller–Rabin 素性测试**、Freivalds 矩阵乘法验证、随机采样估 π |

**Randomized QuickSort（Las Vegas 的标准例子）**：pivot 均匀随机选，期望运行时间 **O(n log n)**，最坏 O(n²)，但无论随机数怎么样，输出永远是正确排序 → Las Vegas。

**判断题技巧**：看两件事——"输出会不会错？"和"时间是不是固定的？"
- 输出永不错、时间看运气 → Las Vegas。
- 时间固定、输出看运气 → Monte Carlo。
- 单边错误 (one-sided error)：如素性测试答"合数"必对、答"素数"可能错 → 重复可快速压低错误率。
- 相互转化：Las Vegas 跑到超时就强行输出 → 变 Monte Carlo；Monte Carlo 的答案若能快速**验证**，验证失败就重跑 → 变 Las Vegas。

---

## §7 Define a New Problem（要"加一个 bound"的定义题）

### 7.1 计算问题的标准定义格式

```text
Problem 名字
Input（或 Instance）: 输入是什么，含所有参数及其类型/约束
Output（或 Question）: 求什么 / 问什么（yes-no 问题就写成疑问句）
```

四种问题类型：

| 类型 | 问什么 | 例子 |
|---|---|---|
| **Decision** | 是/否 | "是否存在大小 ≤ k 的 …？" |
| **Search** | 找出一个满足条件的解 | "找出一个 …" |
| **Optimization** | 找最优（最大/最小）解 | "找出最小的 …" |
| **Counting** | 有多少个 | "有多少个 …" |

### 7.2 "加一个 bound"：optimization → decision

考点就是：给你一个 optimization problem，让你定义对应的 decision 版本。做法固定两步：

1. **Input 里加一个 bound**（整数 k 或目标值 B）；
2. **Output 改成 yes/no 问句**：最小化问题问 "是否存在 … 使得 (目标) ≤ k？"，最大化问题问 "是否存在 … 使得 (目标) ≥ k？"。

**例（最小化）：**

```text
Minimum Representative Set (optimization)
Input: 有限集 U；U 的子集组成的集族 S1, ..., Sm
Output: 最小的 R ⊆ U，使得对每个 i 都有 R ∩ Si ≠ ∅

Representative Set (decision)             // ← 加了 bound k
Input: 有限集 U；U 的子集 S1, ..., Sm；正整数 k
Question: 是否存在 R ⊆ U，|R| ≤ k，使得对每个 i 都有 R ∩ Si ≠ ∅？
```

**例（最大化）：**

```text
Knapsack (decision)
Input: n 件物品，第 i 件重 wi、价值 vi；容量 W；目标值 k
Question: 是否存在物品子集，总重 ≤ W 且总价值 ≥ k？
```

**定义题 checklist**：输入的每个符号都交代到；bound 放在 Input 里；问句只能用 Input 里出现过的东西；≤/≥ 方向别写反（最小化配 ≤ k，最大化配 ≥ k）；别把"怎么解"写进定义（定义只描述问题本身）。

---

## §8 认 Paradigm（给代码问范式）

**Paradigm（算法设计范式）** = 分治、贪心、动态规划、回溯、穷举、随机化这类**通用设计思想**的统称。题型：给一段（伪）代码，问用的哪种。**看结构特征，别看题目背景**：

| 代码里看到什么 | Paradigm |
|---|---|
| 生成**所有**候选解（所有子集/排列/组合），逐个完整检查，不剪枝 | **Exhaustive search / brute force** |
| 递归扩展**部分解**；有"不行就 return"的剪枝；试完一个选择**撤销**再试下一个 | **Backtracking** |
| 把输入**切成不相交的块**分别递归（常见 2 次对半），再**合并**结果 | **Divide and conquer** |
| 单次遍历，每步按某个规则做**当前最优**选择，**从不反悔** | **Greedy** |
| **填表**：数组/二维表按顺序填，每项由**已算过的表项**算出；或递归 + **memo** 缓存 | **Dynamic programming** |
| 调用 `random()` / "随机选一个" | **Randomized**（再判断 LV / MC，见 §6） |
| 队列 + visited | **BFS** |
| 栈或递归 + visited，遍历图 | **DFS** |

**易混淆对：**
- 分治 vs DP：都递归。子问题**不重叠** → 分治；子问题**重叠**（或出现表/memo） → DP。
- 回溯 vs 穷举：都搜全空间。**部分解 + 剪枝 + undo** → 回溯；生成完整候选再检查 → 穷举。
- 贪心 vs DP：贪心每步只留**一个**选择不回头；DP 把**所有**选择的结果都算出来取最优。
- 贪心 vs 回溯：贪心不撤销；有撤销必是回溯。

---

## §9 双变量 Running Time（选择题："有 m 和 n 的情况"）

输入规模有**两个独立参数**（如图的 n 个点 m 条边、两个长度 m 和 n 的字符串）时，复杂度必须**同时用两个变量**表达，不能混成一个。

**必背结论：**

| 场景 | Running time |
|---|---|
| BFS / DFS，邻接表 | **O(n + m)** |
| BFS / DFS，邻接矩阵 | **O(n²)** |
| 双层嵌套 `for i=1..n { for j=1..m }` | O(n·m) |
| 两个**并列**的循环 `for i=1..n; for j=1..m` | O(n + m) |
| 合并两个长 m、n 的有序数组 | O(m + n) |
| LCS / edit distance（串长 m, n） | O(m·n) |
| 0/1 Knapsack（n 件物品，容量 W） | O(n·W)（注意 W 是数值不是个数 → pseudo-polynomial） |
| 循环变量每次翻倍/减半 | O(log n)；外面套 n 层 → O(n log n) |

**做题规则：**
1. 每层循环单独数次数，**嵌套相乘、并列相加**。
2. "for each edge" 整体在整个遍历中总共执行 **m** 次（配合邻接表），不是每个点 m 次——所以是 O(n + m) 而不是 O(n·m)。
3. m 和 n 没有固定大小关系时，O(n + m) 和 O(n·m) **不能互相化简**，也不能把 O(n + m) 写成 O(n)。
4. 选项里出现 O(n + m) 与 O(n·m) 之分时，问自己：内层工作量是"每个点把**自己的**邻居过一遍（总和 = 2m）"还是"每个点把**所有**边过一遍（n·m）"。
5. 稠密图 m 可达 Θ(n²)，稀疏图 m = Θ(n)——有的选项用这个考你代入。

---

## §10 Representative Set 专题（assignment 原题）

> ⚠️ 这是 assignment 3 或 4 的**原题**。第一要务是把你自己的作业翻出来，按当时的题面重做一遍并核对答案。
> 本仓库里只有 CS 115 的文件，没有 CS231 的作业。下面是这类问题的标准形式，供理解框架用；以你作业的题面为准。

**标准定义**（"每个集合都要有代表"，即 hitting set 型）见 §7.2 的定义示例。

**Brute force**：枚举 U 的所有子集 R（共 2^|U|个），检查是否命中每个 Si —— O(2^|U| · m·|U|)。

**Backtracking 解法**（同时是 §3 模板的绝佳套用——考试若考"写 backtracking 伪代码"，这类题可直接用）：

```text
// 依次保证 S1, ..., Sm 都有代表；R 是当前已选代表集，k 是 bound
RepSet(i, R):
  if |R| > k: return false                 // 剪枝：超出 bound
  if i > m: 输出 R; return true            // 所有集合都已有代表
  if R ∩ Si ≠ ∅: return RepSet(i+1, R)     // Si 已被现有代表覆盖
  for each x in Si:                        // 否则给 Si 挑一个代表
      把 x 加入 R
      if RepSet(i+1, R): return true
      把 x 从 R 移除                        // undo
  return false

主调用: RepSet(1, ∅)
```

**变体：System of Distinct Representatives (SDR)** ——每个 Si 出一个代表 xi ∈ Si，且代表**两两不同**（|R| = m）。回溯解法同上，只是选代表时要求 `x not in R`，且不需要 bound k。你作业里的题面若是"distinct"版，用这个。

---

## §11 Greedy & Correctness Proof（第二批情报确认要考）

### 11.1 Greedy 范式

每一步按一个固定规则做**当前看起来最优**的选择，选完**从不反悔**。写起来最短，但**正确性从不显然**——考试专门考"贪心为什么对/为什么错"。

### 11.2 经典 Activity Selection（无权版）—— greedy 正确

n 个活动，活动 i 占用时间区间 [sᵢ, fᵢ)，选**互不重叠**的活动，使**个数**最多。

```text
ActivitySelect(activities):
  按结束时间从早到晚排序: f1 <= f2 <= ... <= fn
  chosen = ∅; last = −∞          // last = 已选活动中最晚的结束时间
  for i = 1 to n:
      if si >= last:              // 与已选的都不冲突
          把活动 i 加入 chosen; last = fi
  return chosen                   // O(n log n)（排序占主导）
```

### 11.3 Greedy choice property 的完整证明（exchange argument，背下来）

**Claim：存在一个最优解包含最早结束的活动 a₁。**

证明（交换论证）：设 OPT 是任意一个最优解。
1. 若 a₁ ∈ OPT，得证。
2. 否则，设 b 是 OPT 中**结束最早**的活动。由于 a₁ 是全部活动中结束最早的，有 **f(a₁) ≤ f(b)**。
3. OPT 中除 b 以外的活动与 b 互不重叠，故它们的开始时间都 ≥ f(b) ≥ f(a₁)，因此把 b 换成 a₁ 不会与它们中任何一个冲突。
4. 于是 OPT′ = (OPT \ {b}) ∪ {a₁} 仍是可行解，且 |OPT′| = |OPT|，所以 OPT′ 也是最优解，并且包含 a₁。∎

**归纳收尾**：选下 a₁ 后，剩下的问题是"在开始时间 ≥ f(a₁) 的活动中选最多互不重叠的活动"——同一问题的更小实例。对它重复上述论证（归纳），可得贪心算法产生的整个解是最优的。

写这类证明的模板：**任取最优解 → 若不含贪心选择，把它里面"对应位置"的元素换成贪心选择 → 论证换完仍可行、目标值不变差 → 得到含贪心选择的最优解 → 归纳到子问题。**

### 11.4 Weighted 版本：greedy 失效（要会举反例）

活动带权重 wᵢ > 0，目标改为**总权重**最大。"earliest finish time" 贪心失效：

> **反例**：X = [1, 2)，w = 1；Y = [0, 10)，w = 100。两者重叠。
> EFT 先选结束更早的 X，Y 因冲突被丢弃 → 总权重 1；最优解是只选 Y → 总权重 100。

失效原因：EFT 完全不看权重，一个小权重的早结束活动会挤掉与它重叠的大权重活动——greedy choice property 不再成立（不存在包含 X 的最优解）。

**带权版本的正确解法：weighted interval scheduling DP**（§5 例④：`dp[i] = max(dp[i−1], w[i] + dp[p(i)])`）。
一句话总结（考试爱考）："无权 → greedy（EFT）；带权 → DP。"

---

## §12 考前最后过一遍（checklist）

- [ ] 分治模板 + binary search / merge sort 伪代码能默写
- [ ] 会从伪代码写 T(n)，§2.3 速查表能背出，Master theorem 三种情况会用
- [ ] 回溯模板（含 undo）+ subset sum / N-queens 能默写
- [ ] representative set 作业原题重做过了 ✔
- [ ] Problem 定义格式：Input/Output；optimization → decision 加 bound k，≤/≥ 方向正确
- [ ] DP 五步法 + knapsack、LCS、weighted interval scheduling 的状态定义和递推式
- [ ] Greedy：activity selection 的 exchange argument 证明能默写；带权反例能现场举
- [ ] Las Vegas vs Monte Carlo 表格能复述，各记一个例子
- [ ] §8 认范式速查表过一遍，做过 practice.md 的认代码题
- [ ] O(n+m) vs O(nm) 的判断规则清楚，邻接表 vs 邻接矩阵
- [ ] BFS / DFS 伪代码能默写；"最短/最少 → BFS"；§4.1 对比表 + §4.2 edge classification 能复述
