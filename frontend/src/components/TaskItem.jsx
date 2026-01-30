import './TaskItem.css';

function TaskItem({ task, onComplete, onDelete }) {
  const handleComplete = () => {
    if (!task.completed) {
      onComplete(task.identifier);
    }
  };

  const handleDelete = () => {
    if (window.confirm(`Are you sure you want to delete task "${task.title}"?`)) {
      onDelete(task.identifier);
    }
  };

  return (
    <div className={`task-item ${task.completed ? 'completed' : ''}`}>
      <div className="task-content">
        <div className="task-header">
          <span className="task-identifier">{task.identifier}</span>
          <span className={`task-status ${task.completed ? 'status-completed' : 'status-pending'}`}>
            {task.completed ? '✓ Completed' : '○ Pending'}
          </span>
        </div>
        <h3 className="task-title">{task.title}</h3>
      </div>

      <div className="task-actions">
        {!task.completed && (
          <button
            className="btn-complete"
            onClick={handleComplete}
            title="Mark as completed"
          >
            ✓ Complete
          </button>
        )}
        <button
          className="btn-delete"
          onClick={handleDelete}
          title="Delete task"
        >
          🗑 Delete
        </button>
      </div>
    </div>
  );
}

export default TaskItem;
