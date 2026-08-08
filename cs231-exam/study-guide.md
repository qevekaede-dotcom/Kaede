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

### 2.4 本课程的实际考法（从 a2-W3/W4/W5 总结，重点！）

**① 伪代码格式**：课程模板是 INPUT/OUTPUT 说明 + 编号行，树操作用 IS_LEAF / CHILDREN / EDGE_WEIGHT / TREE_ROOT 这类原语。例（a2-W3 官方解，树上分治求子树边权和）：

```text
TOTAL(Tree, Node)
INPUT:  A tree Tree and a node ID Node
OUTPUT: The sum of the weights of all edges in the subtree rooted at Node
1  Sum ← 0
2  if IS_LEAF(Tree, Node)
3      return Sum
4  else
5      for each Child in CHILDREN(Tree, Node)
6          Sum ← Sum + EDGE_WEIGHT(Tree, Child)
7          Sum ← Sum + TOTAL(Tree, Child)
8      return Sum
```

**② "从伪代码写 recurrence"的标准答法**（a2-W4：给一段 MYSTERY 伪代码）：
- **base case 单独一问**：指出对应哪几行（如 "Lines 1–2 / 1–4，只有常数次比较、取元素 → T(1) ∈ Θ(1)"）。
- **general case**：对每个返回分支分别累计——哪几行是 **divide**（算分割点，Θ(1)），哪几行是 **conquer**（递归调用，每个写成 T(子问题规模)），哪几行是 **combine**（合并结果）；最后**取最贵的分支**作 worst case。
- 子问题规模可以不均匀！例：T(n) = 2T(⌈n/5⌉) + T(⌈2n/5⌉) + Θ(1)。
- 注意题目可能说 "You are not required to solve the recurrence" ——那就**只写不解**；问了才解。

**③ Substitution method（代入法，a2-W5 考过）**：证 T(n) ∈ O(n log² n) 这类界：
1. 猜一个**显式**上界（如 T(n) ≤ c·n log² n）；
2. 归纳：把猜想代入递归式右边，用单调性去掉 floor/ceiling，整理出 (…)·n log² n 的形式；
3. 解出让不等式成立的 c（如 c ≥ 16），**回头验证 base cases**（n=2, 3）也满足；
4. 结论：T(n) ≤ 16 n log² n → T(n) ∈ O(n log² n)。

**④ Master method 陷阱**（练习卷 MC7）：先**化简子问题规模**再判断——3T(⌊n/5⌋) + T(⌈2n/10⌉) 里 2n/10 = n/5，其实是 4T(n/5)，可以用 Master method。

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

**Bounding function（练习卷 MC3 考点）**：
- maximization 问题：bounding function 给出当前部分解一切扩展的**上界**；上界 ≤ 目前最优 → 剪枝。
- **minimization 问题：给出的是"下界 (lower bound)"**；下界 ≥ 目前最优 → 剪枝。（选择题把方向写反来骗你。）
- 其他判断题事实：探索重复部分解**会**拖慢运行时间；backtracking **不**要求输入含树；backtracking **不保证**比 exhaustive search 快。

**搜索树设计影响 FPT 性质**（2025-a4-W2，配 §13）：找大小为 k 的 cluster——
- 树 A：每层把"与当前集合全相邻的任意顶点"作孩子 → 每层分支 Θ(n)，k 层 → **n^k 个节点，不是 f(k)·n^O(1)**；但每个大小 k 的候选都会被探索 → **正确**。
- 树 B：把顶点排序，每层对"下一个顶点"做选/不选 → 2^k 个节点 → **是 f(k)·n^O(1)**；但只考虑了前 k+1 个顶点，可能漏解 → **不正确**。
- 教训：时间和正确性要**分开回答**。

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

### 5.3 本课程 DP 的实际考法（⭐ a3-W1 + 练习卷 L1/MC6 都是这一类）

给一个**抽象递推式**（如 A(i,j)、N(i,j)、M(i,j)），不要你发明状态，而是考"表"本身：

1. **手算某个具体值**（show your work：把依赖的项一路算出来）。
2. **Base cases 是哪些、值是多少**（找定义里不递归的分支）。
3. **最小的表是什么形状/大小**：把依赖箭头追出来——
   - 只依赖 (i−1,j−1) 的对角链 → 只需 **1D 对角线表**（练习卷 L1：N(n,n) 只要 n+1 项）；
   - 依赖上方+左方且 i ≤ j / j ≤ i → **三角形表**（a3-W1：n×n 的上三角；L1 的 N(n,n−1)：下三角 (n+1)×n）。
4. **填表顺序**（MC6 类）：依赖左方 → 行内必须从左到右；依赖上方 → 行间从上到下；
   "行内任意顺序"只有在**不依赖同行项**时才合法。画箭头逐项检查每个选项。
5. **运行时间 = 表项数 × 每项时间**（a3-W1：Θ(n²) 项 × Θ(1) = Θ(n²)）。

另外记一个**真题级双变量 DP**（a3-P1，STRING EDITING，带三种代价）：
C[i][j] = 把 S 前 i 个字符编辑成 T 前 j 个字符的最小代价；
S[i]=T[j] 时 C[i][j] = C[i−1][j−1]；否则 = min(C[i−1][j−1]+c_s, C[i−1][j]+c_d, C[i][j−1]+c_a)；
第一行 j·c_a、第一列 i·c_d；答案 C[|S|][|T|]，**O(|S|·|T|)——标准 O(mn) 双变量表**。

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

**本课程口径（按这个答题）**：
- Las Vegas：**保证正确** + **期望**运行时间多项式。
- Monte Carlo：**最坏**运行时间多项式 + **高概率正确**（课程题目里用过"> 3/4"作阈值）。
- **LV → MC 标准答案**（练习卷 L4b 原文思路）：给 LV 设一个多项式时间上限，到点没跑完就**强制停止、随便返回一个答案**——时间有保证了，正确性变成高概率。
- **两头都不沾的例子**（2025-a4-W4）：对 representative sets 每个集合抛硬币决定选不选——可能出错（不是 LV），正确概率也不到 3/4（按课程定义也不算 MC）。判断题要敢于回答"都不是"。
- "P 里的问题也值得用随机化吗？"——值得：可能**更简单、更快**（前提是你不需要双保证）。

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

### 7.3 本课程的两个扩展考法（练习卷已考）

**① 加 bound 也可以造 enumeration problem**（L3c）：不问"是否存在"，而是**输出全部达标解**：
```text
EXPENSIVE_PATH_ENUMERATION
Input:  A tree T with a positive weight on each edge, and a bound B
Output: ALL paths from the root to a leaf node with weight at least B
```
看清题目要 decision 还是 enumeration —— Output 一行完全不同。

**② constructive vs evaluation optimization**（L4a）：
- constructive 版：求**最优解本身**；evaluation 版：只求**最优值**。
- 归约方向：**evaluation ≤ constructive 容易**（拿到最优解算个值就行）；
  反方向难（只有值，要重构解，需要反复调用做自归约）。

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

## §10 Representative Sets 专题（⭐ 原题已确认：assignment 3 W3）

> ✅ 已根据你上传的作业 PDF 确认。**真实定义**（和"hitting set"猜测不同，以此为准）：

### 10.1 问题定义（背下来）

```text
REPRESENTATIVE SETS（optimization 版，Assignment 2 定义）
Input:  一个"集合的集合" 𝒜（每个成员是一个数字集合）
Output: 最小的子集 ℬ ⊆ 𝒜，使得 ℬ 中所有集合的并 = 𝒜 中所有集合的并（记作 𝒰）

REPRESENTATIVE SETS DECISION（a3-W3 原题版）
Input:  集合的集合 𝒜；正整数 k
Output: Yes/No —— 是否存在 ℬ ⊆ 𝒜，使得 ∪ℬ = 𝒰 且 |ℬ| ≤ k？
```

直觉：从一堆集合里挑**尽量少的几个**，就能"代表"全部（并集不缩水）。（= set cover 类型。）

### 10.2 原题：用四步 recipe 证明 REPRESENTATIVE SETS DECISION ∈ NP（8 分）

**Step 1 — certificate + 多项式大小**：certificate = 𝒜 的一个子集 ℬ。大小 ≤ |𝒜|，线性 → 多项式 ✓。

**Step 2 — 多项式验证算法**：
1. 检查 certificate 是 𝒜 中互不相同的集合组成的；数到第 k+1 个就立刻回 No（保证 |ℬ| ≤ k）；
2. 计算 ∪ℬ 和 𝒰 = ∪𝒜，比较是否相等；相等回 Yes，否则 No。
运行时间：求并/比较都与集合总大小成多项式 ✓。

**Step 3 — yes-instance 必被接受**：若答案是 Yes，则存在合法的 ℬ；以它作 certificate，大小检查和并集检查都通过 → 回 Yes ✓。

**Step 4 — no-instance 不被假 certificate 骗**：若不存在合法 ℬ，则任何 certificate 至少违反其一：
① 不是由 𝒜 中集合组成；② 个数 > k；③ 有 𝒰 中元素没被覆盖。验证算法逐条检查 → 必回 No ✓。

### 10.3 同一问题的其他考法（2025 年 assignment 4 出过，都可能上考卷）

**Hill climbing 解法**（W3-2025）：初始解 = 整个 𝒜；每步**删掉一个"不需要的"集合**（删掉后并集仍 = 𝒰）。
每步解变小 → 是 hill climbing。
- 保证最优的输入例：𝒜 = {{1,2},{3,4},{5,6},{7,8}}（元素两两不同，唯一解就是 𝒜 本身，初始即最优）。
- **不**保证最优的输入例：𝒜 = {{1,2},{3,4},{5,6},{7,8},{1,2,3,4},{5,6,7,8}}——最优是两个大集合；
  但如果第一步删掉了 {1,2,3,4}，之后再也回不到最优（hill climbing 不回头）。

**随机化解法判断**（W4-2025）：对每个集合抛硬币（1/2 概率放进 ℬ）：
- 是 Las Vegas 吗？**不是**——它可能给错答案（LV 要求永远正确）。
- 是 Monte Carlo 吗？运行时间多项式 ✓，但正确概率不超过课程定义的"高概率"（> 3/4）→ **也不算**（按课程定义）。
- 对 P 里的问题用随机化有意义吗？**有**——可能更简单/更快（如果你不需要时间或正确性的双保证）。

### 10.4 如果考"写 backtracking/exhaustive 伪代码解它"

按 §3 模板：按顺序对 𝒜 中每个集合做"选/不选"二叉决策树；部分解 = 已决定的前缀；
剪枝：已选个数 > k → 剪掉；到底时检查 ∪ℬ = 𝒰。（exhaustive 版就是枚举 𝒜 的全部 2^|𝒜| 个子集逐一检查。）

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

## §12 NP、归约与复杂度类（⭐ 第二大重点，练习卷和 a3 都重考）

### 12.1 NP membership proof —— 四步 recipe（必背，原题就考这个）

> **Step 1**：给出 yes-instance 的 **certificate**，说明大小是多项式的。
> **Step 2**：给出 **verification algorithm**，说明最坏运行时间是多项式的。
> **Step 3**：说明对任何 yes-instance 及其正确 certificate，算法回答 Yes。
> **Step 4**：说明算法**不会被 no-instance 的假 certificate 骗出 Yes**（逐条列出假 certificate 可能违反的检查）。

完整示例两个：SUDOKU（`final-practice-walkthrough.md` L6）、REPRESENTATIVE SETS DECISION（§10.2，a3 原题）。

### 12.2 NP-completeness 归约 —— recipe（a3-W4：用 CLIQUE 证 CLUSTER DECISION）

证 Z 是 NP-complete 的完整流程：
1. 证 Z ∈ NP（用 12.1 的四步；题目可能说"已完成"）；
2. 选一个已知 NP-complete 的问题 Y（如 CLIQUE）；
3. **给出把 Y 的任意 instance 映射为 Z 的 instance 的算法 f**（不需要映满 Z）；
4. 证：x 是 Y 的 yes-instance ⟹ f(x) 是 Z 的 yes-instance；
5. 证：f(x) 是 Z 的 yes-instance ⟹ x 是 Y 的 yes-instance；
6. 证 f 的运行时间是多项式的。

a3-W4 的映射（感受一下 f 长什么样）：CLIQUE 的 (G, k) ↦ CLUSTER DECISION 的 (G_C, k_C, B_C)：
G_C = 给 G 每条边权重 1；k_C = k；B_C = C(k,2) = k(k−1)/2（大小 k 的 clique 恰有这么多条边）。

### 12.3 类与事实（选择题弹药库）

| 类 | 一句话 |
|---|---|
| **P** | 多项式时间可解 |
| **NP** | 解可以在多项式时间**验证**（yes-instance 有多项式 certificate） |
| **NP-hard** | NP 中所有问题都可归约到它（本身可以不在 NP） |
| **NP-complete** | NP-hard **且** ∈ NP |
| **RP / BPP** | 多项式时间随机算法可解（单边 / 双边有界错误） |
| **PTAS / APX** | 有任意精度多项式近似方案 / 有常数比近似算法 |
| **FPT** | 有 f(k)·n^O(1) 算法（k 是 parameter，见 §13.3） |

判断题事实（练习卷 MC4/MC5 官方答案）：
- A NP-hard、B NP-complete ⟹ **B ≤ A**（NP 里的都能归约到 NP-hard）且 **B ∈ NP**；A 不一定 ∈ NP、A 不一定 ≤ B。
- **若 P = NP**：P = RP、P = BPP、PTAS = APX、NC = P **全部成立**（官方答案全选，直接记）。

---

## §13 启发式、近似比、FPT、adversary 下界（新增考点）

### 13.1 Hill climbing（爬山法）

- 定义：从某个初始解出发，每步移动到**更好的邻居解**，无法改进就停。
- 关键性质（MC8）：只保证 **local optimum**，**不保证 global**——这是判断题高频点。
- 会描述一个具体方案：初始解是什么 + 每步怎么改 + 为什么算 hill climbing（每步都在改进目标）。
  模板见 §10.3 representative sets 的例子（初始 = 全部 𝒜，每步删一个多余集合）。
- 会构造两类输入：让它**保证最优**的 / 让它**卡在局部最优**的（§10.3 两个例子背下来）。

### 13.2 Approximation ratio（近似比，2025-a4-W1）

- 定义：近似算法输出值与最优值之比（取 ≥ 1 的方向）。
- 会算具体图上的比值：complete graph 上 greedy cluster → 输出=最优 → **ratio 1**；树上 → 最优本身就是 2 → **ratio 1**。
- 会构造"比值不是常数"的**图族**：给出随 n 增长的构造 + 算出 ratio ∈ Θ(√n) 这类结论。
  （套路：造一个"诱饵"结构骗贪心拿小解，同时藏一个大最优解；让两者比值随规模增长。）

### 13.3 FPT（fixed-parameter tractable）

- 判据：运行时间能写成 **f(k) · n^O(1)**——f 只依赖参数 k（可以是 14^(k²) 这种怪物），n 的指数必须是**不含 k 的常数**。
- ✓ 例：O(14^(k²) · n³ · log₇(log₃(k⁵!)) · ∛(n^101))（MC10，n 部分 = n^(3+101/3)，指数常数）。
- ✗ 例：O(n^k)（指数里有 k，不行）——对应 §3 搜索树 A；搜索树 B 的 2^k·poly(n) 才是 FPT。

### 13.4 Adversary 下界（a3-W2，可能小问出现）

证明"任何算法至少要问 ℓ 次"的套路（以 MAXIMUM SIZE CLUSTER、只能问"u,v 相邻吗"为例）：
1. **给 adversary 策略**：对所有提问都答 "no"（或都答 "yes"）——adversary 可以记住一切，但不知道算法下一步。
2. **证明下界 ℓ = C(n,2) = n(n−1)/2**：若算法只问了 ℓ−1 个 pair 就作答，至少有一对 (u,v) 没问过——
   - 算法答 1（no 策略下）：adversary 把没问过的那条边**补上**，真实最大 cluster 变成 2 → 算法错；
   - 算法答 > 1：adversary **不加**那条边，最大 cluster 是 1 → 还是错。
   两种情况都能骗到只问 ℓ−1 次的算法 ⟹ 必须问满 ℓ 次。∎
- 要点：下界要**精确**（题目要求 do not use order notation，写 n(n−1)/2 不写 Θ(n²)）。

---

## §14 考前最后过一遍（checklist）

- [ ] 分治：模板 + TOTAL（树上分治）/ merge sort 能默写；课程伪代码格式（INPUT/OUTPUT+编号行）
- [ ] 会从伪代码**按行**写 T(n)（base case 一问 + general case 一问，divide/conquer/combine 各对应哪几行）
- [ ] §2.3 递归式速查表 + Master method（先化简 2n/10 = n/5 这种）+ substitution method 四步
- [ ] 回溯模板（含 undo）+ bounding function 方向（min 问题 → lower bound）+ 搜索树 FPT/正确性分开判断
- [ ] **Representative Sets：定义 + NP 四步证明（§10.2 原题）能默写** ✔
- [ ] NP 四步 recipe + 归约六步 recipe；NP-hard/complete 判断题事实；P=NP ⟹ 全塌缩（MC 全选）
- [ ] Problem 定义：decision（加 bound k）/ enumeration（输出全部 ≥ B 的解）/ constructive vs evaluation
- [ ] DP：五步法 + 表格题套路（手算、base case、表形状、填表顺序、表大小×每项时间）+ string editing / knapsack / LCS / weighted interval scheduling
- [ ] Greedy：exchange argument 证明 + 带权反例 + EXPENSIVE_PATH 贪心失效反例（树）
- [ ] LV vs MC 定义（课程口径）+ LV→MC 转化标准答案 + "两头都不是"的例子
- [ ] Hill climbing：local vs global + 两类输入构造；approximation ratio 会算会构造；FPT 判据 f(k)·n^O(1)
- [ ] Adversary 下界：策略 + 两分支反驳论证，答案写精确值不写 Θ
- [ ] §8 认范式速查表过一遍；O(n+m) vs O(nm)；BFS/DFS 对比 + edge classification
- [ ] `final-practice-walkthrough.md` 官方练习卷 10 道 MC 全部能独立说出答案和理由
