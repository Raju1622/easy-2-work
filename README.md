# Easy 2 Work – On-Demand Home Service

Web-based application for managing home maintenance services (electrical repair, AC servicing, cooler repair, appliance troubleshooting). Customers register complaints, admins assign engineers, and engineers update service status in real time.

Based on the project synopsis: **Mahadev P.G. College, Bariyasanpur, Varanasi** | BCA Session 2025–2026 | Sadanand Maurya.

## Features

- **User (Customer):** Register, login, submit service complaints, track status
- **Admin:** Manage users, add engineers, view all complaints, assign engineer to complaints
- **Engineer:** Login, view assigned tasks, update status (In Progress / Completed)

## Tech Stack

- **Frontend:** HTML, CSS, Bootstrap 5, JavaScript
- **Backend:** Node.js, Express
- **Database:** SQLite (file: `easy2work.db`)

## Run the website

```bash
npm install
npm start
```

Open **http://localhost:3000** in the browser.

## Login credentials (test / default)

| Role     | Email                 | Password    |
|----------|------------------------|-------------|
| **Admin**    | admin@easy2work.com    | admin123    |
| **User**     | user@easy2work.com     | user123     |
| **Engineer** | engineer@easy2work.com | engineer123 |

(Change these in production.)

## Project structure

```
├── server.js          # Express server & API
├── db.js              # SQLite DB setup & tables
├── package.json
├── public/
│   ├── css/style.css
│   ├── index.html           # Landing
│   ├── register.html        # Customer register
│   ├── login.html           # Customer login
│   ├── admin-login.html
│   ├── engineer-login.html
│   ├── user-dashboard.html  # Submit complaint, my complaints
│   ├── admin-dashboard.html # Users, engineers, assign
│   └── engineer-dashboard.html # My tasks, update status
└── README.md
```

## Service types

- Electrical Repair  
- AC Servicing  
- Cooler Repair  
- Appliance Repair  

Complaint status flow: **Pending** → **Assigned** → **In Progress** → **Completed**.
