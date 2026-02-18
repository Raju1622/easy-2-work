const express = require('express');
const path = require('path');
const session = require('express-session');
const bcrypt = require('bcryptjs');
const db = require('./db');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(session({
  secret: 'easy2work-secret-key',
  resave: false,
  saveUninitialized: false,
  cookie: { maxAge: 24 * 60 * 60 * 1000, sameSite: 'lax', path: '/' }
}));
app.use(express.static(path.join(__dirname, 'public')));

// Auth middleware (API calls get 401 JSON, page requests get redirect)
const requireUser = (req, res, next) => {
  if (req.session.user) return next();
  if (req.path.startsWith('/api/')) return res.status(401).json({ error: 'Login required' });
  res.redirect('/login.html');
};
const requireAdmin = (req, res, next) => {
  if (req.session.admin) return next();
  if (req.path.startsWith('/api/')) return res.status(401).json({ error: 'Admin login required' });
  res.redirect('/');
};
const requireEngineer = (req, res, next) => {
  if (req.session.engineer) return next();
  if (req.path.startsWith('/api/')) return res.status(401).json({ error: 'Engineer login required' });
  res.redirect('/');
};

// ========== USER AUTH ==========
app.post('/api/register', (req, res) => {
  const { name, email, phone, address, password } = req.body;
  if (!name || !email || !phone || !password) {
    return res.status(400).json({ error: 'Name, email, phone and password required' });
  }
  const hash = bcrypt.hashSync(password, 10);
  try {
    db.prepare('INSERT INTO users (name, email, phone, address, password) VALUES (?, ?, ?, ?, ?)')
      .run(name, email, phone, address || '', hash);
    res.json({ success: true });
  } catch (e) {
    if (e.message.includes('UNIQUE')) res.status(400).json({ error: 'Email already registered' });
    else res.status(500).json({ error: 'Registration failed' });
  }
});

app.post('/api/login', (req, res) => {
  const email = req.body && (req.body.email + '').trim();
  const password = req.body && req.body.password;
  if (!email || !password) return res.status(400).json({ error: 'Email and password required' });
  const user = db.prepare('SELECT * FROM users WHERE email = ?').get(email);
  if (!user || !bcrypt.compareSync(password, user.password)) {
    return res.status(401).json({ error: 'Invalid email or password' });
  }
  req.session.user = { id: user.id, name: user.name, email: user.email };
  res.json({ success: true });
});

// ----- Form POST login (full page submit – cookie works reliably) -----
app.post('/login', (req, res) => {
  const email = (req.body && req.body.email || '').trim();
  const password = req.body && req.body.password;
  if (!email || !password) return res.redirect('/login.html?error=1');
  const user = db.prepare('SELECT * FROM users WHERE email = ?').get(email);
  if (!user || !bcrypt.compareSync(password, user.password)) return res.redirect('/login.html?error=1');
  req.session.user = { id: user.id, name: user.name, email: user.email };
  res.redirect('/user-dashboard');
});

// ========== ADMIN AUTH (API – keep for any future use) ==========
app.post('/api/admin/login', (req, res) => {
  const email = req.body && (req.body.email + '').trim();
  const password = req.body && req.body.password;
  if (!email || !password) return res.status(400).json({ error: 'Email and password required' });
  const admin = db.prepare('SELECT * FROM admin WHERE email = ?').get(email);
  if (!admin || !bcrypt.compareSync(password, admin.password)) {
    return res.status(401).json({ error: 'Invalid credentials' });
  }
  req.session.admin = { id: admin.id, email: admin.email };
  res.json({ success: true });
});

// ========== ENGINEER AUTH (API) ==========
app.post('/api/engineer/login', (req, res) => {
  const email = req.body && (req.body.email + '').trim();
  const password = req.body && req.body.password;
  if (!email || !password) return res.status(400).json({ error: 'Email and password required' });
  const eng = db.prepare('SELECT * FROM engineers WHERE email = ?').get(email);
  if (!eng || !bcrypt.compareSync(password, eng.password)) {
    return res.status(401).json({ error: 'Invalid email or password' });
  }
  req.session.engineer = { id: eng.id, name: eng.name, email: eng.email };
  res.json({ success: true });
});

// ========== COMPLAINTS (User) ==========
app.post('/api/complaints', requireUser, (req, res) => {
  const { service_type, description, address } = req.body;
  if (!service_type || !description) return res.status(400).json({ error: 'Service type and description required' });
  db.prepare('INSERT INTO complaints (user_id, service_type, description, address, status) VALUES (?, ?, ?, ?, ?)')
    .run(req.session.user.id, service_type, description, address || '', 'Approved');
  res.json({ success: true });
});

app.get('/api/me', (req, res) => {
  if (req.session.user) return res.json({ role: 'user', name: req.session.user.name });
  if (req.session.engineer) return res.json({ role: 'engineer', name: req.session.engineer.name });
  res.status(401).json({ error: 'Not logged in' });
});

app.get('/api/my-complaints', requireUser, (req, res) => {
  const rows = db.prepare(`
    SELECT c.*, e.name as engineer_name, e.phone as engineer_phone
    FROM complaints c LEFT JOIN engineers e ON c.engineer_id = e.id
    WHERE c.user_id = ? ORDER BY c.created_at DESC
  `).all(req.session.user.id);
  res.json(rows);
});

// ========== ADMIN APIs ==========
app.get('/api/admin/users', requireAdmin, (req, res) => {
  const rows = db.prepare('SELECT id, name, email, phone, address, created_at FROM users ORDER BY created_at DESC').all();
  res.json(rows);
});

app.get('/api/admin/engineers', requireAdmin, (req, res) => {
  const rows = db.prepare('SELECT id, name, email, phone, area, specialization, created_at FROM engineers ORDER BY name').all();
  res.json(rows);
});

app.post('/api/admin/engineers', requireAdmin, (req, res) => {
  const { name, email, phone, area, specialization, password } = req.body;
  if (!name || !email || !phone || !password) return res.status(400).json({ error: 'Required fields missing' });
  const hash = bcrypt.hashSync(password, 10);
  try {
    db.prepare('INSERT INTO engineers (name, email, phone, area, specialization, password) VALUES (?, ?, ?, ?, ?, ?)')
      .run(name, email, phone, area || '', specialization || '', hash);
    res.json({ success: true });
  } catch (e) {
    if (e.message.includes('UNIQUE')) res.status(400).json({ error: 'Email already exists' });
    else res.status(500).json({ error: 'Failed' });
  }
});

app.get('/api/admin/complaints', requireAdmin, (req, res) => {
  const rows = db.prepare(`
    SELECT c.*, u.name as user_name, u.phone as user_phone, u.address as user_address, e.name as engineer_name
    FROM complaints c
    JOIN users u ON c.user_id = u.id
    LEFT JOIN engineers e ON c.engineer_id = e.id
    ORDER BY c.created_at DESC
  `).all();
  res.json(rows);
});

app.get('/api/admin/stats', requireAdmin, (req, res) => {
  const users = db.prepare('SELECT COUNT(*) as c FROM users').get();
  const engineers = db.prepare('SELECT COUNT(*) as c FROM engineers').get();
  const complaints = db.prepare('SELECT COUNT(*) as c FROM complaints').get();
  const pending = db.prepare('SELECT COUNT(*) as c FROM complaints WHERE status = ?').get('Pending');
  const approved = db.prepare('SELECT COUNT(*) as c FROM complaints WHERE status = ?').get('Approved');
  const completed = db.prepare('SELECT COUNT(*) as c FROM complaints WHERE status = ?').get('Completed');
  res.json({ users: users.c, engineers: engineers.c, complaints: complaints.c, pending: pending.c, approved: approved.c, completed: completed.c });
});

// Admin can only VIEW and DELETE (no approve).
app.delete('/api/admin/users/:id', requireAdmin, (req, res) => {
  const id = req.params.id;
  db.prepare('DELETE FROM complaints WHERE user_id = ?').run(id);
  db.prepare('DELETE FROM users WHERE id = ?').run(id);
  res.json({ success: true });
});
app.delete('/api/admin/engineers/:id', requireAdmin, (req, res) => {
  const id = req.params.id;
  db.prepare('UPDATE complaints SET engineer_id = NULL WHERE engineer_id = ?').run(id);
  db.prepare('DELETE FROM engineers WHERE id = ?').run(id);
  res.json({ success: true });
});
app.delete('/api/admin/complaints/:id', requireAdmin, (req, res) => {
  db.prepare('DELETE FROM complaints WHERE id = ?').run(req.params.id);
  res.json({ success: true });
});

// ========== ENGINEER APIs ==========
// Available jobs: Approved complaints (no engineer assigned). Optional: filter by engineer's area for "nearby".
app.get('/api/engineer/available-jobs', requireEngineer, (req, res) => {
  const eng = db.prepare('SELECT area FROM engineers WHERE id = ?').get(req.session.engineer.id);
  const rows = db.prepare(`
    SELECT c.*, u.name as user_name, u.phone as user_phone, u.address as user_address
    FROM complaints c JOIN users u ON c.user_id = u.id
    WHERE c.status = ? AND (c.engineer_id IS NULL OR c.engineer_id = 0)
    ORDER BY c.created_at DESC
  `).all('Approved');
  res.json(rows);
});

app.post('/api/engineer/accept-job', requireEngineer, (req, res) => {
  const { complaint_id } = req.body;
  if (!complaint_id) return res.status(400).json({ error: 'complaint_id required' });
  const r = db.prepare('UPDATE complaints SET engineer_id = ?, status = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ? AND status = ? AND (engineer_id IS NULL OR engineer_id = 0)')
    .run(req.session.engineer.id, 'Assigned', complaint_id, 'Approved');
  if (r.changes === 0) return res.status(400).json({ error: 'Job not available or already taken' });
  res.json({ success: true });
});

app.get('/api/engineer/tasks', requireEngineer, (req, res) => {
  const rows = db.prepare(`
    SELECT c.*, u.name as user_name, u.phone as user_phone, u.address as user_address
    FROM complaints c JOIN users u ON c.user_id = u.id
    WHERE c.engineer_id = ? ORDER BY c.created_at DESC
  `).all(req.session.engineer.id);
  res.json(rows);
});

app.post('/api/engineer/update-status', requireEngineer, (req, res) => {
  const { complaint_id, status } = req.body;
  if (!complaint_id || !status) return res.status(400).json({ error: 'complaint_id and status required' });
  const allowed = ['Assigned', 'In Progress', 'Completed'];
  if (!allowed.includes(status)) return res.status(400).json({ error: 'Invalid status' });
  db.prepare('UPDATE complaints SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ? AND engineer_id = ?')
    .run(status, complaint_id, req.session.engineer.id);
  res.json({ success: true });
});

// ========== LOGOUT ==========
app.post('/api/logout', (req, res) => {
  req.session.destroy();
  res.json({ success: true });
});

app.post('/api/admin/logout', (req, res) => {
  req.session.destroy();
  res.json({ success: true });
});

// Serve HTML
app.get('/', (req, res) => res.sendFile(path.join(__dirname, 'public', 'index.html')));
app.get('/login', (req, res) => res.sendFile(path.join(__dirname, 'public', 'login.html')));
app.get('/register', (req, res) => res.sendFile(path.join(__dirname, 'public', 'register.html')));
app.get('/user-dashboard', requireUser, (req, res) => res.sendFile(path.join(__dirname, 'public', 'user-dashboard.html')));

app.listen(PORT, () => console.log(`Easy 2 Work server running at http://localhost:${PORT}`));
