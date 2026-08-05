# Waterloo/KW 1B1B 租房邮件工作流 — 状态文件

租客：Qeve (qevekaede@gmail.com)。目标：1B1B，租期 2026-09-01 → 2027-09（12 个月），Sept 2026 入住。
本文件是自动跟进循环的唯一状态来源。每次循环醒来后：先读本文件 → 查 Gmail → 按协议行动 → 更新本文件并 commit+push 到分支 `claude/waterloo-rental-email-followup-3oabxb`。

## 联系渠道与调研结论（2026-08-04/05 调研，已交叉验证）

| # | 目标楼盘 | 收件人 | 邮箱 | 状态 | 最后动作 (UTC) | 跟进次数 |
|---|---------|--------|------|------|----------------|----------|
| 1 | The Hub 全部 8 栋（130 Columbia St W Buildings 1/2 + GEOWAVE Towers 7/8/9；365 Albert St 含 Towers 5&6），Waterloo | LK Apartments 统一招租办公室（抄送旧运营方 Accommod8u） | leasing@lkapartments.com (cc leasing@accommod8u.com) | 草稿已建，待用户发送 | 2026-08-05 草稿 r-2456006558702120625 | 0 |
| 2 | Station Park：Union Tower 1 (5 Wellington St S) / Union Tower 2 (15 Wellington St S) / DUO (25 Wellington St S)，Kitchener | Condo Culture（该社区 Luxury Rental Suites 主要经纪） | info@condoculture.ca | 草稿已建，待用户发送 | 2026-08-05 草稿 r-7113125736698663007 | 0 |
| 3 | Station Park（同上，开发商渠道） | Station Park / VanMar Developments | info@stationpark.com（中等置信度，可能转介） | 草稿已建，待用户发送 | 2026-08-05 草稿 r-7765315847885168724 | 0 |
| 4 | Young Condos 55 Duke St W（+ 85 Duke St W City Centre），Kitchener | Royal York Property Management（代管该楼多套业主单元） | info@royalyorkpm.com | 草稿已建，待用户发送 | 2026-08-05 草稿 r4994868169598567543 | 0 |
| 5 | Young Condos 55 Duke St W（+ 85 Duke），Kitchener | K-W Property Management Corp（现挂 55 Duke 1B 房源，电话 519-954-8082） | kwp@kwproperty.com | 草稿已建，待用户发送 | 2026-08-05 草稿 r-2349310962507589421 | 0 |

调研要点：
- The Hub 8 栋楼共用一个招租办公室（LK Apartments LP，前身/关联 Accommod8u），电话 (519) 783-8383；官方广告 Sept 1 2026 – Aug 31 2027 12 个月租约、最高 2 个月免租。用户心仪两个 1B1B 户型：①客厅整面落地窗 ②corner 角房——已在邮件中点名要户型图/视频/单独报价。
- 55 Duke = Young Condos（2024 年，306 户）+ 85 Duke = City Centre Condos（2016 年）：纯 condo，无招租办公室，业主经中介个别出租；1B 挂牌约 $1,600–1,875。渠道 = Royal York PM、KW Property。
- Wellington = Station Park：Union Towers ×2（2022 年）+ DUO（2026 年 1 月入住）；condo 性质，经 Condo Culture / 业主挂牌出租；1B1B 约 $1,600–2,450，部分含网络/暖气/空调。The Platform (~2028) 与 Building E 未建成，不适用。
- 所有邮箱均通过多独立来源交叉验证（本环境网络策略拦截直连楼盘官网，验证基于精确短语搜索索引）。

## 自动循环协议（每小时醒一次）

1. 读本文件获取当前状态。
2. 查发送状态：Gmail 搜 `in:sent to:<recipient>`。草稿未发送超过 24h → 用 PushNotification 提醒用户一次（每 24h 最多一次提醒，在日志记录提醒时间）。
3. 查回复：Gmail 搜 `from:lkapartments.com OR from:accommod8u.com OR from:condoculture.ca OR from:stationpark.com OR from:royalyorkpm.com OR from:kwproperty.com`（同时留意来自这些机构别名域/人员个人邮箱的回复，按主题匹配）。
4. 有新回复 → get_thread 读全文 → 提取：看房视频/虚拟看房链接、报价、户型信息、追问的问题 → 更新本表状态和下方日志 → PushNotification 摘要给用户。若对方问的是简单事实（入住日期 2026-09-01、12 个月租期、1B1B、要视频和报价），直接以草稿形式写好回信（reply-to 原邮件）并提醒用户发送。
5. 已发送且无回复满 48h（工作日）→ 在原线程建一封礼貌跟进草稿（每个渠道最多 2 次跟进），提醒用户发送，跟进次数 +1。
6. 状态有任何变化 → 更新本文件，commit + push（网络失败按 2s/4s/8s/16s 重试 4 次）。
7. 结束条件：5 个渠道都拿到视频+报价（汇总后停止），或用户叫停。渠道 3 (stationpark.com) 若回信说请找 Condo Culture，则标记该渠道完成（并入渠道 2）。

## 日志

- 2026-08-04：完成三轮调研（楼盘识别 → 楼栋枚举 → 中介邮箱验证），共 14 个 agent、~80 万 tokens。
- 2026-08-05：建好 5 封草稿（见上表），等待用户在 Gmail 草稿箱一键发送。启动每小时自动循环（cron 任务 afc7392b，每小时 :11，7 天后自动过期需续期）。
- 2026-08-05 00:4x UTC：第一轮循环：5 封草稿均未发送（刚建好，未满 24h 提醒阈值），已发初始 PushNotification 提醒用户发送。无已发邮件，故无回复可查。GitHub 推送被拒（集成只读权限），状态文件仅本地提交；等权限开通后补推。
