package com.example.dailytask;

import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.RecyclerView;

import com.google.android.material.appbar.MaterialToolbar;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity {

    private TaskService taskService;
    private TaskAdapter adapter;
    private List<Task> tasks;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        taskService = new TaskService(this);

        MaterialToolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setTitle("DailyTask");
        RecyclerView recyclerView = findViewById(R.id.recycler_view_tasks);

        tasks = new ArrayList<>();
        adapter = new TaskAdapter(tasks, task -> {
            Intent intent = new Intent(MainActivity.this, TaskDetailActivity.class);
            intent.putExtra(TaskDetailActivity.EXTRA_TASK, task);
            startActivity(intent);
            Toast.makeText(
                    MainActivity.this,
                    getString(R.string.toast_opening, task.getName()),
                    Toast.LENGTH_SHORT
            ).show();
        });
        recyclerView.setAdapter(adapter);

        FloatingActionButton fab = findViewById(R.id.fab_add_task);
        fab.setOnClickListener(view -> {
            Intent intent = new Intent(MainActivity.this, AddTaskActivity.class);
            startActivity(intent);
            Toast.makeText(MainActivity.this, R.string.toast_add_task, Toast.LENGTH_SHORT).show();
        });

        // Start ReminderService for delayed notification
        Intent serviceIntent = new Intent(this, ReminderService.class);
        startService(serviceIntent);
    }

    @Override
    protected void onResume() {

        super.onResume();
        loadTasks();
    }

    private void loadTasks() {
        adapter.updateTasks(taskService.getAllTasks());
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == R.id.action_about) {
            Intent intent = new Intent(MainActivity.this, AboutActivity.class);
            startActivity(intent);
            return true;
        }
        return super.onOptionsItemSelected(item);
    }
}

