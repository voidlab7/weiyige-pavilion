import pathlib

base = '/Users/voidzhang/Documents/workspace/AIAgent/weiyige-dashboard'

# 1. server/index.ts - add todos route
index_content = """import express from 'express'
import cors from 'cors'
import path from 'path'
import fs from 'fs'
import { resolveConfig } from './config.js'
import { createTeamsRouter } from './routes/teams.js'
import { createAgentsRouter } from './routes/agents.js'
import { createTodosRouter } from './routes/todos.js'

const config = resolveConfig(process.argv[2])

console.log(`\\n\\u{1F3EF} \\u7EF4\\u5F08\\u9601 Dashboard Server`)
console.log(`   Workspace: ${config.workspaceRoot}`)
console.log(`   Teams dir: ${config.teamsDir}`)
console.log(`   Weiyige dir: ${config.weiyigeDir}`)

const app = express()
app.use(cors())
app.use(express.json())

// API routes
app.use('/api/teams', createTeamsRouter(config))
app.use('/api/agents', createAgentsRouter(config))
app.use('/api/todos', createTodosRouter(config))

// Health check
app.get('/api/health', (_req, res) => {
  res.json({
    status: 'ok',
    workspace: config.workspaceRoot,
    teamsExist: fs.existsSync(config.teamsDir),
    weiyigeExist: fs.existsSync(config.weiyigeDir),
  })
})

// Serve static files in production
const distDir = path.join(import.meta.dirname || '.', '..', 'dist')
if (fs.existsSync(distDir)) {
  app.use(express.static(distDir))
  app.get('*', (_req, res) => {
    res.sendFile(path.join(distDir, 'index.html'))
  })
}

app.listen(config.port, () => {
  console.log(`   API: http://localhost:${config.port}/api`)
  console.log(`   Ready!\\n`)
})
"""

# 2. src/lib/api.ts - add todos API functions
api_content = """const BASE = '/api'

export async function fetchTeams() {
  const res = await fetch(`${BASE}/teams`)
  if (!res.ok) throw new Error('Failed to fetch teams')
  return res.json()
}

export async function fetchMessages(teamName: string) {
  const res = await fetch(`${BASE}/teams/${encodeURIComponent(teamName)}/messages`)
  if (!res.ok) throw new Error('Failed to fetch messages')
  return res.json()
}

export async function fetchHandoffs(teamName: string) {
  const res = await fetch(`${BASE}/teams/${encodeURIComponent(teamName)}/handoffs`)
  if (!res.ok) throw new Error('Failed to fetch handoffs')
  return res.json()
}

export async function fetchAgents() {
  const res = await fetch(`${BASE}/agents`)
  if (!res.ok) throw new Error('Failed to fetch agents')
  return res.json()
}

export async function fetchHealth() {
  const res = await fetch(`${BASE}/health`)
  if (!res.ok) throw new Error('Failed to fetch health')
  return res.json()
}

// --- Todos API ---

export interface TodoItem {
  id: string
  title: string
  status: 'pending' | 'in_progress' | 'completed' | 'cancelled'
  priority: 'high' | 'medium' | 'low'
  assignee?: string
  created_at: string
  due_date?: string
  tags?: string[]
  description?: string
}

export interface ProjectTodos {
  project: string
  path: string
  updated_at: string
  todos: TodoItem[]
}

export async function fetchTodos(): Promise<ProjectTodos[]> {
  const res = await fetch(`${BASE}/todos`)
  if (!res.ok) throw new Error('Failed to fetch todos')
  return res.json()
}

export async function fetchFlatTodos() {
  const res = await fetch(`${BASE}/todos/flat`)
  if (!res.ok) throw new Error('Failed to fetch flat todos')
  return res.json()
}

export async function fetchRegistry() {
  const res = await fetch(`${BASE}/todos/registry`)
  if (!res.ok) throw new Error('Failed to fetch registry')
  return res.json()
}

export async function addTodo(project: string, data: { title: string; priority?: string; assignee?: string; due_date?: string; tags?: string[]; description?: string }) {
  const res = await fetch(`${BASE}/todos/${encodeURIComponent(project)}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  })
  if (!res.ok) throw new Error('Failed to add todo')
  return res.json()
}

export async function updateTodoStatus(project: string, todoId: string, status: string) {
  const res = await fetch(`${BASE}/todos/${encodeURIComponent(project)}/${encodeURIComponent(todoId)}`, {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ status }),
  })
  if (!res.ok) throw new Error('Failed to update todo')
  return res.json()
}

export async function removeTodo(project: string, todoId: string) {
  const res = await fetch(`${BASE}/todos/${encodeURIComponent(project)}/${encodeURIComponent(todoId)}`, {
    method: 'DELETE',
  })
  if (!res.ok) throw new Error('Failed to delete todo')
  return res.json()
}
"""

# 3. src/pages/TodosPage.tsx
todos_page = """import { useEffect, useState } from 'react'
import { fetchTodos, addTodo, updateTodoStatus, removeTodo, ProjectTodos, TodoItem } from '../lib/api'

const STATUS_COLORS: Record<string, string> = {
  pending: 'bg-slate-700 text-slate-300',
  in_progress: 'bg-blue-900/50 text-blue-300 border border-blue-700',
  completed: 'bg-emerald-900/50 text-emerald-300',
  cancelled: 'bg-red-900/30 text-red-400 line-through',
}

const PRIORITY_ICONS: Record<string, string> = {
  high: '\\u{1F534}',
  medium: '\\u{1F7E1}',
  low: '\\u{1F7E2}',
}

const STATUS_LABELS: Record<string, string> = {
  pending: '\\u{23F3} \\u5F85\\u529E',
  in_progress: '\\u{1F3C3} \\u8FDB\\u884C\\u4E2D',
  completed: '\\u2705 \\u5DF2\\u5B8C\\u6210',
  cancelled: '\\u274C \\u5DF2\\u53D6\\u6D88',
}

export default function TodosPage() {
  const [projectTodos, setProjectTodos] = useState<ProjectTodos[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [showAdd, setShowAdd] = useState(false)
  const [newTitle, setNewTitle] = useState('')
  const [newProject, setNewProject] = useState('')
  const [newPriority, setNewPriority] = useState('medium')
  const [newAssignee, setNewAssignee] = useState('')
  const [filter, setFilter] = useState<string>('all')

  const loadTodos = async () => {
    try {
      setLoading(true)
      const data = await fetchTodos()
      setProjectTodos(data)
      if (data.length > 0 && !newProject) {
        setNewProject(data[0].project)
      }
    } catch (err) {
      setError(String(err))
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => { loadTodos() }, [])

  const handleAdd = async () => {
    if (!newTitle.trim() || !newProject) return
    try {
      await addTodo(newProject, {
        title: newTitle.trim(),
        priority: newPriority,
        assignee: newAssignee || undefined,
      })
      setNewTitle('')
      setNewAssignee('')
      setShowAdd(false)
      loadTodos()
    } catch (err) {
      setError(String(err))
    }
  }

  const handleStatusChange = async (project: string, todoId: string, status: string) => {
    try {
      await updateTodoStatus(project, todoId, status)
      loadTodos()
    } catch (err) {
      setError(String(err))
    }
  }

  const handleDelete = async (project: string, todoId: string) => {
    try {
      await removeTodo(project, todoId)
      loadTodos()
    } catch (err) {
      setError(String(err))
    }
  }

  // Flatten and filter
  const allTodos: (TodoItem & { project: string })[] = projectTodos.flatMap(pt =>
    pt.todos.map(t => ({ ...t, project: pt.project }))
  )
  const filtered = filter === 'all' ? allTodos : allTodos.filter(t => t.status === filter)

  // Stats
  const stats = {
    total: allTodos.length,
    pending: allTodos.filter(t => t.status === 'pending').length,
    in_progress: allTodos.filter(t => t.status === 'in_progress').length,
    completed: allTodos.filter(t => t.status === 'completed').length,
  }

  if (loading) return <div className="text-slate-400 text-center py-12">\\u52A0\\u8F7D\\u4E2D...</div>
  if (error) return <div className="text-red-400 text-center py-12">{error}</div>

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-slate-50">\\u{1F4CB} \\u4EFB\\u52A1\\u770B\\u677F</h1>
          <p className="text-sm text-slate-400 mt-1">
            \\u5168\\u5C40 {stats.total} \\u4E2A\\u4EFB\\u52A1 \\u00B7 {stats.in_progress} \\u8FDB\\u884C\\u4E2D \\u00B7 {stats.pending} \\u5F85\\u529E \\u00B7 {stats.completed} \\u5DF2\\u5B8C\\u6210
          </p>
        </div>
        <button
          onClick={() => setShowAdd(!showAdd)}
          className="px-4 py-2 bg-blue-600 hover:bg-blue-500 text-white rounded-lg text-sm font-medium transition-colors"
        >
          + \\u65B0\\u589E\\u4EFB\\u52A1
        </button>
      </div>

      {/* Add form */}
      {showAdd && (
        <div className="bg-slate-800/50 border border-slate-700 rounded-lg p-4 space-y-3">
          <div className="flex gap-3">
            <select
              value={newProject}
              onChange={e => setNewProject(e.target.value)}
              className="bg-slate-900 border border-slate-700 rounded px-3 py-2 text-sm text-slate-200"
            >
              {projectTodos.map(pt => (
                <option key={pt.project} value={pt.project}>{pt.project}</option>
              ))}
            </select>
            <input
              value={newTitle}
              onChange={e => setNewTitle(e.target.value)}
              placeholder="\\u4EFB\\u52A1\\u6807\\u9898..."
              className="flex-1 bg-slate-900 border border-slate-700 rounded px-3 py-2 text-sm text-slate-200 placeholder-slate-500"
              onKeyDown={e => e.key === 'Enter' && handleAdd()}
            />
          </div>
          <div className="flex gap-3 items-center">
            <select
              value={newPriority}
              onChange={e => setNewPriority(e.target.value)}
              className="bg-slate-900 border border-slate-700 rounded px-3 py-2 text-sm text-slate-200"
            >
              <option value="high">\\u{1F534} \\u9AD8</option>
              <option value="medium">\\u{1F7E1} \\u4E2D</option>
              <option value="low">\\u{1F7E2} \\u4F4E</option>
            </select>
            <input
              value={newAssignee}
              onChange={e => setNewAssignee(e.target.value)}
              placeholder="\\u8D1F\\u8D23\\u4EBA (\\u53EF\\u9009)"
              className="bg-slate-900 border border-slate-700 rounded px-3 py-2 text-sm text-slate-200 placeholder-slate-500"
            />
            <button
              onClick={handleAdd}
              className="px-4 py-2 bg-emerald-600 hover:bg-emerald-500 text-white rounded text-sm font-medium"
            >
              \\u786E\\u8BA4\\u6DFB\\u52A0
            </button>
          </div>
        </div>
      )}

      {/* Filter tabs */}
      <div className="flex gap-2">
        {['all', 'pending', 'in_progress', 'completed', 'cancelled'].map(s => (
          <button
            key={s}
            onClick={() => setFilter(s)}
            className={`px-3 py-1.5 rounded-md text-xs font-medium transition-colors ${
              filter === s ? 'bg-slate-700 text-slate-100' : 'text-slate-400 hover:text-slate-200 hover:bg-slate-800/50'
            }`}
          >
            {s === 'all' ? `\\u5168\\u90E8 (${stats.total})` : `${STATUS_LABELS[s] || s} (${allTodos.filter(t => t.status === s).length})`}
          </button>
        ))}
      </div>

      {/* Todo list */}
      <div className="space-y-2">
        {filtered.length === 0 && (
          <div className="text-slate-500 text-center py-8">\\u6682\\u65E0\\u4EFB\\u52A1</div>
        )}
        {filtered.map(todo => (
          <div
            key={`${todo.project}-${todo.id}`}
            className={`flex items-center gap-3 px-4 py-3 rounded-lg ${STATUS_COLORS[todo.status] || 'bg-slate-800'}`}
          >
            <span className="text-sm">{PRIORITY_ICONS[todo.priority] || '\\u26AA'}</span>
            <div className="flex-1 min-w-0">
              <div className="text-sm font-medium truncate">{todo.title}</div>
              <div className="flex gap-2 mt-0.5">
                <span className="text-xs text-slate-500">{todo.project}</span>
                {todo.assignee && <span className="text-xs text-slate-400">@{todo.assignee}</span>}
                {todo.tags?.map(tag => (
                  <span key={tag} className="text-xs bg-slate-600/50 px-1.5 rounded">{tag}</span>
                ))}
              </div>
            </div>
            <select
              value={todo.status}
              onChange={e => handleStatusChange(todo.project, todo.id, e.target.value)}
              className="bg-transparent border border-slate-600 rounded px-2 py-1 text-xs text-slate-300"
            >
              <option value="pending">\\u5F85\\u529E</option>
              <option value="in_progress">\\u8FDB\\u884C\\u4E2D</option>
              <option value="completed">\\u5DF2\\u5B8C\\u6210</option>
              <option value="cancelled">\\u5DF2\\u53D6\\u6D88</option>
            </select>
            <button
              onClick={() => handleDelete(todo.project, todo.id)}
              className="text-slate-500 hover:text-red-400 text-sm"
              title="\\u5220\\u9664"
            >
              \\u{1F5D1}
            </button>
          </div>
        ))}
      </div>

      {/* Per-project summary */}
      <div className="mt-8">
        <h2 className="text-lg font-semibold text-slate-200 mb-3">\\u{1F4C1} \\u6309\\u9879\\u76EE</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
          {projectTodos.map(pt => (
            <div key={pt.project} className="bg-slate-800/50 border border-slate-700 rounded-lg p-3">
              <div className="font-medium text-slate-200 text-sm">{pt.project}</div>
              <div className="text-xs text-slate-500 mt-1">
                {pt.todos.length} \\u4E2A\\u4EFB\\u52A1 \\u00B7
                {pt.todos.filter(t => t.status === 'in_progress').length} \\u8FDB\\u884C\\u4E2D \\u00B7
                {pt.todos.filter(t => t.status === 'completed').length} \\u5DF2\\u5B8C\\u6210
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
"""

# 4. src/App.tsx - updated with todos route
app_content = """import { Routes, Route, Link, useLocation } from 'react-router-dom'
import HomePage from './pages/HomePage'
import TeamPage from './pages/TeamPage'
import AgentsPage from './pages/AgentsPage'
import TodosPage from './pages/TodosPage'

const navItems = [
  { path: '/', label: '\\u56E2\\u961F', icon: '\\u{1F3E0}' },
  { path: '/agents', label: '\\u89D2\\u8272', icon: '\\u{1F465}' },
  { path: '/todos', label: '\\u4EFB\\u52A1', icon: '\\u{1F4CB}' },
]

export default function App() {
  const location = useLocation()

  return (
    <div className="min-h-screen bg-slate-950">
      {/* Header */}
      <header className="border-b border-slate-800 bg-slate-950/80 backdrop-blur sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-6 h-14 flex items-center gap-8">
          <Link to="/" className="flex items-center gap-2 text-lg font-semibold text-slate-50">
            <span>\\u{1F3EF}</span>
            <span>\\u7EF4\\u5F08\\u9601 Dashboard</span>
          </Link>

          <nav className="flex gap-1">
            {navItems.map(item => {
              const isActive = item.path === '/'
                ? location.pathname === '/'
                : location.pathname.startsWith(item.path)
              return (
                <Link
                  key={item.path}
                  to={item.path}
                  className={`px-3 py-1.5 rounded-md text-sm transition-colors ${
                    isActive
                      ? 'bg-slate-800 text-slate-50'
                      : 'text-slate-400 hover:text-slate-200 hover:bg-slate-800/50'
                  }`}
                >
                  {item.icon} {item.label}
                </Link>
              )
            })}
          </nav>
        </div>
      </header>

      {/* Main */}
      <main className="max-w-7xl mx-auto px-6 py-6">
        <Routes>
          <Route path="/" element={<HomePage />} />
          <Route path="/team/:name" element={<TeamPage />} />
          <Route path="/agents" element={<AgentsPage />} />
          <Route path="/todos" element={<TodosPage />} />
        </Routes>
      </main>
    </div>
  )
}
"""

# Write all files
pathlib.Path(f'{base}/server/index.ts').write_text(index_content)
pathlib.Path(f'{base}/src/lib/api.ts').write_text(api_content)
pathlib.Path(f'{base}/src/pages/TodosPage.tsx').write_text(todos_page)
pathlib.Path(f'{base}/src/App.tsx').write_text(app_content)

print('DONE: All dashboard files written')
print(f'  - {base}/server/index.ts')
print(f'  - {base}/src/lib/api.ts')
print(f'  - {base}/src/pages/TodosPage.tsx')
print(f'  - {base}/src/App.tsx')