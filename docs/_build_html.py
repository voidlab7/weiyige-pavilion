#!/usr/bin/env python3
"""
维弈阁知识库 HTML 生成器 v2
浅色模式 + SVG 架构图 + 全站导航 + 面包屑
用法: python3 docs/_build_html.py
"""
import os, re, html as h

DOCS = os.path.dirname(os.path.abspath(__file__))

def esc(s): return h.escape(s)

# ── Markdown → HTML 转换 ─────────────────────────────────────

def md_table_to_html(lines):
    rows = []
    for i, line in enumerate(lines):
        cells = [c.strip() for c in line.strip().strip('|').split('|')]
        if i == 1 and all(set(c.strip()) <= set('-: ') for c in cells):
            continue
        tag = 'th' if i == 0 else 'td'
        row = ''.join(f'<{tag}>{inline(c)}</{tag}>' for c in cells)
        rows.append(f'<tr>{row}</tr>')
    return '<table>' + '\n'.join(rows) + '</table>'

def inline(text):
    t = esc(text)
    t = re.sub(r'\*\*(.+?)\*\*', r'<strong>\1</strong>', t)
    t = re.sub(r'`([^`]+)`', r'<code>\1</code>', t)
    def link_repl(m):
        txt, url = m.group(1), m.group(2)
        url = re.sub(r'\.md($|(?=\)))', '.html', url)
        return f'<a href="{url}">{txt}</a>'
    t = re.sub(r'\[([^\]]+)\]\(([^)]+)\)', link_repl, t)
    t = re.sub(r'(?<!\*)\*(?!\*)(.+?)(?<!\*)\*(?!\*)', r'<em>\1</em>', t)
    return t

def md_to_html(md_text):
    lines = md_text.split('\n')
    out = []; in_code = False; in_table = False; table_buf = []; in_list = False
    for line in lines:
        if line.strip().startswith('```'):
            if in_code:
                out.append('</code></pre>'); in_code = False
            else:
                lang = line.strip()[3:].strip()
                out.append(f'<pre><code class="{esc(lang)}">'); in_code = True
            continue
        if in_code: out.append(esc(line)); continue
        if '|' in line and line.strip().startswith('|'):
            if not in_table: in_table = True; table_buf = []
            table_buf.append(line); continue
        elif in_table:
            out.append(md_table_to_html(table_buf)); in_table = False; table_buf = []
        s = line.strip()
        m = re.match(r'^(#{1,6})\s+(.*)', s)
        if m:
            if in_list: out.append('</ul>'); in_list = False
            lv = len(m.group(1)); txt = m.group(2)
            slug = re.sub(r'[^\w\u4e00-\u9fff-]', '', txt.replace(' ', '-')).lower()
            out.append(f'<h{lv} id="{slug}">{esc(txt)}</h{lv}>'); continue
        if s in ('---', '***'):
            if in_list: out.append('</ul>'); in_list = False
            out.append('<hr>'); continue
        if s.startswith('> '):
            if in_list: out.append('</ul>'); in_list = False
            out.append(f'<blockquote>{inline(s[2:])}</blockquote>'); continue
        if s.startswith('- [ ]') or s.startswith('- [x]'):
            if not in_list: out.append('<ul class="check">'); in_list = True
            ck = ' checked' if s.startswith('- [x]') else ''
            out.append(f'<li><input type="checkbox" disabled{ck}> {inline(s[5:].strip())}</li>'); continue
        if re.match(r'^[-*]\s', s) or re.match(r'^\d+\.\s', s):
            if not in_list: out.append('<ul>'); in_list = True
            li_text = re.sub(r'^[-*0-9.]+\s+', '', s)
            out.append(f'<li>{inline(li_text)}</li>'); continue
        if in_list and s == '': out.append('</ul>'); in_list = False
        if s: out.append(f'<p>{inline(s)}</p>')
    if in_table: out.append(md_table_to_html(table_buf))
    if in_list: out.append('</ul>')
    return '\n'.join(out)

# ── 导航树 ───────────────────────────────────────────────────

NAV = [
    ("🏠 首页", "index.html"),
    ("概览", [
        ("维弈阁是什么", "overview/what-is-weiyige.html"),
        ("整体架构", "overview/architecture.html"),
        ("术语表", "overview/glossary.html"),
        ("文件地图", "overview/project-map.html"),
    ]),
    ("角色手册", [
        ("角色一览", "agents/agent-catalog.html"),
        ("设计原则", "agents/agent-design-principles.html"),
    ]),
    ("协议解读", [
        ("加载协议", "protocols/loading-protocol.html"),
        ("交接机制", "protocols/handoff-protocol.html"),
        ("门禁系统", "protocols/gate-system.html"),
        ("状态管理", "protocols/state-management.html"),
    ]),
    ("CLI 工具", [
        ("命令手册", "cli/cli-reference.html"),
        ("CLI 架构", "cli/cli-architecture.html"),
        ("变更日志", "cli/cli-changelog.html"),
    ]),
    ("运维中心", [
        ("ops 概览", "ops/ops-overview.html"),
        ("Dashboard", "ops/dashboard.html"),
        ("调度器", "ops/scheduler.html"),
        ("部署同步", "ops/deployment.html"),
    ]),
    ("架构决策", [
        ("ADR 模板", "decisions/ADR-template.html"),
        ("ADR-001 CLI替代Markdown", "decisions/ADR-001-cli-over-markdown.html"),
        ("ADR-002 单一真相源", "decisions/ADR-002-single-source.html"),
        ("ADR-003 两层门禁", "decisions/ADR-003-two-layer-gate.html"),
        ("ADR-004 CodeBuddy双入口", "decisions/ADR-004-codebuddy-entry.html"),
    ]),
    ("经验教训", [
        ("LLM 遗忘 bug", "lessons/LLM遗忘bug.html"),
        ("finish-task 阻塞", "lessons/finish-task-blocking.html"),
        ("skipped 显示 bug", "lessons/skipped-phase-display.html"),
        ("Dogfooding 教训", "lessons/dogfooding-lesson.html"),
    ]),
    ("架构优化", [
        ("优化总计划", "architecture-optimization/index.html"),
        ("P0-1 CLI state写操作", "architecture-optimization/P0-1-cli-state-write-guard.html"),
        ("P0-2 状态校验hook", "architecture-optimization/P0-2-state-validation-hook.html"),
        ("P0-3 finish-task检查", "architecture-optimization/P0-3-finish-task-enforce.html"),
        ("P1-1 IDENTITY精简", "architecture-optimization/P1-1-identity-slim.html"),
        ("P1-2 分级加载协议", "architecture-optimization/P1-2-lazy-load-protocol.html"),
        ("P1-3 共享知识外置", "architecture-optimization/P1-3-shared-knowledge-extract.html"),
        ("P2-1 自动git commit", "architecture-optimization/P2-1-auto-git-commit.html"),
        ("P2-2 状态变更历史", "architecture-optimization/P2-2-state-change-history.html"),
        ("P2-3 快照与回退", "architecture-optimization/P2-3-health-snapshot.html"),
        ("P3-1 CLI环境自适应", "architecture-optimization/P3-1-cli-env-adaptive.html"),
        ("P3-2 hook平台分支", "architecture-optimization/P3-2-hook-platform-branch.html"),
    ]),
    ("演进历史", [
        ("变更日志", "evolution/changelog.html"),
        ("路线图", "evolution/roadmap.html"),
    ]),
]

def build_nav(cur):
    parts = []
    for item in NAV:
        if isinstance(item[1], str):
            name, href = item
            rel = os.path.relpath(os.path.join(DOCS, href), os.path.dirname(os.path.join(DOCS, cur)))
            act = ' class="active"' if href == cur else ''
            parts.append(f'<a href="{rel}"{act}>{esc(name)}</a>')
        else:
            name, children = item
            # check if any child is active
            is_open = any(c[1] == cur for c in children)
            open_cls = ' open' if is_open else ''
            parts.append(f'<div class="nav-group{open_cls}">{esc(name)}</div>')
            parts.append(f'<div class="nav-children{open_cls}">')
            for cn, ch in children:
                rel = os.path.relpath(os.path.join(DOCS, ch), os.path.dirname(os.path.join(DOCS, cur)))
                act = ' class="active"' if ch == cur else ''
                parts.append(f'<a href="{rel}"{act}>{esc(cn)}</a>')
            parts.append('</div>')
    return '\n'.join(parts)

# ── CSS（浅色，简约大方）────────────────────────────────────

CSS = """
:root{
  --bg:#fafbfc; --surface:#fff; --border:#e1e4e8; --border2:#d0d7de;
  --text:#24292f; --text2:#57606a; --text3:#8b949e;
  --accent:#0969da; --accent-bg:#ddf4ff; --accent2:#1a7f37; --accent2-bg:#dafbe1;
  --warn:#9a6700; --warn-bg:#fff8c5; --err:#cf222e; --err-bg:#ffebe9;
  --code-bg:#f6f8fa; --nav-w:260px; --radius:8px;
}
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Helvetica,Arial,sans-serif;
  background:var(--bg);color:var(--text);line-height:1.7;display:flex;min-height:100vh}

/* 侧边导航 */
nav{width:var(--nav-w);background:var(--surface);border-right:1px solid var(--border);
  position:fixed;top:0;left:0;bottom:0;overflow-y:auto;padding:0 0 24px;z-index:10}
nav .logo{padding:20px 20px 16px;font-size:17px;font-weight:700;color:var(--accent);
  border-bottom:1px solid var(--border);display:flex;align-items:center;gap:8px}
nav .logo svg{width:20px;height:20px}
nav a{display:block;padding:5px 16px 5px 24px;color:var(--text2);text-decoration:none;
  font-size:13px;border-left:3px solid transparent;transition:all .12s}
nav a:hover{color:var(--text);background:var(--accent-bg)}
nav a.active{color:var(--accent);border-left-color:var(--accent);background:var(--accent-bg);font-weight:600}
.nav-group{padding:18px 16px 4px;font-size:11px;font-weight:700;color:var(--text3);
  text-transform:uppercase;letter-spacing:.6px;cursor:pointer;user-select:none}
.nav-children{display:none}
.nav-children.open,.nav-group.open+.nav-children{display:block}

/* 主内容 */
main{margin-left:var(--nav-w);flex:1;padding:36px 56px 60px;max-width:880px}
h1{font-size:26px;font-weight:700;margin:0 0 8px;padding-bottom:12px;border-bottom:2px solid var(--border)}
h2{font-size:20px;font-weight:600;margin:32px 0 10px;color:var(--text)}
h3{font-size:16px;font-weight:600;margin:24px 0 8px}
h4{font-size:14px;font-weight:600;margin:20px 0 6px;color:var(--text2)}
p{margin:6px 0 10px}
a{color:var(--accent);text-decoration:none}
a:hover{text-decoration:underline}
hr{border:none;border-top:1px solid var(--border);margin:24px 0}
blockquote{border-left:3px solid var(--accent);padding:8px 16px;margin:12px 0;
  background:var(--accent-bg);color:var(--text2);border-radius:0 var(--radius) var(--radius) 0;font-size:14px}
code{background:var(--code-bg);padding:2px 6px;border-radius:4px;font-size:13px;
  font-family:'SF Mono',SFMono-Regular,Consolas,'Liberation Mono',Menlo,monospace;color:var(--text)}
pre{background:var(--code-bg);padding:16px;border-radius:var(--radius);margin:12px 0;
  overflow-x:auto;border:1px solid var(--border);line-height:1.5}
pre code{background:none;padding:0;font-size:13px}
table{width:100%;border-collapse:collapse;margin:12px 0;font-size:14px}
th{background:var(--code-bg);text-align:left;padding:10px 12px;border:1px solid var(--border);
  font-weight:600;color:var(--text2);font-size:13px}
td{padding:8px 12px;border:1px solid var(--border);font-size:13px}
tr:nth-child(even) td{background:var(--code-bg)}
tr:hover td{background:var(--accent-bg)}
ul,ol{padding-left:22px;margin:6px 0}
li{margin:3px 0;font-size:14px}
ul.check{list-style:none;padding-left:4px}
ul.check li{padding:2px 0}
ul.check input{margin-right:6px}
strong{color:var(--text);font-weight:600}

/* 面包屑 */
.breadcrumb{font-size:12px;color:var(--text3);margin-bottom:16px}
.breadcrumb a{color:var(--text2)}

/* 响应式 */
@media(max-width:768px){nav{display:none}main{margin-left:0;padding:20px 16px}}

/* 导航折叠交互 */
"""

JS = """
<script>
document.querySelectorAll('.nav-group').forEach(g=>{
  g.addEventListener('click',()=>{
    g.classList.toggle('open');
    const c=g.nextElementSibling;
    if(c&&c.classList.contains('nav-children'))c.classList.toggle('open');
  });
});
// 默认展开当前页所在分组
document.querySelectorAll('.nav-children').forEach(c=>{
  if(c.querySelector('a.active'))c.classList.add('open');
  const g=c.previousElementSibling;
  if(g&&c.classList.contains('open'))g.classList.add('open');
});
</script>
"""

LOGO_SVG = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2L2 7l10 5 10-5-10-5z"/><path d="M2 17l10 5 10-5"/><path d="M2 12l10 5 10-5"/></svg>'

def breadcrumb(cur):
    parts = cur.replace('.html','').split('/')
    if len(parts) <= 1: return ''
    bc = f'<a href="{os.path.relpath(os.path.join(DOCS,"index.html"), os.path.dirname(os.path.join(DOCS,cur)))}">首页</a>'
    bc += f' / <span>{parts[0]}</span>'
    return f'<div class="breadcrumb">{bc}</div>'

def page(title, body, nav_path):
    return f'''<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>{esc(title)} — 维弈阁知识库</title>
<style>{CSS}</style>
</head>
<body>
<nav>
<div class="logo">{LOGO_SVG} 维弈阁 Wiki</div>
{build_nav(nav_path)}
</nav>
<main>
{breadcrumb(nav_path)}
{body}
</main>
{JS}
</body>
</html>'''

# ── 页面注册 ─────────────────────────────────────────────────

PAGES = {}
def add(path, title, md): PAGES[path] = (title, md)
def read(rel):
    fp = os.path.join(DOCS, rel)
    return open(fp,'r',encoding='utf-8').read() if os.path.exists(fp) else f'# {rel}\n\n（待创建）'

# 首页
add("index.html", "维弈阁知识库", read("INDEX.md"))

# 概览
for f in ["what-is-weiyige","architecture","glossary","project-map"]:
    md = read(f"overview/{f}.md")
    m = re.match(r'#\s+(.*)', md); t = m.group(1) if m else f
    add(f"overview/{f}.html", t, md)

# 角色
for f in ["agent-catalog","agent-design-principles"]:
    md = read(f"agents/{f}.md")
    m = re.match(r'#\s+(.*)', md); t = m.group(1) if m else f
    add(f"agents/{f}.html", t, md)

# 协议
for f in ["loading-protocol","handoff-protocol","gate-system","state-management"]:
    md = read(f"protocols/{f}.md")
    m = re.match(r'#\s+(.*)', md); t = m.group(1) if m else f
    add(f"protocols/{f}.html", t, md)

# CLI
for f in ["cli-reference","cli-architecture","cli-changelog"]:
    md = read(f"cli/{f}.md")
    m = re.match(r'#\s+(.*)', md); t = m.group(1) if m else f
    add(f"cli/{f}.html", t, md)

# ops
for f in ["ops-overview","dashboard","scheduler","deployment"]:
    md = read(f"ops/{f}.md")
    m = re.match(r'#\s+(.*)', md); t = m.group(1) if m else f
    add(f"ops/{f}.html", t, md)

# decisions
for f in ["ADR-template","ADR-001-cli-over-markdown","ADR-002-single-source","ADR-003-two-layer-gate","ADR-004-codebuddy-entry"]:
    md = read(f"decisions/{f}.md")
    m = re.match(r'#\s+(.*)', md); t = m.group(1) if m else f
    add(f"decisions/{f}.html", t, md)

# lessons
add("lessons/LLM遗忘bug.html", "LLM 遗忘 Bug", read("LLM遗忘bug.md"))
for f in ["finish-task-blocking","skipped-phase-display","dogfooding-lesson"]:
    md = read(f"lessons/{f}.md")
    m = re.match(r'#\s+(.*)', md); t = m.group(1) if m else f
    add(f"lessons/{f}.html", t, md)

# 架构优化
add("architecture-optimization/index.html", "架构优化总计划", read("weiyige-architecture-optimization-plan.md"))
for pid in ["P0-1-cli-state-write-guard","P0-2-state-validation-hook","P0-3-finish-task-enforce",
            "P1-1-identity-slim","P1-2-lazy-load-protocol","P1-3-shared-knowledge-extract",
            "P2-1-auto-git-commit","P2-2-state-change-history","P2-3-health-snapshot",
            "P3-1-cli-env-adaptive","P3-2-hook-platform-branch"]:
    md = read(f"architecture-optimization/{pid}.md")
    m = re.match(r'#\s+(.*)', md); t = m.group(1) if m else pid
    add(f"architecture-optimization/{pid}.html", t, md)

# evolution
for f in ["changelog","roadmap"]:
    md = read(f"evolution/{f}.md")
    m = re.match(r'#\s+(.*)', md); t = m.group(1) if m else f
    add(f"evolution/{f}.html", t, md)

# ── 生成 ─────────────────────────────────────────────────────

def main():
    n = 0
    for out_rel, (title, md) in PAGES.items():
        body = md_to_html(md)
        html = page(title, body, out_rel)
        out = os.path.join(DOCS, out_rel)
        os.makedirs(os.path.dirname(out), exist_ok=True)
        with open(out, 'w', encoding='utf-8') as f: f.write(html)
        n += 1
        print(f'  ✅ {out_rel}')
    print(f'\n🎉 生成完成: {n} 个 HTML 页面')
    print(f'   入口: file://{os.path.join(DOCS, "index.html")}')

if __name__ == '__main__':
    main()
