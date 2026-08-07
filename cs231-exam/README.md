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
| 6 | 大题 | **Representative set** —— **assignment 3 或 4 的原题** | ⚠️ 最高优先级行动项，见下 |
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

## 3. 复习优先级（按朋友建议的顺序）

1. ⭐ **翻出你自己的 CS231 assignment 3 和 4，把 representative set 那道题重新做一遍** ——
   这是"原题"，性价比最高。（注意：这个仓库里现在只有 CS 115 的 a04q1.rkt / a04q2.rkt，
   **不是** CS231 的作业，需要你自己去 LEARN/MarkUs 上找。）
2. **Divide & conquer + backtracking 的伪代码模板**背熟，各练 1–2 道例题（→ `study-guide.md` §2、§3，`practice.md` Q1、Q5）。
3. **Recurrence relation**：会从伪代码写出 T(n)，会用递归树/Master theorem 解常见递归式（→ `study-guide.md` §2.3）。
4. **各种 problem 的 definition**：Input / Output 格式，decision vs optimization，怎么加 bound（→ `study-guide.md` §7）。
5. **每个 paradigm 是什么**、给代码认 paradigm 的特征（→ `study-guide.md` §8 速查表）。
6. **Las Vegas vs Monte Carlo** 对比表背熟（→ `study-guide.md` §6）。
7. **BFS / DFS** 伪代码 + 什么时候用哪个 + 对比表和 edge classification（→ `study-guide.md` §4）。
8. **DP** 五步法 + 2–3 道经典题，重点 **weighted interval scheduling**（→ `study-guide.md` §5）。
9. **Greedy**：activity selection 的 correctness proof（exchange argument）+ 带权失效反例（→ `study-guide.md` §11）。
10. 用 `practice.md` 的仿真卷自测一遍。

---

## 4. 文件说明

- **`study-guide.md`** —— 完整复习笔记：每个考点的模板、例题、速查表、答题 checklist。
- **`practice.md`** —— 按考试结构出的仿真练习题（带完整参考答案），用来练"动手写伪代码"。
