# CS231 Final Review Session 情报（第四批）

> 来源：同学根据 **Final Review Session + Sample Final** 整理的笔记（据说内容都在复习课上被提及）。
> 本文件收录：TA 的范围提示、我们其他文件**尚未覆盖的新考点**、以及考场直接可抄的英文模板。
> （Sample Final = 你已有的官方练习卷，逐题详解见 `final-practice-walkthrough.md`，两边对得上。）

---

## 1. TA 的范围提示（必读）

- Review session 只过了各 Module 的 **major points**；因时间原因**跳过了 adversary strategy、
  information-theoretic lower bound 等**——TA 明确说“没出现在 review ≠ 不考”。→ 这两个考点见下文 §3、§4。
- **M1–M10 都要有基本掌握；M11（复杂度类杂谈）相对低优先级**，更可能以概念题形式出现：
  - P ⊆ NP；NP-complete = NP ∩ NP-hard；
  - P、RP、BPP、APX、PTAS、NC 的关系题**按给定 implication 判断，不要凭名字猜**；
  - RAM / parallel / distributed / quantum 只需概念区分。

---

## 2. 若干“机械步骤”补充（review 强调的做题流程）

- **O/Ω/Θ formal proof 四步**：写目标 inequality → 选具体 c、n₀ → 对所有 n ≥ n₀ 推出不等式 → 写结论。
  例：3n² + log n ∈ O(n²)：取 c=4、n₀=1，log n ≤ n² ⇒ 3n²+log n ≤ 4n²。
  Θ 要上下界各来一次（如 n³/10 − 5n ∈ Θ(n³)：c₂=1；n≥10 时 5n ≤ n³/20 ⇒ c₁=1/20）。
- **Average case**：T_avg(n) = Σ Pr(I)·Time(I)（对全部 size-n instances 按概率加权）；
  best/worst/average 说“对哪类输入取时间”，O/Ω/Θ 说“函数怎么增长”——**两码事，别混**。
- **Iteration（展开）法**示例：T(n)=T(n−1)+4, T(1)=2 → 展开 k 次 T(n)=T(n−k)+4k → 取 k=n−1 →
  T(n)=4n−2 ∈ Θ(n)。
- **能否用 Master 三连**：
  - 3T(n/5)+T(2n/10)+O(n²)：2n/10 = n/5 → 合成 4T(n/5)+O(n²) → **能用**；
  - T(n−1)+n：不是 n/b 型 → **不能**；
  - T(n/2)+T(n/3)+n：子问题比例不同 → **不能直接套**。
- **MYSTERY（review 版）**：切两个约 n/3 的 slices、切片总工作 Θ(n) →
  T(n) ≤ T(⌊n/3⌋)+T(⌈n/3⌉)+Θ(n)，用 upper recurrence 放成 2T(⌈n/3⌉)+Θ(n)；
  Master：x = n^(log₃2) 比 n 慢 → **T(n) ∈ Θ(n)**。
- **DP recipe 完整 8 步**（比五步法多了 shape 和 space）：
  ① define entry 含义（**最容易漏！只写 relation 不定义 T(i,j) 含义 = 不完整**）② table shape/index 范围
  ③ base cases ④ recurrence ⑤ evaluation order（每个 dependency 先算好）⑥ 从哪取答案
  ⑦ runtime = 项数 × 每项 + extraction ⑧ **space = 实际存的表大小**。

---

## 3. 新考点：Information-theoretic lower bound

- 若算法可建模为 binary decision tree，且必须区分 **P 种可能输出**，则树高 h 满足
  **2^h ≥ P ⇒ h ≥ ⌈log₂ P⌉** —— 即至少 ⌈log₂ P⌉ 次比较/询问。
- 经典应用：comparison sorting 要区分 n! 种排列 → 至少 Ω(log(n!)) = **Ω(n log n)** 次比较。
- 答题结构：说清 ① 每次询问二分支 ② 输出可能数 P ③ 高度不够则两个不同输出落在同一叶 → 矛盾。

## 4. 新考点：Adversary proof 通用四步（比 a3-W2 的更一般）

1. Define adversary strategy（如“全部答 no”）。
2. 证明每个 response 都仍与**至少一个合法 input 一致**。
3. 若算法少于 q 次 queries 就作答：构造**两个**与全部 responses 一致、但 correct outputs **不同**的 instances。
4. 算法无法同时对两个都正确 ⇒ 至少需要 q 次。
（下界要写**精确值**如 n(n−1)/2，题目常要求 do not use order notation。）

## 5. 新考点：Branch-and-Bound（与 backtracking pruning 分清）

| | 剪枝理由 |
|---|---|
| **Backtracking pruning** | 当前 partial solution **不可能形成任何 feasible/candidate solution** |
| **Branch-and-Bound pruning** | 即使可能 feasible，也**不可能优于 best-so-far** |

| Optimization | Bounding function | Prune condition |
|---|---|---|
| Minimization | 每个 extension 的 **lower bound LB** | LB ≥ best_so_far |
| Maximization | 每个 extension 的 **upper bound UB** | UB ≤ best_so_far |

口诀：min 问“理论上最小还能多小”；max 问“理论上最大还能多大”。
**例（Minimum Target Sum）**：找 sum=10 的最小子集。partial 已选 p 个数 → 任何 extension 大小 ≥ p，
所以 **LB(partial) = |partial|**；若 |partial| ≥ best_so_far 就剪。

## 6. 新考点：3D DP relation（Sample-Final 风格扩展）

T(i,j,k) = max{T(i−1,j−1,k−1), T(i−4,j−2,k−1), T(i,j−4,k−1)}——所有依赖的第三维都是 **k−1**：
- Evaluation order：**k increasing；每个 k-layer 内 i、j 可以 any order**（不依赖本层）。
- 只求 T(n,n,n)：任一时刻只需 **previous k-layer + current k-layer** → 最小存储 = **两张 2D n×n 表**。
- 每项 O(1) 时：time Θ(n³)，**space Θ(n²)**。
- ⚠️ 若题目要求 **reconstruct 完整 solution/path**：不能只留两层，还要 parent/choice 信息或整表。
（1D 版同理：jump game W[i] 只依赖前三项 → space 可降 Θ(1)。）

## 7. Approximation ratio 补充（统一公式 + 无常数界证明）

- **ratio = max{A/O, O/A} ≥ 1**（A=算法值，O=最优值）；min 问题 = A/O，max 问题 = O/A；ratio=1 ⇔ 该 instance 上达到最优。
- **证明没有 constant ratio bound 的五步**（不能只给一个固定 instance！）：
  ① 定义 instance family I_h ② 证每个 I_h 合法 ③ 算 A(I_h) 与 O(I_h) ④ 算 ratio 并证随 h 无界增长
  ⑤ 结论：no constant can bound the ratio。
- **Tree-height 例子**：算法数叶子 ℓ，返回 A=⌊log₂(ℓ+1)⌋。Perfect binary tree（高 h）：ℓ=2^h → A=h=O → ratio 1；
  **linear tree（链，高 h）**：ℓ=1 → A=1，O=h → ratio=h 随 h 无界 → 无 constant bound。
- 区分：**approximation algorithm 有 ratio guarantee；heuristic（hill climbing 等）没有任何 guarantee**。

## 8. Reduction 语义与常见误解（review 强调）

- **A ≤p B 的意思：用 B 的算法（加多项式额外工作）来解 A** → A is no harder than B；
  B easy ⇒ A easy；A hard ⇒ B hard。箭头指向“至少一样难”的那个。
- **Evaluation optimization ≤p Constructive optimization**（跑 constructive 拿解、算值即可；反向难）。
- 三个误解不要犯：
  ① A ≤p B **不是**“把 B reduce 到 A”；
  ② 证 correctness 的两个 implications 是**一个** reduction 的两半，不是两个 reductions；
  ③ mapping f 只需把每个 A-instance 变成**某个**合法 B-instance，**不需要覆盖 B 的所有 instances**，
    也**不能在构造 f 时先把原 hard problem 解掉**。

## 9. 新例子：Hamiltonian Completion 归约（六步 recipe 实战）

Target Z = Hamiltonian Completion（能否加 ≤ k 条边使 G 有 Hamiltonian cycle）；known Y = Hamiltonian Cycle。
- **构造**：f(G) = (G, 0)（图照抄，k=0）。
- 正方向：G 有 Hamiltonian cycle → 加 0 条边即可 → (G,0) 是 yes。
- 反方向：(G,0) 是 yes → 最多加 0 条边 → cycle 本来就在 G 里 → G 是 yes。
- f 只复制 G、设 k=0 → 多项式。
- 结尾固定句：*Therefore, Y ≤p Z. Since Y is NP-complete, Z is NP-hard. Since Z ∈ NP, Z is NP-complete.*

## 10. FPT 判断速查表（review 版）

| Runtime | FPT? | 原因 |
|---|---|---|
| 2^k · n³ | ✓ | g(k)=2^k，n 指数=3 |
| k! · n^100 | ✓ | g(k)=k!，n 指数固定 |
| 2^(k²) · n⁴ | ✓ | 指数爆炸只依赖 k |
| n^k | ✗ | n 的指数依赖 k |
| k^n · n² | ✗ | n 出现在指数里 |
| 2^n · k³ | ✗ | 对 n exponential |

流程：只含 k 的 factors 全收进 g(k) → 合并含 n 的 factors → 检查 n 的指数是否与 k 无关。
**Bounded search tree**：depth 由 k bound、branching 是常数/只依赖 k → 节点数 g(k) → FPT；
n-way branching + depth k → n^k → 不是 FPT。

## 11. LV / MC 口诀与细节

> **Las Vegas sacrifices the runtime guarantee.**
> **Monte Carlo sacrifices the correctness guarantee.**

- Expected polynomial time：固定同一个 input，对**随机执行**取平均是多项式——不代表 every run 都多项式。
- Repetition：Monte Carlo 可独立重复降低 error probability；题目没给具体概率就**不要自创数字**，
  只说明 independent repetitions increase confidence。

## 12. Greedy grid-path 反例（review 现场例子，可直接搬）

规则：从左上到右下，每步在 right/down 里选 cost 较小的格子。反例（3×3）：

```text
0   2   1
1  10   1
9  11   1
```

Greedy 第一步 1<2 向下，之后被迫经过 10/11 → cost=22；最优 right,right,down,down → cost=5。
**注意**：若题目要求 "for all ways of breaking ties"，最省事的做法是构造**没有 tie** 的输入；
有 tie 就必须论证每种 tie-breaking 都得到题目要求的结果。

---

## 13. 考场英文模板合集（直接套）

**Counterexample（greedy 不正确）**
> Consider the following valid instance: [instance]. The algorithm first [trace the required choices], so it
> returns [algorithm output] with value A. However, [better feasible solution] has value O, where O is better
> than A. Therefore, the algorithm is not correct.

**Exhaustive-search correctness 一句话**
> Every possible [subset/path/order] is generated. Each possibility is tested correctly for
> [feasibility/property]. Therefore every feasible solution is considered, and the algorithm returns
> [the required best/all/count/Yes-No output].

**Z ∈ NP**
> A certificate is [solution]. Its size is polynomial in the input size. We verify [conditions], which takes
> polynomial time. Every yes-instance has a valid certificate that is accepted, and no certificate for a
> no-instance can pass all checks. Therefore, Z ∈ NP.

**NP-complete 最短模板**
> First, Z ∈ NP because [certificate and verifier]. Let Y be a known NP-complete problem. For an arbitrary
> instance x of Y, construct f(x) = [construction]. If x is a yes-instance of Y, then [Y→Z]. Conversely, if
> f(x) is a yes-instance of Z, then [Z→Y]. Thus x is yes for Y iff f(x) is yes for Z. The construction takes
> polynomial time, so Y ≤p Z. Hence Z is NP-hard. Since Z ∈ NP, Z is NP-complete.

**归约正/反方向展开**
> 正：Suppose x is a yes-instance of Y. Then there exists [a Y-solution]. By the construction of f(x),
> [show that it gives a valid Z-solution]. Therefore, f(x) is a yes-instance of Z.
> 反：Suppose f(x) is a yes-instance of Z. Then there exists [a Z-solution]. By the construction of f(x),
> [show that it corresponds to a valid Y-solution]. Therefore, x is a yes-instance of Y.
> （反方向也可写 contrapositive：x no for Y ⇒ f(x) no for Z。）

**Las Vegas → Monte Carlo**
> Choose a polynomial time bound and run the Las Vegas algorithm. If it finishes within the bound, return
> its answer. Otherwise, stop it and return an arbitrary answer. The resulting algorithm always runs in
> polynomial time and is correct with high probability, so it is a Monte Carlo algorithm.

---

## 14. 最后 60 秒检查清单（review 版 + 汇总）

- Problem type 的 output 是 solution / value / Yes-No / count / all solutions？
- Maximization 用 **at least B**；minimization 用 **at most B**？
- Greedy counterexample 真按 algorithm 一步步走了吗？ties 处理满足题意吗？
- D&C 写全 base/divide/conquer/combine 了吗？recurrence 漏没漏 slice/copy/combine 的 non-recursive cost？
- DP：entry 含义、shape、base、order、answer、runtime、**space** 齐全吗？
- Backtracking undo 了吗？B&B 的 min/max bound 方向对吗（min→LB≥best 剪；max→UB≤best 剪）？
- Approximation ratio 取了 ≥1 方向吗？证无 constant bound 用 **family** 了吗？
- Reduction 箭头是 known NP-complete Y → target Z 吗？正反方向各写一次了吗？
- FPT：n 的 exponent 依赖 k 吗？
- LV/MC 的 correctness/runtime guarantee 写反了吗？
- 答案结构完整：**定义对象 → 写固定步骤 → 说明 correctness → 给 runtime/space**。
