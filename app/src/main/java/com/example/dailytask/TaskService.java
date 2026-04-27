package com.example.dailytask;

import android.content.Context;
import java.util.ArrayList;
import java.util.List;

public class TaskService {

    public TaskService(Context context) {
    }

    public long addTask(Task task) {
        return -1;
    }

    public Task getTask(int id) {
        List<Task> tasks = getAllTasks();
        for (Task task : tasks) {
            if (task.getId() == id) {
                return task;
            }
        }
        return null;
    }

    public List<Task> getAllTasks() {
        List<Task> tasks = new ArrayList<>();
        tasks.add(new Task(1, "Morning Walk", "Enjoy a 30-minute walk in the park."));
        tasks.add(new Task(2, "Read a Book", "Read at least 20 pages of your favorite book."));
        tasks.add(new Task(3, "Code Review", "Review the latest pull requests on GitHub."));
        return tasks;
    }

    public int updateTask(Task task) {
        return 0;
    }

    public void deleteTask(int id) {
    }
}

