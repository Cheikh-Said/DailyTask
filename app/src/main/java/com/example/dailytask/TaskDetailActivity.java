package com.example.dailytask;

import android.os.Bundle;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import com.google.android.material.appbar.MaterialToolbar;

public class TaskDetailActivity extends AppCompatActivity {

    public static final String EXTRA_TASK = "extra_task";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_detail);

        MaterialToolbar toolbar = findViewById(R.id.toolbar_task_detail);
        setSupportActionBar(toolbar);
        if (getSupportActionBar() != null) {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        }

        TextView taskNameView = findViewById(R.id.text_task_name);
        TextView taskDescriptionView = findViewById(R.id.text_task_description);

        Task task = (Task) getIntent().getSerializableExtra(EXTRA_TASK);
        if (task == null) {
            taskNameView.setText(getString(R.string.task_unknown_title));
            taskDescriptionView.setText(getString(R.string.task_unknown_description));
            return;
        }

        String taskName = task.getName();
        if (taskName == null || taskName.trim().isEmpty()) {
            taskName = getString(R.string.task_unknown_title);
        }
        taskNameView.setText(taskName);
        taskDescriptionView.setText(
                task.getDescription() != null ? task.getDescription() : getString(R.string.task_unknown_description)
        );
    }

    @Override
    public boolean onSupportNavigateUp() {
        finish();
        return true;
    }
}
