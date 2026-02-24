# Easy 2 Work – Flutter App

User + Worker app for the Easy 2 Work on-demand home service platform.

## Setup

1. **Generate platform folders** (first time only):
   ```bash
   flutter create .
   ```
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Run:**
   ```bash
   flutter run
   ```

## Structure

- `lib/core/` – Constants, app config
- `lib/auth/` – Login, registration
- `lib/user/` – User: services, cart, track booking
- `lib/worker/` – Worker: jobs, accept, navigate
- `lib/shared/` – Shared widgets and utilities

Uncomment packages in `pubspec.yaml` when you add Firebase, maps, payments, etc.
