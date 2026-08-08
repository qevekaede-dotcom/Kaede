# CS 231 期末考试情报 & 复习计划

> 课程：University of Waterloo — CS 231 Algorithmic Problem Solving（Spring 2026）
> 信息来源：考过的同学的语音转文字（有误识别，下面已全部还原）。

---

## 1. 语音转文字还原对照表

| 语音原文（误识别） | 实际意思 |
|---|---|
| 速度code | **伪代码 (pseudocode)** |
| black tracking | **backtracking（回溯）** |
| 迪拜conquer | **divide and conquer（分治）** |
| represent / representation set | **representative set**（assignment 3 或 4 的原题） |
| 加一个棒 | **加一个 bound**（定义 decision problem 时给输入加一个界 k） |
| parad IgM | **paradigm（算法设计范式）**：分治、贪心、动态规划、回溯这类通用设计思想的统称 |
| 小文 | 小问（关于 randomized algorithm 的简答题） |
| BF | **BFS**（宽度优先搜索，和 DFS 二选一/其一） |
| TN | **T(n)**（recurrence relation 递归式） |
| Las Vegas monte Carlo | **Las Vegas / Monte Carlo** 两类随机化算法 |

---

## 2. 考试结构（根据情报拼出来的）

| # | 题型 | 内容 | 备注 |
|---|---|---|---|
| 1 | 大题 | **写 divide and conquer 伪代码**；最后一小问要写 **recurrence relation T(n)**（可能要用 Master theorem / 解出复杂度） | 第一题，必考 |
| 2 | 选择题 | **Running time 分析**，特点是**有 m 和 n 两个变量**（不是普通单变量的 running time） | 如 O(n+m)、O(nm)、O(nW) 等 |
| 3 | 简答（小问） | **Randomized algorithms**：Las Vegas vs Monte Carlo | 概念对比 + 判断题型 |
| 4 | 认代码题 | 给一段 code/伪代码，问它用的是**哪种 paradigm** | 见复习笔记的"认范式速查表" |
| 5 | 大题 | **Backtracking 算法**（要会写伪代码） | |
| 6 | 大题 | **Representative sets** —— **a3-W3 原题已找到**：用四步 recipe 证明 REPRESENTATIVE SETS DECISION ∈ NP（也可能考 hill-climbing / 随机化变体） | ✅ 详解见 `study-guide.md` §10 |
| 7 | 大题 | **Define 一个 new problem**，要**加一个 bound**（把 optimization problem 转成 decision problem） | 格式题，好拿分 |
| 8 | 大题 | **DP（动态规划）**，据说挺难 | 重点练 2 个变量的表（O(mn) 类） |
| 9 | 最后一题 | 要用 **BFS 或 DFS** 的算法题（据说以前没出现过的新题型） | 也可能是 BFS vs DFS 对比（见下方第二批情报） |
| 10 | 大题 | **Greedy + correctness proof**（weighted activity selection：贪心为何失效 + 反例 + DP 解法 + greedy choice property 证明） | 来自第二批情报 |

---

## 2.5 第二批情报：疑似被用作出题素材的练习卷

朋友后来发来一份练习卷的截图，**这份卷子好像被（出题时）用到了**，其中可见的题目：

- **Question 3: Greedy Algorithms & Correctness Proof** —— weighted activity selection（活动带权重 wᵢ，选互不重叠的活动使总权重最大）：
  - (a) 为什么经典 "earliest finish time" 贪心在带权版本**失效**+ 小反例；
  - (b) 带权版本的正确解法（→ **weighted interval scheduling DP**，很可能就是那道"挺难的 DP"）；
  - (c) 无权经典版的完整 **greedy choice property 证明**（exchange argument）。
  - → 复习：`study-guide.md` §11，参考答案：`practice.md` Q10。
- **Question 5: Graph Algorithms & Complexity** —— **Compare BFS and DFS**：use case、**edge classification（tree / back / forward / cross edges）**、用 V、E 表示的最坏时间与**空间**复杂度。
  - → 复习：`study-guide.md` §4（已含对比表和 edge classification），参考答案：`practice.md` Q11。
- 卷子里也有 **"define a new problem with a bound"** —— 印证情报 #7。

---

## 2.6 第三批情报：官方文件到手（最权威，以此为准）

已拿到并全部读完（带 y245sun 水印的正版课件）：
**Spring 2026 官方期末练习卷 + 官方答案**、**a2 / a3 solutions（Spring 2026, C. Roberts）**、**a4 solutions（Spring 2025, D. Dvorski）**、a1 solutions。关键修正：

- **这门课比最初想的更偏理论**：NP / NP-completeness / 归约、复杂度类（RP、BPP、PTAS、APX、NC、FPT）、
  hill climbing 启发式、approximation ratio、adversary 下界**都在考试范围**（练习卷 10 道选择题里占了一半）。
- **Representative sets 原题确认**：a3-W3 = 证明 REPRESENTATIVE SETS DECISION ∈ NP（四步 recipe）。
  定义是"从 𝒜 中选 ≤ k 个集合使并集不缩水"（set-cover 型），**不是** hitting set。
  2025 年 a4 还考了它的 hill-climbing（W3）和随机化判断（W4）——同一问题多种考法。
- **分治大题的样子**：a2-W3（树上分治 TOTAL）+ a2-W4（给伪代码按行写 recurrence，base/general 分开问，
  divide/conquer/combine 各对应哪几行）+ a2-W5（substitution method 解递归式）——朋友说的
  "Q1 分治伪代码 + 最后一问 T(n)" 完全对上。
- **DP 大题的样子**：a3-W1 / 练习卷 L1——给抽象递推式 N(i,j)，考手算、base cases、**表的最小形状**、
  填表顺序、Θ(n²)。朋友说的"挺难的 DP"和"有 MN 的 running time"多半指这类 + O(mn) 表。
- 朋友第二批截图（"Question 3 Greedy proof / Question 5 BFS-DFS 对比"）的样式与官方练习卷**不符**，
  应是另一份非官方材料；内容仍有复习价值（贪心证明、edge classification），但优先级让位于官方卷。

---

## 3. 复习优先级（结合官方材料修订）

1. ⭐ **把 `final-practice-walkthrough.md`（官方练习卷逐题详解）过一遍**——10 道 MC 的官方答案 + 理由全部搞懂，6 道长答题的"答题格式"背下来。
2. ⭐ **Representative sets 原题**：定义 + NP 四步证明默写（→ `study-guide.md` §10，`practice.md` Q6）。
3. **NP 四步 recipe + 归约六步 recipe** + 复杂度类判断题弹药库（→ `study-guide.md` §12）。
4. **分治**：伪代码模板（课程格式）+ 按行写 recurrence + substitution method + Master method 陷阱（→ §2，尤其 §2.4）。
5. **DP 表格题套路**（手算/base/表形状/填表顺序/复杂度）+ string editing 等双变量表（→ §5.3）。
6. **Backtracking**：模板 + bounding function 方向 + 搜索树的 FPT/正确性分开判断（→ §3）。
7. **LV vs MC 课程口径** + LV→MC 转化标准答案 + "两头都不是"（→ §6）。
8. **Hill climbing / approximation ratio / FPT / adversary 下界**（→ §13）。
9. **Problem 定义**：decision / enumeration（加 bound 两种造法）/ constructive vs evaluation（→ §7）。
10. **Greedy 反例构造** + exchange argument；**BFS/DFS** + edge classification（→ §11、§4）。
11. 用 `practice.md` 仿真卷限时自测。

---

## 4. 文件说明

- **`final-practice-walkthrough.md`** —— ⭐ 官方期末练习卷逐题详解（10 MC + 6 长答题，含官方答案与讲解）。
- **`study-guide.md`** —— 完整复习笔记：每个考点的模板、例题、速查表、答题 checklist（§10 representative sets 原题详解、§12 NP 专题、§13 启发式/FPT 专题）。
- **`practice.md`** —— 仿真练习题（带完整参考答案），Q6 已按原题重写。

> ⚠️ **注意**：官方课件带你的学号水印且版权归学校（"exclusive use of y245sun"）。这个仓库目前是 **public**，
> 建议改成 **private**（GitHub → Kaede → Settings → General → Danger Zone → Change visibility），
> 或至少不要把 PDF 原件传上来。本目录只放了转述性的个人笔记，没有包含课件原文件。
