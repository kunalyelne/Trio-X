# Trio-X: macOS Security Utility Application

Trio-X is a macOS application written in Swift, providing essential security-related functionality such as process monitoring, file integrity checks, and process termination with elevated privileges. It demonstrates critical macOS security concepts, Swift best practices, and the use of elevated privileges via the `ServiceManagement` framework.

## Features

### 1. Process Monitoring
The app lists all running processes, including their Process ID (PID) and name, using the `ps` command. It includes functionality to retrieve the appropriate app icon for each process. The `fetchRunningProcesses()` method manages the retrieval of process details, while `getAppIcon(forPID:)` assigns icons.

### 2. File Integrity Check
The app monitors specified directories for real-time file system changes, such as file creation, modification, deletion, or renaming. The `FileMonitor` class, using the `FSEventStream` API, logs all detected changes along with a timestamp and detailed event description.

### 3. Process Termination with Elevated Privileges
The app enables the termination of processes by PID with the help of the `ServiceManagement` framework and the `PrivilegedHelperTools` helper tool. Elevated privileges are securely handled using `SMAppService`. The app requests these privileges only when required, and the helper tool ensures the correct permissions are granted to perform privileged actions.

## Key Security Considerations
- **Elevated Privileges with `SMAppService`**: The app uses `SMAppService` and `ServiceManagement` to securely handle privilege escalation when terminating processes. The helper tool, `PrivilegedHelperTools`, manages the necessary root-level access.
- **Sandboxing**: For security reasons, the sandbox has been disabled for both the main app and the helper tool to allow proper functioning of the elevated privilege requests.
- **File Integrity Monitoring**: The app logs real-time file system changes to detect unauthorized modifications quickly.
- **Error Handling**: Comprehensive error handling ensures smooth execution, particularly for privilege escalation and process termination.

## Usage

1. **Process Monitoring**:
   - Call `fetchRunningProcesses()` to retrieve and list the active processes, including their PID and name.

2. **File Integrity Check**:
   - Use `FileMonitor(path: "path/to/directory")` to monitor a directory. Changes will be logged with timestamps and event details.

3. **Process Termination**:
   - Use `terminateProcess(pid: <process_id>)` to terminate a process by PID. This action requires elevated privileges, handled via the helper tool `PrivilegedHelperTools`.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/kunalyelne/Trio-X.git

2.	Open the project in Xcode.
3.	Build and run the application. Ensure sandboxing is disabled for both the main app and the helper tool to allow for privilege escalation.
