import { useState, useEffect } from 'react';
import { taskService } from '../services/taskService';
import TaskItem from './TaskItem';
import TaskForm from './TaskForm';
import './TaskList.css';

function TaskList() {
  const [tasks, setTasks] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // Load tasks on component mount
  useEffect(() => {
    loadTasks();
  }, []);

  const loadTasks = async () => {
    try {
      setLoading(true);
      setError(null);
      const data = await taskService.getAllTasks();
      setTasks(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleCreateTask = async (identifier, title) => {
    try {
      await taskService.createTask(identifier, title);
      await loadTasks();
      return true;
    } catch (err) {
      setError(err.message);
      return false;
    }
  };

  const handleCompleteTask = async (identifier) => {
    try {
      await taskService.completeTask(identifier);
      await loadTasks();
    } catch (err) {
      setError(err.message);
    }
  };

  const handleDeleteTask = async (identifier) => {
    try {
      await taskService.deleteTask(identifier);
      await loadTasks();
    } catch (err) {
      setError(err.message);
    }
  };

  if (loading) {
    return <div className="task-list-container">
      <div className="loading">Loading tasks...</div>
    </div>;
  }

  return (
    <div className="task-list-container">
      <h1>Task Manager</h1>

      {error && (
        <div className="error-message">
          {error}
          <button onClick={() => setError(null)}>×</button>
        </div>
      )}

      <TaskForm onSubmit={handleCreateTask} />

      <div className="task-list">
        <h2>Tasks ({tasks.length})</h2>
        {tasks.length === 0 ? (
          <p className="no-tasks">No tasks yet. Create one above!</p>
        ) : (
          tasks.map(task => (
            <TaskItem
              key={task.identifier}
              task={task}
              onComplete={handleCompleteTask}
              onDelete={handleDeleteTask}
            />
          ))
        )}
      </div>
    </div>
  );
}

export default TaskList;
