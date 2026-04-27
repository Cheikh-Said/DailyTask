package com.example.dailytask;

import android.os.Bundle;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.google.android.material.appbar.MaterialToolbar;

public class AddTaskActivity extends AppCompatActivity {

    private TaskService taskService;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_task);

        taskService = new TaskService(this);

        MaterialToolbar toolbar = findViewById(R.id.toolbar_add_task);
        setSupportActionBar(toolbar);
        if (getSupportActionBar() != null) {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        }

        EditText titleInput = findViewById(R.id.edit_task_title);
        EditText descriptionInput = findViewById(R.id.edit_task_description);
        Button saveButton = findViewById(R.id.button_save_task);

        saveButton.setOnClickListener(view -> {
            String title = titleInput.getText().toString().trim();
            String description = descriptionInput.getText().toString().trim();

            if (title.isEmpty()) {
                titleInput.setError(getString(R.string.error_title_required));
                return;
            }

            Task task = new Task();
            task.setName(title);
            task.setDescription(description);

            long id = taskService.addTask(task);
            if (id > 0) {
                Toast.makeText(AddTaskActivity.this, R.string.toast_task_saved, Toast.LENGTH_SHORT).show();
                finish();
            } else {
                Toast.makeText(AddTaskActivity.this, R.string.error_saving_task, Toast.LENGTH_SHORT).show();
            }
        });
    }

    @Override
    public boolean onSupportNavigateUp() {
        finish();
        return true;
    }
}
