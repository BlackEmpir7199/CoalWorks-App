# CoalWorks-App

## Overview

CoalWorks-App is a mobile application designed to digitize and streamline operational processes in coal mining, with a particular focus on shift handover, safety management, and incident reporting. Tailored for Indian coal mining operations, this app aims to enhance productivity, ensure safety, and maintain seamless communication across shifts.

## Features

### 1. Dashboard
- Shift Summary Card
- Real-time Safety Alerts
- Quick Navigation to key features

### 2. Shift Handover Log
- Digital log entry for shift activities
- Automated shift summary generation
- Critical issue alerts for incoming shifts

### 3. Safety Management Plan (SMP)
- Digitized safety protocols
- Interactive safety checklists
- Hazard reporting tool

### 4. Incident Reporting
- Structured incident reporting form
- Real-time alerts to relevant personnel
- Photo evidence upload capability

### 5. Notifications
- Push notifications for critical updates
- Consolidated notification center

### 6. Profile and Settings
- User profile management
- App settings and preferences

## Technical Stack

### Mobile App
- **Framework**: Flutter (cross-platform development)
- **State Management**: BLoC (Business Logic Component)
- **Local Storage**: SQLite (offline capabilities)
- **Backend Integration**: HTTP / Dio (API calls)
- **UI Design**: Flutter Widgets (responsive UI components)

### Backend and Cloud Services
- Firebase or AWS for real-time data synchronization and storage

## Security Features
- Data encryption using SSL/TLS protocols
- Multi-factor authentication (MFA)
- Secure local data storage

## Offline Functionality
- SQLite for local data storage
- Background syncing mechanism

## Installation

1. **Prerequisites**:
   - Install [Flutter](https://flutter.dev/docs/get-started/install) on your development machine.
   - Set up an Android or iOS device/emulator for testing.

2. **Clone the repository**:
   ```
   git clone https://github.com/BlackEmpir7199/CoalWorks-App.git
   cd CoalWorks-App
   ```

3. **Install dependencies**:
   ```
   flutter pub get
   ```

4. **Run the app**:
   - For debugging:
     ```
     flutter run
     ```
   - To build a release version:
     ```
     flutter build apk  # For Android
     flutter build ios  # For iOS
     ```

## Usage

1. **Launch the app** on your device or emulator.

2. **Log in** using your credentials. If you don't have an account, contact your system administrator.

3. **Dashboard**: Upon logging in, you'll see the main dashboard with a shift summary and quick access to key features.

4. **Shift Handover**:
   - At the start of your shift, review the previous shift's handover log.
   - During your shift, log important events, issues, or completed tasks.
   - At the end of your shift, generate a shift summary for the next team.

5. **Safety Management**:
   - Access safety protocols and checklists from the SMP section.
   - Complete required safety checks before starting work.
   - Report any hazards immediately using the hazard reporting tool.

6. **Incident Reporting**:
   - In case of an incident, use the incident reporting form to log details.
   - Attach photos or additional evidence as needed.

7. **Offline Mode**:
   - The app will function offline, storing data locally.
   - Once back online, data will automatically sync with the server.

8. **Settings**:
   - Customize app settings and notifications in the Profile section.

Remember to always prioritize safety and follow all mining regulations while using the app.

---

Developed with ❤️ by Team Arize - CoalWorks
