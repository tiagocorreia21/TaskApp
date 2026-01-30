import { useState } from 'react';
import './TaskForm.css';

function TaskForm({ onSubmit }) {
  const [identifier, setIdentifier] = useState('');
  const [title, setTitle] = useState('');
  const [submitting, setSubmitting] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (!identifier.trim() || !title.trim()) {
      alert('Please fill in all fields');
      return;
    }

    setSubmitting(true);
    const success = await onSubmit(identifier.trim(), title.trim());

    if (success) {
      setIdentifier('');
      setTitle('');
    }

    setSubmitting(false);
  };

  return (
    <form className="task-form" onSubmit={handleSubmit}>
      <h2>Create New Task</h2>
      <div className="form-row">
        <div className="form-group">
          <label htmlFor="identifier">Identifier</label>
          <input
            type="text"
            id="identifier"
            value={identifier}
            onChange={(e) => setIdentifier(e.target.value)}
            placeholder="e.g., TASK-001"
            disabled={submitting}
            required
          />
        </div>

        <div className="form-group">
          <label htmlFor="title">Title</label>
          <input
            type="text"
            id="title"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            placeholder="Task description"
            disabled={submitting}
            required
          />
        </div>

        <button
          type="submit"
          className="btn-submit"
          disabled={submitting}
        >
          {submitting ? 'Creating...' : '+ Add Task'}
        </button>
      </div>
    </form>
  );
}

export default TaskForm;
