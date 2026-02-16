const Database = require('better-sqlite3');
const path = require('path');

const db = new Database(path.join(__dirname, 'easy2work.db'));

// Create tables
db.exec(`
  CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT NOT NULL,
    address TEXT,
    password TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  );

  CREATE TABLE IF NOT EXISTS engineers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT NOT NULL,
    area TEXT,
    specialization TEXT,
    password TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  );

  CREATE TABLE IF NOT EXISTS admin (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL
  );

  CREATE TABLE IF NOT EXISTS complaints (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    service_type TEXT NOT NULL,
    description TEXT NOT NULL,
    address TEXT,
    status TEXT DEFAULT 'Pending',
    engineer_id INTEGER,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (engineer_id) REFERENCES engineers(id)
  );
`);

// Add area column to engineers if table already existed without it
try { db.exec('ALTER TABLE engineers ADD COLUMN area TEXT'); } catch (e) { /* column exists */ }

const bcrypt = require('bcryptjs');

// Insert default admin if not exists
const adminCount = db.prepare('SELECT COUNT(*) as c FROM admin').get();
if (adminCount.c === 0) {
  const hash = bcrypt.hashSync('admin123', 10);
  db.prepare('INSERT INTO admin (email, password) VALUES (?, ?)').run('admin@easy2work.com', hash);
}

// Default User (Customer) – login: user@easy2work.com / user123
const defUser = db.prepare('SELECT id FROM users WHERE email = ?').get('user@easy2work.com');
if (!defUser) {
  const hash = bcrypt.hashSync('user123', 10);
  db.prepare('INSERT INTO users (name, email, phone, address, password) VALUES (?, ?, ?, ?, ?)')
    .run('Test User', 'user@easy2work.com', '9876543210', 'Varanasi', hash);
}

// Default Engineer – login: engineer@easy2work.com / engineer123
const defEng = db.prepare('SELECT id FROM engineers WHERE email = ?').get('engineer@easy2work.com');
if (!defEng) {
  const hash = bcrypt.hashSync('engineer123', 10);
  db.prepare('INSERT INTO engineers (name, email, phone, area, specialization, password) VALUES (?, ?, ?, ?, ?, ?)')
    .run('Test Engineer', 'engineer@easy2work.com', '9123456789', 'Varanasi', 'Electrical, AC', hash);
}

module.exports = db;
