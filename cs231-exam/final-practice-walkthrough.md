# CS231 官方期末练习卷逐题详解（Spring 2026）

> 对应你上传的 `final_practice.pdf`（官方答案：`final_practice_solution.pdf`）。
> 每题：官方答案 + 为什么。选择题答案先背熟，再看懂理由；长答题重点学「答题格式」。

---

## Part 1 · Multiple Choice（官方答案 + 解析）

### MC1 — 渐进记号组合 · 答案 **(iii)**

已知 f(n) ∈ Ω(n²)，g(n) ∈ O(n log n)。判断 f·g：

- 关键：Ω 只给 f **下界**（f 可以大到 2ⁿ）；O 只给 g **上界**（g 可以小到常数 1）。
- (i) f·g ∈ O(n⁴)？✗ — f 没有上界，乘积可任意大。
- (ii) f·g ∈ Ω(n³ log n)？✗ — g 可能只是常数，乘积可能只有 n² 级。
- **(iii) f·g ∈ Ω(n²)？✓** — 运行时间函数 g(n) ≥ 1，所以 f·g ≥ f ≥ c·n²。
- (iv) Θ(n³ log n)？✗ — 上下界都定不下来。

**口诀**：Ω×O 相乘时，只有"下界×(≥1)"这条能保住：乘积保住 f 的下界。

### MC2 — Greedy 性质 · 答案 **(i)**

- **(i) ✓ 选了就不反悔** —— greedy 的定义性特征。
- (ii) ✗ 一个 instance 上正确 ≠ 算法正确（正确性要对**所有**输入证明；一个反例足以推翻，一个正例不能证明）。
- (iii) ✗ 不同的 tie-breaking 可能产生**不同解**（a2 W1/W2 专门玩这个）。
- (iv) ✗ greedy 一般比 backtracking **快**得多，不是慢。

### MC3 — Backtracking 性质 · 答案 **(v) None of the above**

- (i) ✗ 探索重复的 partial solutions **会**增加运行时间。
- (ii) ✗ backtracking 不要求输入里有树——搜索树是算法自己构造的。
- (iii) ✗ 方向反了：**minimization 问题的 bounding function 给的是当前部分解所有扩展的"下界 (lower bound)"**——若下界 ≥ 目前最优就剪枝。（写着 upper bound，所以错。）
- (iv) ✗ backtracking **不保证**总比 exhaustive search 快（剪枝可能剪不掉什么）。

### MC4 — NP-hard / NP-complete · 答案 **(ii), (iv)**

A 是 NP-hard，B 是 NP-complete：

- **(ii) ✓ B 可归约到 A**：NP-hard 的定义 = NP 里**所有**问题都能归约到 A；B ∈ NP，所以 B ≤ A。
- **(iv) ✓ B ∈ NP**：NP-complete = NP-hard **且属于 NP**。
- (i) ✗ A 不一定能归约到 B（A 甚至可能不在 NP 里，比如停机问题也是 NP-hard）。
- (iii) ✗ NP-hard 不代表在 NP 里。

**记忆**：NP-complete = NP ∩ NP-hard；NP-hard 只是"至少和 NP 一样难"。

### MC5 — 如果 P = NP · 答案 **(i)(ii)(iii)(iv) 全选**

课程口径：P = NP 时，这些类的区分全部塌缩：

- (i) P = RP：RP ⊆ NP = P，而 P ⊆ RP 本来成立。
- (ii) P = BPP：BPP 夹在多项式层级里，P = NP 使层级塌缩到 P。
- (iii) PTAS = APX：P = NP 时 APX 里的优化问题都能多项式**精确**求解 → 自然有 PTAS。
- (iv) NC = P：课程按"全塌缩"处理，一并选上。

**考试就按官方答案记：全选。**

### MC6 — DP 填表顺序 · 答案 **(ii), (iv)**

M(i,j) = max(M(i−1,j)+10, M(i,j−1)−ij)，依赖**上方**和**左方**。

- (ii) ✓ 按行递增、行内按列递增：算 M(i,j) 时 M(i−1,·) 整行已好，M(i,j−1) 也已好。
- (iv) ✓ 按列递增、列内按行递增：对称同理。
- (i)(iii) ✗ "行内任意顺序"不行——M(i,j) 依赖**同一行**的 M(i,j−1)，行内必须从左到右。

**方法**：把依赖箭头画出来（← 和 ↑），检查候选顺序是否保证"箭头指向的格子先算好"。

### MC7 — Master method 适用性 · 答案 **(i) True**

T(n) ≤ 3T(⌊n/5⌋) + T(⌈2n/10⌉) + Θ(n³)。

- **陷阱**：2n/10 化简 = **n/5**！所以其实是 4T(n/5) + Θ(n³)。
- a=4, b=5, f(n)=n³：n^(log₅4) ≈ n^0.86 ≪ n³ → 第三种情况 → T(n) ∈ Θ(n³)。Master method 适用 ✓。

**教训**：先化简所有子问题规模，再判断是否同型。

### MC8 — Hill climbing · 答案 **(ii) False**

Hill climbing 只保证爬到 **local maximum**（局部最优），不保证 global maximum。这正是它是 heuristic 的原因。

### MC9 — Θ(n²) worst case · 答案 **(iii) Not enough information**

"A 的 worst-case runtime 是 Θ(n²)，则对**所有** instance 运行时间都是平方级"：

- worst case 只约束**最坏**的那些输入；其他输入可能更快（例如插入排序最好情况 O(n)）。
- 但也存在对所有输入都恰好 n² 的算法。所以单凭题设**判断不了** → Not enough information。

### MC10 — FPT 判断 · 答案 **(i) True**

Runtime O(14^(k²) · n³ · log₇(log₃(k⁵!)) · ∛(n^101))，参数 k。

- **FPT 判据：能否写成 f(k) · n^O(1)**（f 只依赖 k，n 的指数是常数）。
- f(k) = 14^(k²) · log₇(log₃(k⁵!)) —— 只含 k，随便多大都行。
- n 部分 = n³ · n^(101/3) = n^(3+101/3) —— 指数是常数 ✓。
- 所以是 FPT。**k 的部分再爆炸都没关系，只要 n 的指数不含 k**（反例：n^k 就不是 FPT）。

---

## Part 2 · Long Answer（官方解法 + 讲解）

### L1 — DP 表格分析：N(i,j)

定义：
- i=0 或 j=0：N(i,j) = max(i+1, j+1)
- i=j：N(i,j) = N(i−1,j−1) + ij
- 其他：N(i,j) = max(N(i−1,j) + i + j, N(i,j−1) + ij)

**(a) 算 N(n,n) 最小需要多大的表？**
沿依赖链走：N(n,n) 是 i=j 情形 → 只依赖 N(n−1,n−1) → … → N(0,0)。
**只需要对角线上的 n+1 个值 → 一张大小 n+1 的 1D 表。**

算 N(n,n−1) 呢？i≠j 情形依赖 N(i−1,j) 和 N(i,j−1)，展开后需要**所有 j ≤ i 的项**
→ **下三角 2D 表，大小 (n+1) × n。**

**答题要点**：这类题先把"依赖图"追出来，看到 i=j 会跳到 (i−1,j−1) 这种"捷径"就要意识到可能省掉大片表格。

**(b) 算 N(4,3) 的表**（官方数值，可自己重算验证）：

| | j=0 | j=1 | j=2 | j=3 |
|---|---|---|---|---|
| i=0 | 1 | | | |
| i=1 | 2 | 2 | | |
| i=2 | 3 | 5 | 6 | |
| i=3 | 4 | 9 | 15 | 15 |
| i=4 | 5 | 14 | 22 | **34** |

验算示例：N(4,3) = max(N(3,3)+4+3, N(4,2)+4·3) = max(15+7, 22+12) = **34**。

### L2 — 跳格子计数（1/2/3 步）

一行 n 格，每步跳 1、2 或 3 格，问到终点的**方案数**。

**递推**：W(n) = W(n−1) + W(n−2) + W(n−3)（第一步跳 1/2/3 三种选择，互斥且穷尽），
base case：W(0) = 1（已到终点算一种方式），负数 → 0。（"Tribonacci"）

官方给的是递归穷举描述；更好的说法：自底向上填 1D 表（DP），O(n)。
**答题要点**："describe an algorithm in your own words" —— 说清递归怎么分解 + base case 即可。

### L3 — EXPENSIVE_PATH（⭐ 对应情报"define new problem + 加 bound"）

问题：树 T 每条边有正权重。Output: 从 root 到某个 leaf 的**最大总权重**路径。

**(a) Greedy 伪代码**（每步走权重最大的那条向下的边）：

```text
EXPENSIVE_PATH_GREEDY(T)
INPUT:  A tree T with a positive weight on each edge
OUTPUT: A path from the root to a leaf node with largest total weight
1  Path ← [TREE_ROOT(T)]
2  Current ← TREE_ROOT(T)
3  while not IS_LEAF(T, Current)
4      Children ← CHILDREN(T, Current)
5      Best ← Children[0]
6      for each Child in Children
7          if EDGE_WEIGHT(T, Child) > EDGE_WEIGHT(T, Best)
8              Best ← Child
9      Path ← Path + [Best]
10     Current ← Best
11 return Path
```

**(b) Greedy 失效反例**：A —1→ B —10→ D；A —2→ C —1→ E。
Greedy 在根处选边权 2 的 C，只能走 [A,C,E]，总权 3；最优是 [A,B,D]，总权 11。
（贪心只看眼前一条边，看不到 B 下面藏着 10。）

**(c) 加 bound B 变 enumeration problem**：

```text
EXPENSIVE_PATH_ENUMERATION
Input:  A tree T with a positive weight on each edge, and a bound B
Output: ALL paths from the root to a leaf node with weight at least B
```

**要点**：加 bound 不只能造 decision 版（是/否存在），也能造 **enumeration 版（枚举全部达标解）**——考试问哪种就写哪种。

**(d) 用 divide-and-conquer 解 enumeration 版**（官方解法思路）：

```text
EXPENSIVE_PATH_ENUM_DC(T, B)
1  return EXPENSIVE_PATH_RECURSIVE(T, B, TREE_ROOT(T))

EXPENSIVE_PATH_RECURSIVE(T, B, Current)
// 返回从 Current 到 leaf、权重 ≥ B 的所有路径
1  if IS_LEAF(T, Current)
2      if B <= 0: return [ [Current] ]     // 剩余要求已满足
3      else:      return [ ]               // 到叶子还差 B > 0，失败
4  else
5      List_soln ← [ ]
6      for each Child in CHILDREN(T, Current)
7          New_bound ← B − EDGE_WEIGHT(T, Child)     // 走这条边"抵扣"权重
8          Part_soln ← EXPENSIVE_PATH_RECURSIVE(T, New_bound, Child)
9          for each Path in Part_soln
10             APPEND(List_soln, [Current] + Path)
11     return List_soln
```

**思想**：divide = 按子树拆分；bound 沿边下传时减去边权；leaf 处 B ≤ 0 即达标。合并 = 给每条子路径接上当前节点。

### L4 — 两个转化题（⭐ 对应情报 Las Vegas/Monte Carlo 小问）

**(a) constructive vs evaluation optimization**：
- constructive 版（问题 A）：求**最优解本身**；evaluation 版（问题 B）：求**最优值**。
- **B 归约到 A 容易**：调用 A 拿到最优解，对着解把值算出来即可。
- A 归约到 B 难得多：只知道最优值，要**重构出解**（通常要反复调用 B 做自归约）。

**(b) Las Vegas → Monte Carlo**（官方标准答案，背）：
> 给 LV 算法设一个（多项式的）**时间上限**；到点还没结束就**强制停止，随便返回一个答案**。
> 这样运行时间必定多项式（→ Monte Carlo 的时间保证），而只要时间上限设得足够大，
> 超时概率很小 → 正确概率高。

### L5 — Exhaustive search 解 MAXIMUM INDEPENDENT SET

Input: graph G；Output: 最大 independent set（两两不相邻的顶点集）。

官方解法（说清三步即可）：
1. **生成**所有 vertex 组合（大小 0..n，共 2ⁿ 个）；
2. **检查**每个组合：逐对顶点验证互不相邻，不合格丢弃；
3. **返回**合格者中最大的。

（变体：先按大小降序排序候选，返回第一个合格的。）
**要点**：exhaustive search 的答题模板 = 生成完整候选空间 + 逐个完整检查 + 取最优。

### L6 — 证明 SUDOKU ∈ NP（⭐ 四步 recipe，必背！）

课程的 **NP membership proof recipe**（练习卷和 a3-W3 原题都用它）：

> **Step 1：给出 yes-instance 的 certificate，并说明其大小是多项式的。**
> SUDOKU：certificate = 一张按规则填满的完整棋盘。大小 = n²×n² 格子 → 多项式 ✓。
>
> **Step 2：给出 verification algorithm，并说明最坏运行时间是多项式的。**
> 依次检查：(i) 尺寸一致 Θ(1)；(ii) 原有数字未被改动 Θ(n⁴)；(iii) 每列含 1..n² 各一次 Θ(n⁴)；
> (iv) 每行同理 Θ(n⁴)；(v) 每个 n×n 子网格同理 Θ(n⁴)。总计 Θ(n⁴)，多项式 ✓。
>
> **Step 3：说明对任何 yes-instance 及其正确 certificate，算法回答 Yes。**
> yes-instance 必有合法完整解；用它作 certificate，所有检查都通过 → Yes ✓。
>
> **Step 4：说明算法不会被 no-instance 的假 certificate 骗到（不产生 false Yes）。**
> no-instance 没有合法解，任何 certificate 必违反上述某条检查 → 必被拒 ✓。

**这个模板考试极可能复用**（representative sets 版见 `study-guide.md` §10——assignment 3 原题）。
