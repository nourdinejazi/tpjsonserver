import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tpjsonserver/controllers/room_controller.dart';
import 'package:tpjsonserver/models/class.dart';
import 'package:tpjsonserver/models/room.dart';
import 'package:tpjsonserver/models/subject.dart';
import 'package:tpjsonserver/models/teacher.dart';
import 'package:tpjsonserver/screens/login_screen.dart';
import 'package:tpjsonserver/screens/splash_screen.dart';
import 'package:tpjsonserver/services/auth_service.dart';
import 'package:tpjsonserver/services/class_service.dart';
import 'package:tpjsonserver/services/room_service.dart';
import 'package:tpjsonserver/services/subject_service.dart';
import 'package:tpjsonserver/services/teacher_service.dart';
import 'models/session.dart';
import 'services/session_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Session Manager',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        cardTheme: const CardTheme(
          elevation: 4,
          margin: EdgeInsets.all(8),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          contentPadding: const EdgeInsets.all(16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titleTextStyle: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SessionGrid extends StatefulWidget {
  const SessionGrid({super.key});

  @override
  _SessionGridState createState() => _SessionGridState();
}

class _SessionGridState extends State<SessionGrid> {
  final SessionService _sessionService = SessionService();
  final RoomService _roomService = RoomService();
  final TeacherService _teacherService = TeacherService();
  final SubjectService _subjectService = SubjectService();
  final ClassService _classService = ClassService();

  List<Session> _sessions = [];
  List<Room> _rooms = [];
  List<Teacher> _teachers = [];
  List<Subject> _subjects = [];
  List<Class> _classes = [];

  @override
  void initState() {
    super.initState();
    _loadSessions();
    _loadRooms();
    _loadTeachers();
    _loadSubjects();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    try {
      final classes = await _classService.getClasses();
      setState(() {
        _classes = classes;
      });
      print('Classes: $_classes');
    } catch (e) {
      print('Error loading classes: $e');
    }
  }

  Future<void> _loadSubjects() async {
    try {
      final subjects = await _subjectService.getSubjects();
      setState(() {
        _subjects = subjects;
      });
      print('Subjects: $_subjects');
    } catch (e) {
      print('Error loading subjects: $e');
    }
  }

  Future<void> _loadTeachers() async {
    try {
      final teachers = await _teacherService.getTeachers();
      setState(() {
        _teachers = teachers;
      });
      print('Teachers: $_teachers');
    } catch (e) {
      print('Error loading teachers: $e');
    }
  }

  Future<void> _loadRooms() async {
    try {
      final rooms = await _roomService.getRooms();
      setState(() {
        _rooms = rooms.cast<Room>(); // Cast to List<Room>
      });
      print('Rooms: $_rooms');
    } catch (e) {
      print('Error loading rooms: $e');
    }
  }

  Future<void> _loadSessions() async {
    try {
      final sessions = await _sessionService.getSessions();
      setState(() {
        _sessions = sessions;
      });
    } catch (e) {
      print('Error loading sessions: $e');
    }
  }

  void _showAddSessionModal() {
    final formKey = GlobalKey<FormState>();
    String? selectedRoomId;
    String? selectedSubjectId;
    String? selectedTeacherId;
    String? selectedClassId;
    DateTime? selectedDate;
    TimeOfDay? startTime;
    TimeOfDay? endTime;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Session'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Room'),
                        value: selectedRoomId,
                        items: _rooms.map((Room room) {
                          return DropdownMenuItem<String>(
                            value: room.roomId,
                            child: Text('${room.roomName} (${room.building})'),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() => selectedRoomId = value);
                        },
                        validator: (value) => value == null ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Subject'),
                        value: selectedSubjectId,
                        items: _subjects.map((Subject subject) {
                          return DropdownMenuItem<String>(
                            value: subject.subjectId,
                            child: Text(subject.subjectName),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() => selectedSubjectId = value);
                        },
                        validator: (value) => value == null ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Teacher'),
                        value: selectedTeacherId,
                        items: _teachers.map((Teacher teacher) {
                          return DropdownMenuItem<String>(
                            value: teacher.teacherId,
                            child: Text(
                                '${teacher.firstName} ${teacher.lastName}'),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() => selectedTeacherId = value);
                        },
                        validator: (value) => value == null ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Class'),
                        value: selectedClassId,
                        items: _classes.map((Class classItem) {
                          return DropdownMenuItem<String>(
                            value: classItem.classId,
                            child: Text(classItem.className),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() => selectedClassId = value);
                        },
                        validator: (value) => value == null ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2024),
                            lastDate: DateTime(2025),
                          );
                          if (date != null) {
                            setState(() => selectedDate = date);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            selectedDate == null
                                ? 'Select Date'
                                : 'Date: ${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: startTime ?? TimeOfDay.now(),
                                );
                                if (time != null) {
                                  setState(() => startTime = time);
                                }
                              },
                              child: Text(startTime == null
                                  ? 'Start Time'
                                  : 'Start: ${startTime!.format(context)}'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: endTime ?? TimeOfDay.now(),
                                );
                                if (time != null) {
                                  setState(() => endTime = time);
                                }
                              },
                              child: Text(endTime == null
                                  ? 'End Time'
                                  : 'End: ${endTime!.format(context)}'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate() &&
                        selectedDate != null &&
                        startTime != null &&
                        endTime != null) {
                      final newSession = Session(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        sessionId:
                            DateTime.now().millisecondsSinceEpoch.toString(),
                        roomId: selectedRoomId!,
                        subjectId: selectedSubjectId!,
                        teacherId: selectedTeacherId!,
                        classId: selectedClassId!,
                        sessionDate: selectedDate!,
                        startTime: '${startTime!.hour}:${startTime!.minute}',
                        endTime: '${endTime!.hour}:${endTime!.minute}',
                      );

                      await _sessionService.createSession(newSession);
                      if (mounted) {
                        Navigator.pop(context);
                        _loadSessions();
                      }
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Updated _showAddRoomModal
  void _showAddRoomModal() {
    final formKey = GlobalKey<FormState>();
    String? roomId;
    String? roomName;
    int? capacity;
    String? building;
    int? floor;

    final controller = Get.put(RoomController(_roomService));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Room'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Room ID'),
                  onChanged: (value) => roomId = value,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Room Name'),
                  onChanged: (value) => roomName = value,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Capacity'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => capacity = int.tryParse(value),
                  validator: (value) => int.tryParse(value ?? '') == null
                      ? 'Enter valid number'
                      : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Building'),
                  onChanged: (value) => building = value,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Floor'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => floor = int.tryParse(value),
                  validator: (value) => int.tryParse(value ?? '') == null
                      ? 'Enter valid number'
                      : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            Obx(() {
              if (controller.isLoading.value) {
                return const CircularProgressIndicator();
              }
              return TextButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final newRoom = Room(
                      roomId: roomId!,
                      roomName: roomName!,
                      capacity: capacity!,
                      building: building!,
                      floor: floor!,
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                    );

                    final success = await controller.createRoom(newRoom);
                    if (success) {
                      Navigator.pop(context);
                      await _loadRooms();
                    } else {
                      Get.snackbar(
                        'Error',
                        controller.error.value,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  }
                },
                child: const Text('Add'),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Schedule'),
        actions: [
          // User profile button
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).primaryColor.withOpacity(0.1),
                          Theme.of(context).primaryColor.withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            AuthService.currentUser?.name[0].toUpperCase() ??
                                'U',
                            style: const TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          AuthService.currentUser?.name ?? 'User',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildInfoRow(
                                Icons.email,
                                'Email',
                                AuthService.currentUser?.email ?? 'N/A',
                              ),
                              const Divider(height: 20),
                              _buildInfoRow(
                                Icons.school,
                                'School',
                                AuthService.currentUser?.school ?? 'N/A',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

// Add this helper method in the class

          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService.logout();
              if (mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ElevatedButton(
          //   onPressed: _showAddRoomModal,
          //   child: const Text('Add Room'),
          // ),
          Expanded(
            child: ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                  child: DataTable(
                    columnSpacing: 0,
                    horizontalMargin: 0,
                    columns: [
                      DataColumn(
                        label: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: const Text('Time'),
                        ),
                      ),
                      ...[
                        'Monday',
                        'Tuesday',
                        'Wednesday',
                        'Thursday',
                        'Friday'
                      ].map(
                        (day) => DataColumn(
                          label: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.17,
                            child: Text(day),
                          ),
                        ),
                      ),
                    ],
                    rows: _buildTableRows(),
                  ),
                ),
              ),
            ),
          ),
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: DataTable(
          //     columns: const [
          //       DataColumn(label: Text('Time')),
          //       DataColumn(label: Text('Monday')),
          //       DataColumn(label: Text('Tuesday')),
          //       DataColumn(label: Text('Wednesday')),
          //       DataColumn(label: Text('Thursday')),
          //       DataColumn(label: Text('Friday')),
          //     ],
          //     rows: _buildTableRows(),
          //   ),
          // ),
          // // ElevatedButton(
          // //   onPressed: _showAddSessionModal,
          // //   child: const Text('Add New Session'),
          // // ),
        ],
      ),

      floatingActionButton: AuthService.isAdmin()
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: _showAddRoomModal,
                  child: const Icon(Icons.room),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: _showAddSessionModal,
                  child: const Icon(Icons.add),
                ),
              ],
            )
          : null, // Hide buttons for non-admin users
    );
  }

  List<DataRow> _buildTableRows() {
    Map<String, List<Session>> sessionsByTime = {};

    for (var session in _sessions) {
      String timeSlot = '${session.startTime}-${session.endTime}';
      sessionsByTime.putIfAbsent(timeSlot, () => []);
      sessionsByTime[timeSlot]!.add(session);
    }

    return sessionsByTime.entries.map((entry) {
      return DataRow(
        cells: [
          DataCell(Text(entry.key)),
          ...List.generate(5, (index) {
            var session = entry.value.firstWhere(
              (s) => s.sessionDate.weekday == index + 1,
              orElse: () => Session(
                sessionId: '',
                subjectId: '',
                teacherId: '',
                roomId: '',
                classId: '',
                sessionDate: DateTime.now(),
                startTime: '',
                endTime: '',
                id: '',
              ),
            );
            return DataCell(
              session.sessionId.isEmpty
                  ? const SizedBox()
                  : InkWell(
                      onTap: () => _showEditSessionModal(session),
                      child: Text('${session.subjectId}\n${session.roomId}'),
                    ),
            );
          }),
        ],
      );
    }).toList();
  }

  void _showEditSessionModal(Session session) {
    final formKey = GlobalKey<FormState>();
    String? selectedRoomId = session.roomId;
    String? selectedSubjectId = session.subjectId;
    String? selectedTeacherId = session.teacherId;
    String? selectedClassId = session.classId;
    DateTime? selectedDate = session.sessionDate;
    TimeOfDay? startTime = TimeOfDay(
        hour: int.parse(session.startTime.split(':')[0]),
        minute: int.parse(session.startTime.split(':')[1]));
    TimeOfDay? endTime = TimeOfDay(
        hour: int.parse(session.endTime.split(':')[0]),
        minute: int.parse(session.endTime.split(':')[1]));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Session'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Room'),
                        value: selectedRoomId,
                        items: _rooms.map((Room room) {
                          return DropdownMenuItem<String>(
                            value: room.roomId,
                            child: Text('${room.roomName} (${room.building})'),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() => selectedRoomId = value);
                        },
                        validator: (value) => value == null ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Subject'),
                        value: selectedSubjectId,
                        items: _subjects.map((Subject subject) {
                          return DropdownMenuItem<String>(
                            value: subject.subjectId,
                            child: Text(subject.subjectName),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() => selectedSubjectId = value);
                        },
                        validator: (value) => value == null ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Teacher'),
                        value: selectedTeacherId,
                        items: _teachers.map((Teacher teacher) {
                          return DropdownMenuItem<String>(
                            value: teacher.teacherId,
                            child: Text(
                                '${teacher.firstName} ${teacher.lastName}'),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() => selectedTeacherId = value);
                        },
                        validator: (value) => value == null ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Class'),
                        value: selectedClassId,
                        items: _classes.map((Class classItem) {
                          return DropdownMenuItem<String>(
                            value: classItem.classId,
                            child: Text(classItem.className),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() => selectedClassId = value);
                        },
                        validator: (value) => value == null ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        onPressed: () async {
                          // Use the correct BuildContext
                          final date = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? DateTime.now(),
                            firstDate:
                                DateTime(2024), // Set appropriate start year
                            lastDate:
                                DateTime(2025), // Set appropriate end year
                          );
                          print('Date picked: $date'); // Debug print
                          if (date != null && mounted) {
                            setState(() {
                              selectedDate = date;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            selectedDate == null
                                ? 'Select Date'
                                : 'Date: ${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: startTime ?? TimeOfDay.now(),
                                );
                                if (time != null) {
                                  setState(() => startTime = time);
                                }
                              },
                              child: Text(startTime == null
                                  ? 'Start Time'
                                  : 'Start: ${startTime!.format(context)}'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: endTime ?? TimeOfDay.now(),
                                );
                                if (time != null) {
                                  setState(() => endTime = time);
                                }
                              },
                              child: Text(endTime == null
                                  ? 'End Time'
                                  : 'End: ${endTime!.format(context)}'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    // Show delete confirmation dialog
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Session'),
                        content: const Text(
                            'Are you sure you want to delete this session?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true && mounted) {
                      try {
                        await _sessionService.deleteSession(session.id);
                        if (mounted) {
                          Navigator.pop(context); // Close edit modal
                          await _loadSessions(); // Refresh sessions
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Session deleted successfully')),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Failed to delete session: $e')),
                          );
                        }
                      }
                    }
                  },
                  child:
                      const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate() &&
                        selectedDate != null &&
                        startTime != null &&
                        endTime != null) {
                      final updatedSession = Session(
                        id: session.id,
                        sessionId: session.sessionId,
                        roomId: selectedRoomId!,
                        subjectId: selectedSubjectId!,
                        teacherId: selectedTeacherId!,
                        classId: selectedClassId!,
                        sessionDate: selectedDate!,
                        startTime: '${startTime!.hour}:${startTime!.minute}',
                        endTime: '${endTime!.hour}:${endTime!.minute}',
                      );

                      await _sessionService.updateSession(updatedSession);
                      if (mounted) {
                        Navigator.pop(context);
                        _loadSessions();
                      }
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
