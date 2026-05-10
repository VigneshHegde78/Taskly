import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/task_model.dart';
import '../models/quote_model.dart';
import '../screens/add_task_screen.dart';
import '../services/task_service.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService _taskService = TaskService();
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();

  QuoteModel? _quote;
  bool _isLoadingQuote = true;
  
  bool _isEditingName = false;
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _fetchQuote();
    _nameController.text = FirebaseAuth.instance.currentUser?.displayName ?? "User";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchQuote() async {
    try {
      final quote = await _apiService.getRandomQuote();
      if (mounted) {
        setState(() {
          _quote = quote;
          _isLoadingQuote = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingQuote = false);
      }
    }
  }

  Future<void> _updateName() async {
    final newName = _nameController.text.trim();
    if (newName.isNotEmpty && newName != FirebaseAuth.instance.currentUser?.displayName) {
      await FirebaseAuth.instance.currentUser?.updateDisplayName(newName);
      await FirebaseAuth.instance.currentUser?.reload();
    }
    if (mounted) {
      setState(() => _isEditingName = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TaskModel>>(
      stream: _taskService.getTasks(),
      builder: (context, snapshot) {
        final tasks = snapshot.data ?? [];
        final now = DateTime.now();
        final todayTasksCount = tasks
            .where((t) =>
                t.date.year == now.year &&
                t.date.month == now.month &&
                t.date.day == now.day)
            .length;

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 90,
            titleSpacing: 24,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isEditingName = true;
                      _nameFocusNode.requestFocus();
                    });
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _isEditingName
                        ? SizedBox(
                            width: 200,
                            child: TextField(
                              controller: _nameController,
                              focusNode: _nameFocusNode,
                              autofocus: true,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                fillColor: Colors.transparent,
                                hintText: "Your Name",
                              ),
                              onSubmitted: (_) => _updateName(),
                              onTapOutside: (_) => _updateName(),
                            ),
                          )
                        : Text(
                            "Hello, ${FirebaseAuth.instance.currentUser?.displayName ?? "User"}! 👋",
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.black54,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  todayTasksCount > 0
                      ? "$todayTasksCount tasks today"
                      : "No tasks today",
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.black,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  onPressed: () async => await _authService.logout(),
                  icon: const Icon(Icons.logout_rounded, color: Colors.black87),
                  tooltip: "Logout",
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            elevation: 4,
            backgroundColor: const Color(0xFF6C63FF),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddTaskScreen()),
              );
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text("Add Task", style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
          body: RefreshIndicator(
            onRefresh: _fetchQuote,
            color: const Color(0xFF6C63FF),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  sliver: SliverToBoxAdapter(
                    child: _buildQuoteCard(),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 20),
                      child: Text(
                        "Your Tasks",
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                _buildSliverTaskList(snapshot, tasks),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuoteCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: _isLoadingQuote
          ? const Center(child: SizedBox(height: 40, child: CircularProgressIndicator.adaptive()))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _quote != null
                      ? "“${_quote!.content}”"
                      : "“Stay focused and never give up.”",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    height: 1.6,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    _quote != null ? "- ${_quote!.author}" : "- Unknown",
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.black45,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSliverTaskList(AsyncSnapshot<List<TaskModel>> snapshot, List<TaskModel> tasks) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const SliverToBoxAdapter(
        child: Center(child: Padding(
          padding: EdgeInsets.all(40.0),
          child: CircularProgressIndicator.adaptive(),
        )),
      );
    }
    
    if (snapshot.hasError) {
      return SliverToBoxAdapter(
        child: Center(
          child: Text("Unable to load tasks", style: TextStyle(color: Colors.red[400])),
        ),
      );
    }

    if (tasks.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Icon(Icons.assignment_turned_in_outlined, size: 64, color: Colors.black12),
              const SizedBox(height: 16),
              Text(
                "No tasks for today",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.black38,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final task = tasks[index];
            return _buildTaskItem(task);
          },
          childCount: tasks.length,
        ),
      ),
    );
  }

  Widget _buildTaskItem(TaskModel task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: task.completed ? Colors.green.withOpacity(0.3) : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: task.completed,
                  activeColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  side: const BorderSide(color: Colors.black26, width: 1.5),
                  onChanged: (value) => _taskService.toggleTask(task.id, value!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  task.title,
                  style: GoogleFonts.plusJakartaSans(
                    color: task.completed ? Colors.black45 : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    decoration: task.completed ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddTaskScreen(taskToEdit: task),
                    ),
                  );
                },
                icon: const Icon(Icons.edit_rounded, color: Colors.blueAccent, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () => _taskService.deleteTask(task.id),
                icon: const Icon(Icons.delete_rounded, color: Colors.redAccent, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          if (task.description.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 8, bottom: 8),
              child: Text(
                task.description,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.black54,
                  fontSize: 14,
                  height: 1.4,
                  decoration: task.completed ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.only(left: 40, top: 4),
            child: Row(
              children: [
                const Icon(Icons.calendar_month_rounded, color: Colors.black26, size: 14),
                const SizedBox(width: 6),
                Text(
                  "${task.date.day}/${task.date.month}/${task.date.year}",
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.black26,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
