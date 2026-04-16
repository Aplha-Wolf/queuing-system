# Queuing System

A modern queuing system application built with Gleam, featuring a web-based interface for managing customer queues in retail, banking, healthcare, and other service environments.

[![Gleam](https://img.shields.io/badge/Gleam-1.x-orange)](https://gleam.run)
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache--2.0-green)](LICENSE)

## Repository

- **Main**: [https://codeberg.org/wolfbyte/queuing-system](https://codeberg.org/wolfbyte/queuing-system)
- **Mirror**: [https://github.com/Aplha-Wolf/queuing-system](https://github.com/Aplha-Wolf/queuing-system)

## Features

- **Terminal** - Take tickets and get your queue number
- **Frontdesk** - Call and manage the queue (for staff)
- **Display** - Show current ticket number to waiting customers
- **Settings** - Configure themes and system preferences
- RESTful API with comprehensive endpoints
- Customizable themes and visual appearance
- Real-time queue management

## Technology Stack

- **Language**: [Gleam](https://gleam.run) - A friendly language for building type-safe systems
- **Frontend**: [Lustre](https://lustre.dev) - A Gleam web framework (like React, but functional!)
- **Backend**: [Wisp](https://github.com/wisp-sys/wisp) + [Mist](https://github.com/ritschwumm/mist) - Gleam web server
- **Database**: PostgreSQL (via [Pog](https://github.com/beta-team/pog))
- **Key Libraries**: gleam_stdlib, gleam_json, gleam_http, storail, envoy, simplifile

## Prerequisites

Before running the project, make sure you have:

- **Erlang/OTP** - The Erlang runtime
- **Gleam** (version 1.x) - Install via: `brew install gleam` (macOS) or follow the [official guide](https://gleam.run/getting-started/installing/)
- **PostgreSQL** (version 14+ recommended) - A running PostgreSQL instance
- **Bun** (optional) - For faster frontend development

## Project Structure

```
queuing-system/
├── client/      # Web UI built with Lustre
├── server/      # Backend API server
├── shared/     # Shared types between client and server
└── .env        # Environment configuration file
```

## Installation & Running

### 1. Install Dependencies

```bash
# Navigate to the client directory and install dependencies
cd client
gleam deps download

# Navigate to the server directory and install dependencies
cd ../server
gleam deps download
```

### 2. Set Up the Database

Create a PostgreSQL database named `queuing_system`:

```sql
CREATE DATABASE queuing_system;
```

Then update the `.env` file in the server directory with your database credentials:

```env
DATABASE_URL="postgres://username:password@localhost:5432/queuing_system"
```

### 3. Build the Client

The client compiles to the server's `priv` directory:

```bash
cd ../client
gleam build
```

### 4. Run the Server

```bash
cd ../server
gleam run
```

### 5. Access the Application

Open your browser and navigate to:

```
http://localhost:3001
```

## API Endpoints

The server provides a RESTful API at `http://localhost:3001/api`. Here are the main endpoints:

### Terminals

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/terminals` | List all terminals |
| POST | `/api/terminals` | Create a new terminal |
| GET | `/api/terminals/:id` | Get terminal by ID |
| PUT | `/api/terminals/:id` | Update a terminal |
| DELETE | `/api/terminals/:id` | Delete a terminal |

### Queues

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/queues/terminals/:code` | Get all queues for a terminal |
| POST | `/api/queues/next/:terminal_id` | Get the next queue item |
| POST | `/api/queues` | Add a new queue item |

### Frontdesk

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/frontdesk/:terminal_code` | Get frontdesk info for terminal |
| POST | `/api/frontdesk/call/:queue_id` | Call the next customer |
| POST | `/api/frontdesk/complete/:queue_id` | Mark ticket as served |

### Displays

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/displays/:terminal_code` | Get display info |
| GET | `/api/displays/current/:terminal_code` | Get current ticket |

### Settings & Themes

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/settings` | Get all settings |
| PUT | `/api/settings/:key` | Update a setting |
| GET | `/api/themes` | List themes |
| POST | `/api/themes` | Create a theme |

### Media

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/medias/:filename` | Get media file |

## Development

### Running Tests

```bash
# Run tests for the server
cd server
gleam test

# Run tests for the client
cd ../client
gleam test

# Run tests for shared
cd ../shared
gleam test
```

### Building

```bash
# Build the entire project
cd client && gleam build
cd server && gleam build
```

### Running in Development

For faster development with hot reloading on the client:

```bash
cd client
gleam run --watch
```

## Application Routes

Once the server is running, you can access these pages in your browser:

| Path | Description |
|------|-------------|
| `/` | Home page |
| `/settings` | Settings and configuration |
| `/terminal/:code` | Take a ticket (for customers) |
| `/frontdesk/:code` | Manage queue (for staff) |
| `/display/:code` | Display current ticket (for screens) |

Replace `:code` with your terminal code (e.g., `/terminal/main`).

## Database Schema Overview

The application uses the following main tables:

- **terminal** - Terminal configurations (code, name, active status)
- **queue** - Queue items (label, status, priority, timestamps)
- **quetype** - Queue types (different service types)
- **priority** - Priority levels for queue items
- **settings** - System settings (key-value pairs)
- **themes** - Theme configurations (colors, styling)
- **display_terminal** - Display terminal mappings
- **frontdesk** - Frontdesk configurations

## Troubleshooting

### Database Connection Issues

If you get a database connection error:
1. Make sure PostgreSQL is running
2. Check your `.env` file has the correct `DATABASE_URL`
3. Ensure the database `queuing_system` exists

### Port Already in Use

If port 3001 is already in use, you can change it in `server/src/server.gleam`:

```gleam
|> mist.port(3002)  // Change to desired port
```

### Build Errors

If you encounter build errors:
1. Make sure all dependencies are installed: `gleam deps download`
2. Clean and rebuild: `gleam clean && gleam build`

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## License

Licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

Built with these amazing Gleam libraries:
- [Lustre](https://lustre.dev) - Web UI framework
- [Wisp](https://github.com/wisp-sys/wisp) - HTTP server
- [Mist](https://github.com/ritschwumm/mist) - HTTP adapter
- [Pog](https://github.com/beta-team/pog) - PostgreSQL driver
- [Storail](https://github.com/storail/storail) - Storage utilities

---

Made with Gleam