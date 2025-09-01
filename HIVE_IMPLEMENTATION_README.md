# Hive Database Implementation - Agenda App

This document outlines the complete Hive database implementation that provides local storage alternatives to Firebase-based pages in the Agenda app.

## Overview

The Hive implementation provides parallel functionality to the existing Firebase pages, allowing users to choose between cloud storage (Firebase) and local storage (Hive) while maintaining identical UI/UX and functionality.

## Architecture

### Naming Convention
- All Hive pages follow the pattern: `[OriginalName]Hive` or are placed in the `hive/` directory
- Hive models use the suffix `Hive` (e.g., `TaskModelHive`)
- Clear separation between Firebase and Hive implementations

### Directory Structure
```
lib/layers/presentation/pages/hive/
├── add/
│   └── add_hive_page.dart
├── auth/
│   ├── login_hive_page.dart (planned)
│   └── register_hive_page.dart (planned)
├── debts/
│   ├── add_debt_page.dart (existing)
│   ├── debts_list_page.dart (existing)
│   └── detail/
├── search/
│   └── search_hive_page.dart
├── settings/
│   └── settings_hive_page.dart
├── tasks/
│   ├── add_task_hive_page.dart
│   ├── task_detail_hive_page.dart
│   └── task_list_hive_page.dart
├── home_page.dart (existing)
└── home_screen_hive_page.dart

lib/layers/domain/models/hive_model/
├── debts/
│   ├── debts_model.dart (existing)
│   └── debts_model.g.dart (existing)
├── tasks/
│   ├── task_model_hive.dart
│   └── task_model_hive.g.dart (generated)
└── vois_recording_model/ (existing)
```

## Implemented Pages

### 1. Task Management (NEW)
- **TaskListHiveScreenPage**: Local version of task list with filtering and quick add
- **AddTaskHivePage**: Add new tasks with priority selection and date picker
- **TaskDetailHivePage**: View, edit, and delete task details
- **Models**: `TaskModelHive`, `TaskTypeModelHive`

### 2. Home Dashboard (NEW)
- **HomeScreenHivePage**: Main dashboard showing recent tasks and debts
- **Features**: Quick actions, recent items display, navigation to all sections

### 3. Search Functionality (NEW)
- **SearchHivePage**: Search through tasks and debts stored locally
- **Features**: Real-time search, categorized results, navigation to details

### 4. Add Functionality (NEW)
- **AddHivePage**: Universal add page for both tasks and debts
- **Features**: Dynamic form based on content type, validation, date pickers

### 5. Settings (NEW)
- **SettingsHivePage**: App settings and data management
- **Features**: Language selection, theme toggle, data clearing options

### 6. Debt Management (EXISTING - Enhanced)
- **DebtsListPage**: Existing Hive implementation for debt management
- **AddDebtPage**: Existing Hive implementation for adding debts
- **Models**: `DebtsModel`, `DebtsDetailModel` (existing)

## Data Models

### TaskModelHive
```dart
@HiveType(typeId: 2)
class TaskModelHive extends HiveObject {
  @HiveField(0) String task;
  @HiveField(1) String docId;
  @HiveField(2) DateTime date;
  @HiveField(3) String priority;
  @HiveField(4) String? description;
  @HiveField(5) String? image;
  @HiveField(6) int status;
}
```

### TaskTypeModelHive
```dart
@HiveType(typeId: 3)
class TaskTypeModelHive extends HiveObject {
  @HiveField(0) String name;
  @HiveField(1) String docId;
  @HiveField(2) DateTime date;
  @HiveField(3) String? description;
}
```

## Key Features

### 1. Offline Functionality
- All data stored locally using Hive
- No internet connection required
- Fast data access and operations

### 2. Data Persistence
- Automatic data saving
- Crash-resistant storage
- Efficient memory usage

### 3. Migration Support
- Methods to convert between Firebase and Hive models
- `fromFirebaseModel()` factory constructors
- Compatible JSON serialization

### 4. Identical UI/UX
- Same visual design as Firebase versions
- Identical user interactions
- Consistent navigation patterns

## Setup and Configuration

### 1. Hive Registration (main.dart)
```dart
void main() async {
  await Hive.initFlutter();
  
  // Register adapters
  Hive.registerAdapter(TaskModelHiveAdapter());
  Hive.registerAdapter(TaskTypeModelHiveAdapter());
  Hive.registerAdapter(DebtsModelAdapter());
  Hive.registerAdapter(DebtsDetailModelAdapter());
  
  // Open boxes
  await Hive.openBox<TaskModelHive>('tasksHiveBox');
  await Hive.openBox<TaskTypeModelHive>('taskTypesHiveBox');
  await Hive.openBox<DebtsModel>('debtsBox');
}
```

### 2. Code Generation
Run the following command to generate Hive adapters:
```bash
flutter packages pub run build_runner build
```

## Usage Examples

### Adding a Task
```dart
final box = await Hive.openBox<TaskModelHive>('tasksHiveBox');
final task = TaskModelHive(
  task: 'Complete project',
  date: DateTime.now(),
  priority: 'High',
  docId: uuid.v4(),
);
await box.add(task);
```

### Querying Tasks
```dart
final box = Hive.box<TaskModelHive>('tasksHiveBox');
final allTasks = box.values.toList();
final completedTasks = allTasks.where((task) => task.status == 1).toList();
```

### Updating a Task
```dart
task.status = 1; // Mark as completed
await task.save();
```

## Navigation Between Storage Types

### Storage Selection Page
A dedicated page (`StorageSelectionPage`) allows users to choose between:
- **Firebase (Cloud)**: Sync across devices, requires internet
- **Hive (Local)**: Offline access, faster performance

### Switching Storage Types
Users can switch between storage types through:
1. Initial app setup
2. Settings page
3. Direct navigation to specific implementations

## Performance Benefits

### Hive Advantages
- **Speed**: Direct local access, no network latency
- **Offline**: Works without internet connection
- **Efficiency**: Minimal memory footprint
- **Reliability**: No dependency on external services

### Use Cases
- **Offline environments**: Areas with poor connectivity
- **Privacy-focused users**: Data stays on device
- **Performance-critical scenarios**: Real-time data access
- **Development/testing**: No Firebase setup required

## Future Enhancements

### Planned Features
1. **Authentication**: Local user management with SharedPreferences
2. **Data Export**: Export Hive data to JSON/CSV
3. **Data Import**: Import from Firebase or other sources
4. **Backup/Restore**: Local backup functionality
5. **Sync Options**: Optional Firebase sync for Hive data

### Migration Tools
- Utilities to migrate data between Firebase and Hive
- Bulk import/export functionality
- Data validation and integrity checks

## Testing

### Unit Tests
- Test Hive model serialization/deserialization
- Validate CRUD operations
- Test data integrity

### Integration Tests
- Test complete user workflows
- Validate UI interactions
- Test offline scenarios

## Maintenance

### Code Generation
Remember to run build_runner after modifying Hive models:
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Box Management
- Properly close boxes when not needed
- Handle box initialization errors
- Monitor storage usage

## Conclusion

The Hive implementation provides a complete local storage alternative to Firebase, maintaining feature parity while offering offline capabilities and improved performance. Users can seamlessly choose between cloud and local storage based on their needs and preferences.
