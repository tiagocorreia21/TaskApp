const API_URL = 'http://localhost:4000/api';

export const taskService = {
  // Create a new task
  async createTask(identifier, title) {
    const response = await fetch(`${API_URL}/tasks`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ identifier, title }),
    });

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || 'Failed to create task');
    }

    return response.json();
  },

  // Get all tasks
  async getAllTasks() {
    const response = await fetch(`${API_URL}/tasks`);

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || 'Failed to fetch tasks');
    }

    return response.json();
  },

  // Get task by ID
  async getTaskById(id) {
    const response = await fetch(`${API_URL}/tasks/${id}`);

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || 'Failed to fetch task');
    }

    return response.json();
  },

  // Complete a task
  async completeTask(id) {
    const response = await fetch(`${API_URL}/tasks/${id}/complete`, {
      method: 'PATCH',
    });

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || 'Failed to complete task');
    }

    return response.json();
  },

  // Delete a task
  async deleteTask(id) {
    const response = await fetch(`${API_URL}/tasks/${id}`, {
      method: 'DELETE',
    });

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || 'Failed to delete task');
    }

    return response.json();
  },
};
