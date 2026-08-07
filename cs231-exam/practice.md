# CS 231 仿真练习卷（按考试情报结构出题，附参考答案）

用法：先盖住答案自己写（尤其是伪代码题，朋友原话："具体写伪代码的，你得找 example 练"），写完再对照。
题号顺序对应 README 里拼出的考试结构。

---

## Q1 Divide and Conquer 大题（含 recurrence 小问）

给定整数数组 A[1..n]（可能有负数），求**最大子段和**：找一段连续子数组，使其元素之和最大，返回该和。

(a) 用一两句话描述你的 divide and conquer 思路。
(b) 写出伪代码。
(c) 写出 running time 的 recurrence relation T(n)，说明每一项从哪来。
(d) 解出 T(n)。

<details><summary>参考答案</summary>

**(a)** 从中点把数组分成左右两半：最大子段要么完全在左半（递归），要么完全在右半（递归），要么**跨过中点**——跨中点的情形可以在 O(n) 内直接算（从中点向左取最大后缀和、向右取最大前缀和，相加）。三者取最大。

**(b)**

```text
MaxSub(A[lo..hi]):
  if lo == hi: return A[lo]                       // base case
  mid = floor((lo + hi) / 2)
  best = max(MaxSub(A[lo..mid]), MaxSub(A[mid+1..hi]))   // 两侧递归
  // 跨中点：中点向左的最大和 + 中点右侧向右的最大和
  leftBest = −∞; s = 0
  for i = mid downto lo:  s = s + A[i]; leftBest = max(leftBest, s)
  rightBest = −∞; s = 0
  for i = mid+1 to hi:    s = s + A[i]; rightBest = max(rightBest, s)
  return max(best, leftBest + rightBest)

主调用: MaxSub(A[1..n])
```

**(c)** 每层递归调用自身 **2** 次，子问题规模各为 **n/2**；除递归外，跨中点扫描两个 for 循环共 O(n)。所以

> T(n) = 2T(n/2) + O(n)，T(1) = O(1)

**(d)** 套 Master theorem：a=2, b=2, d=1，log₂2 = 1 = d → 第二种情况 → **T(n) = O(n log n)**。（和 merge sort 同款递归式。）

</details>

---

## Q2 选择题：双变量 Running Time

每题选出最紧的界。

**2.1**
```text
for i = 1 to n:
    for j = 1 to m:
        print(i, j)
```
A. O(n+m)  B. O(n·m)  C. O(n²)  D. O(n log m)

**2.2**
```text
for i = 1 to n: x = x + 1
for j = 1 to m: y = y + 1
```
A. O(n+m)  B. O(n·m)  C. O(max(n,m)²)  D. O(n)

**2.3** 图 G 有 n 个顶点、m 条边，用**邻接表**存储，对 G 跑 BFS：
A. O(n·m)  B. O(n²)  C. O(n+m)  D. O(m log n)

**2.4** 填一张 (m+1)×(n+1) 的 DP 表，每个格子 O(1) 算出：
A. O(m+n)  B. O(m·n)  C. O(m·n²)  D. O(max(m,n))

**2.5**
```text
for i = 1 to n:
    j = 1
    while j <= m:
        j = 2 * j
```
A. O(n+m)  B. O(n·m)  C. O(n·log m)  D. O(log(n·m))

**2.6** 同 2.3 的图改用**邻接矩阵**存储跑 BFS：
A. O(n+m)  B. O(n²)  C. O(n·m)  D. O(m²)

<details><summary>答案</summary>

**2.1 B**（嵌套相乘：n·m 次打印）。
**2.2 A**（并列相加；注意 m、n 无大小关系，不能化简成 O(n)）。
**2.3 C**（每个点出队一次 O(n)，每条边沿邻接表被看常数次，总计 O(n+m)）。
**2.4 B**（表大小 × 每格用时 = (m+1)(n+1)·O(1)）。
**2.5 C**（内层 j 翻倍，log m 次；外层 n 次）。
**2.6 B**（每个出队的点要扫整行 n 个格子 → n·n）。

</details>

---

## Q3 简答：Randomized Algorithms

**3.1** Randomized QuickSort 随机选 pivot。它是 Las Vegas 还是 Monte Carlo？为什么？

**3.2** 某算法固定运行 100n 步后必定输出一个 yes/no 答案，答案错误的概率 ≤ 1/3。它是哪一类？如何把错误概率压到很小？

**3.3** 某检测算法：输出 "NO" 时一定正确；输出 "YES" 时可能出错，出错概率 ≤ 1/2（单边错误）。独立重复 k 次，怎样合并答案？合并后错误概率是多少？

<details><summary>答案</summary>

**3.1 Las Vegas。** 无论随机数取什么，输出永远是正确排序（正确性 100%）；随机的只是运行时间——期望 O(n log n)，最坏 O(n²)。"赌时间不赌答案" → Las Vegas。

**3.2 Monte Carlo**（时间确定、答案可能错）。独立重复 k 次取**多数票**（majority），错误概率随 k 指数下降。

**3.3** 只要有一次输出 "NO" 就答 "NO"（因为 "NO" 必对）；k 次全是 "YES" 才答 "YES"。答错只发生在真实答案为 "NO" 却连续 k 次都误报 "YES"，概率 ≤ **(1/2)^k**。

</details>

---

## Q4 认 Paradigm：下列每段代码用的是哪种算法设计范式？

**(a)**
```text
F[0] = 0; F[1] = 1
for i = 2 to n:
    F[i] = F[i−1] + F[i−2]
return F[n]
```

**(b)**
```text
Place(i, P):
  if i > n: 输出 P; return true
  for each c in 候选选择:
      if OK(P, c):                 // 检查加入 c 是否仍合法
          把 c 接到 P 末尾
          if Place(i+1, P): return true
          把 c 从 P 末尾移除
  return false
```

**(c)**
```text
把所有活动按结束时间从早到晚排序
count = 0; last = −∞
for each 活动 (s, f) 按此顺序:
    if s >= last: count = count + 1; last = f
return count
```

**(d)**
```text
F(A[lo..hi]):
  if lo == hi: return A[lo]
  mid = floor((lo+hi)/2)
  return max(F(A[lo..mid]), F(A[mid+1..hi]))
```

**(e)**
```text
best = 0
for each S ⊆ {1, ..., n}:          // 枚举全部 2^n 个子集
    if valid(S) and |S| > best: best = |S|
return best
```

<details><summary>答案</summary>

**(a) Dynamic programming**（自底向上填表，每项用已算好的表项）。
**(b) Backtracking**（部分解 P + 合法性剪枝 OK(…) + 撤销）。
**(c) Greedy**（排序后单遍扫描，每步取当前最早结束的可行活动，从不反悔——经典 activity selection）。
**(d) Divide and conquer**（对半分、两侧递归、max 合并；子问题不重叠）。
**(e) Exhaustive search / brute force**（生成所有完整候选解逐个检查，无剪枝）。

</details>

---

## Q5 Backtracking 大题

给定无向图 G（顶点 1..n）和颜色数 c。判断能否给每个顶点涂一种颜色，使**相邻顶点颜色不同**；能则输出一种涂法。写出 backtracking 伪代码。

<details><summary>参考答案</summary>

```text
// colour[1..n] 初始全为 0（0 表示未涂色）；按顶点编号顺序逐个涂
Color(v):
  if v > n: 输出 colour[1..n]; return true      // 全部涂完
  for col = 1 to c:
      if 对每个与 v 相邻且已涂色的顶点 u 都有 colour[u] ≠ col:   // 剪枝检查
          colour[v] = col
          if Color(v + 1): return true
          colour[v] = 0                          // undo
  return false                                   // c 种颜色都不行 → 回溯

主调用: Color(1)；返回 false 说明无解
```

要点采分：base case（v > n）、合法性检查、undo、最外层返回 false。最坏情况 O(cⁿ) 级别（每个点 c 种选择）。

</details>

---

## Q6 Representative Set（对应 assignment 原题）

集族 S₁, ..., Sₘ 是有限集 U 的子集（比如：每个社团报一份成员名单，要选一个小委员会，使**每个社团至少有一名成员入选**）。

(a) 写出该问题 optimization 版本的正式定义。
(b) 写出对应的 decision 版本（提示：加一个 bound）。
(c) 给出一个 brute force 解法思路并给出其 running time。
(d) 写出 decision 版本的 backtracking 伪代码。

<details><summary>参考答案</summary>

**(a)**
```text
Minimum Representative Set
Input: 有限集 U；U 的子集 S1, ..., Sm
Output: 大小最小的 R ⊆ U，使得对每个 i (1 ≤ i ≤ m) 都有 R ∩ Si ≠ ∅
```

**(b)** Input 里**加一个正整数 k（bound）**，输出改为 yes/no 问句：
```text
Representative Set (decision)
Input: 有限集 U；U 的子集 S1, ..., Sm；正整数 k
Question: 是否存在 R ⊆ U，|R| ≤ k，使得对每个 i 都有 R ∩ Si ≠ ∅？
```

**(c)** 枚举 U 的所有 2^|U| 个子集 R；对每个 R 检查 |R| ≤ k 且逐一验证 m 个集合都与 R 相交（每次检查 O(m·|U|)）。总计 **O(2^|U| · m · |U|)**。

**(d)** 见 `study-guide.md` §10 的 `RepSet(i, R)`：按 S₁…Sₘ 顺序处理；当前集合已被 R 命中就跳过，否则枚举其元素作代表；|R| 超过 k 立即剪枝；试完撤销。

⚠️ 再提醒：考试考的是你 **assignment 3/4 的原题**，务必把作业原文翻出来重做（题面可能是 distinct representatives 变体：每个集合出一个代表且代表两两不同——伪代码只需把"选 x"限制为 `x ∉ R`）。

</details>

---

## Q7 Define a New Problem（加 bound 的定义题）

学校想在教学楼之间装监控。校园有 n 栋楼和 m 条走廊，每条走廊连接两栋楼。若一栋楼装了摄像头，则与它相连的所有走廊都被监控。摄像头很贵，希望装得尽量少，但每条走廊都必须被监控。

(a) 把它形式化定义为一个 optimization problem（写清 Input / Output）。
(b) 定义对应的 decision problem。

<details><summary>参考答案</summary>

**(a)** 先建模：楼 = 顶点，走廊 = 边，"每条走廊被监控" = 每条边至少一个端点被选（这就是 Vertex Cover）。
```text
Minimum Camera Placement
Input: 无向图 G = (V, E)，|V| = n, |E| = m
Output: 大小最小的 C ⊆ V，使得每条边 (u, v) ∈ E 都满足 u ∈ C 或 v ∈ C
```

**(b)** 加 bound k，改成问句（最小化 → "≤ k"）：
```text
Camera Placement (decision)
Input: 无向图 G = (V, E)；正整数 k
Question: 是否存在 C ⊆ V，|C| ≤ k，使得每条边 (u, v) ∈ E 都有 u ∈ C 或 v ∈ C？
```

常见扣分点：bound 忘了写进 Input；问句里用了 Input 没定义的记号；最小化问题误写成 "≥ k"。

</details>

---

## Q8 DP 大题（五步法作答）

m×n 网格，每格有非负分数 g[i][j]。从左上角 (1,1) 走到右下角 (m,n)，每步只能**向右**或**向下**，求能收集的最大总分。请按五步法（状态定义 → 递推式 → base case → 填表顺序 → 答案与复杂度）完整作答。

<details><summary>参考答案</summary>

1. **状态**：dp[i][j] = 从 (1,1) 走到 (i,j) 能收集的最大总分。
2. **递推**：到 (i,j) 的上一步只能来自上方或左方，取较优者：
   `dp[i][j] = g[i][j] + max(dp[i−1][j], dp[i][j−1])`
3. **Base case**：`dp[1][1] = g[1][1]`；第一行只能从左来 `dp[1][j] = dp[1][j−1] + g[1][j]`；第一列只能从上来 `dp[i][1] = dp[i−1][1] + g[i][1]`。
4. **填表顺序**：i 从 1 到 m、j 从 1 到 n 逐行填（算 dp[i][j] 时上方和左方都已算好）。
5. **答案** dp[m][n]；表有 m·n 项、每项 O(1) → **O(m·n)**（又是双变量！）。

```text
MaxPath(g[1..m][1..n]):
  dp[1][1] = g[1][1]
  for j = 2 to n: dp[1][j] = dp[1][j−1] + g[1][j]
  for i = 2 to m: dp[i][1] = dp[i−1][1] + g[i][1]
  for i = 2 to m:
      for j = 2 to n:
          dp[i][j] = g[i][j] + max(dp[i−1][j], dp[i][j−1])
  return dp[m][n]
```

</details>

---

## Q9 最后一题：BFS / DFS

R×C 的迷宫网格，每格是空地 `.` 或墙 `#`，给定起点 S 和终点 E，每步可上下左右移动到相邻空地。

(a) 求从 S 到 E 的**最少步数**（无法到达输出 −1）。应该用 BFS 还是 DFS？为什么？写出伪代码。
(b) 若只问"能否到达"，DFS 可以吗？
(c) 该算法的 running time？

<details><summary>参考答案</summary>

**(a) 用 BFS。** 把每个空地格子看作顶点、相邻空地间连边，问题就是**无权图最短路径**——只有 BFS 按"层"（步数）扩展，第一次到达某格时的距离必为最短；DFS 找到的路径不保证最短。

```text
MazeBFS(grid, S, E):
  for each 格子 p: dist[p] = ∞
  Q = 空队列
  dist[S] = 0; enqueue(Q, S)
  while Q 非空:
      u = dequeue(Q)
      if u == E: return dist[u]
      for each v in u 的上、下、左、右四个相邻格:
          if v 在网格内 and grid[v] ≠ '#' and dist[v] == ∞:
              dist[v] = dist[u] + 1
              enqueue(Q, v)
  return −1                      // 队列空了还没到 E → 不可达
```

（`dist[v] == ∞` 同时起到 visited 的作用。）

**(b) 可以。** 可达性问题 BFS/DFS 都行——DFS 从 S 递归标记所有可达格子，看 E 是否被标记。只有"最少步数"才必须 BFS。

**(c)** 顶点数 = R·C 个格子，每格最多 4 条边 → m = O(R·C)。BFS 为 O(n + m) = **O(R·C)**。

</details>

---

## Q10 Greedy & Correctness Proof（第二批情报原题）

带权活动选择：活动 i 有开始时间 sᵢ、结束时间 fᵢ、权重 wᵢ > 0，选互不重叠的活动使**总权重**最大。

(a) 解释为什么经典 "earliest finish time" 贪心在带权版本**失效**，并给一个小反例。
(b) 描述带权版本的正确解法（greedy / DP）。
(c) 对**无权**经典活动选择，给出完整的 greedy choice property 证明。

<details><summary>参考答案</summary>

**(a)** EFT 只看结束时间、完全不看权重，因此一个**小权重但早结束**的活动会被优先选中，并把与它重叠的**大权重**活动挤掉。
反例：X = [1, 2)，w = 1；Y = [0, 10)，w = 100（两者重叠）。EFT 选 X 弃 Y，总权重 1；最优解选 Y，总权重 100。可以差任意多倍。

**(b)** 用 **DP（weighted interval scheduling）**：
按结束时间排序；令 p(i) = i 之前最后一个与活动 i 不重叠的活动（fⱼ ≤ sᵢ 的最大 j，无则 0）。
定义 dp[i] = 只考虑前 i 个活动的最大总权重，则

```text
dp[0] = 0
dp[i] = max( dp[i−1],           // 不选 i
             w[i] + dp[p(i)] )   // 选 i，则只能再配 p(i) 及之前的活动
```

答案 dp[n]。排序 + 二分求全部 p(i) 共 O(n log n)，填表 O(n)，总 **O(n log n)**。

**(c)** **Claim**：存在最优解包含最早结束的活动 a₁。
**证明（exchange argument）**：任取最优解 OPT。若 a₁ ∈ OPT 得证。否则设 b 为 OPT 中结束最早的活动；因 a₁ 全局结束最早，f(a₁) ≤ f(b)。OPT 中其余活动与 b 不重叠，开始时间均 ≥ f(b) ≥ f(a₁)，故换成 a₁ 后与它们仍不冲突。于是 OPT′ = (OPT \ {b}) ∪ {a₁} 可行且 |OPT′| = |OPT|，是含 a₁ 的最优解。∎
选定 a₁ 后，剩余问题是"开始时间 ≥ f(a₁) 的活动上的同型子问题"，对其归纳重复此论证，得贪心解整体最优。

</details>

---

## Q11 BFS vs DFS 对比（第二批情报原题）

从以下三方面比较 BFS 和 DFS：use case；edge classification（tree, back, forward, cross edges）；用 V、E 表示的最坏时间与空间复杂度。

<details><summary>参考答案</summary>

**Use case**：
- BFS：无权图**最短路径**/最少步数、按层处理、二分图判定。
- DFS：**环检测**、拓扑排序、连通分量、路径存在性、回溯式穷举。

**Edge classification**（DFS 对有向图分类边 (u,v)）：
- **Tree**：第一次发现 v 的边（构成 DFS 树）；
- **Back**：v 是 u 的祖先（含自环）——**有 back edge ⟺ 有环**；
- **Forward**：v 是 u 的非直接后代；
- **Cross**：其余（子树之间/无祖先关系）。
要点：无向图 DFS 只有 tree + back；无向图 BFS 只有 tree + cross（层差 ≤ 1）；有向图 BFS 没有 forward edge。

**复杂度**（图本身不计入空间）：

| | BFS | DFS |
|---|---|---|
| 最坏时间（邻接表） | O(V + E) | O(V + E) |
| 最坏时间（邻接矩阵） | O(V²) | O(V²) |
| 最坏空间 | O(V)（队列 + visited） | O(V)（递归栈 + visited） |

</details>

---

## 建议自测顺序

第一遍：只做 Q1、Q5、Q6（三道动手写伪代码的，最重要）；
第二遍：Q7、Q8、Q10（定义题 + DP 五步法 + 贪心证明，练"格式分"和证明写法）；
第三遍：Q2、Q3、Q4、Q9、Q11 一口气限时做完（选择 + 简答 + 认代码 + 对比题，练速度）。
